import Foundation
import Vision
import UIKit
import GoogleGenerativeAI

class UserDetailAutoView {
    
    func extractText(from image: UIImage) async -> String {
        return await withCheckedContinuation { continuation in
            // Convert UIImage to CGImage
            guard let cgImage = image.cgImage else {
                print("Failed to get CGImage from UIImage")
                continuation.resume(returning: "")
                return
            }

            let request = VNRecognizeTextRequest { (request, error) in
                if let error = error {
                    print("Error during text recognition: \(error.localizedDescription)")
                    continuation.resume(returning: "")
                    return
                }

                if let observations = request.results as? [VNRecognizedTextObservation] {
                    let extractedText = self.processObservations(observations)
                    print("Extracted Text:\n\(extractedText)")
                    continuation.resume(returning: extractedText)
                } else {
                    continuation.resume(returning: "")
                }
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([request])
            } catch {
                print("Failed to perform text recognition request: \(error.localizedDescription)")
                continuation.resume(returning: "")
            }
        }
    }
    
    private func processObservations(_ observations: [VNRecognizedTextObservation]) -> String {
        var fullText = ""
        for observation in observations {
            if let topCandidate = observation.topCandidates(1).first {
                fullText += topCandidate.string + "\n"
            }
        }
        return fullText
    }
    
    public func generateTextForPrompt(promptText: String) async -> String {
        // Create a detailed prompt for resume information extraction
        let prompt = """
            You are a professional resume analyzer. Given the following resume text, extract and organize the details into a JSON dictionary with the following structure:
            
            {
                "Name": "Full name of the person",
                "Contact": "phone number (or empty string if not available)",
                "Email":"get the email"
                "Summary": "Short career summary (or empty string if not available)",
                "Skills": ["Skill1", "Skill2", "..."],
                "Experience": [
                    {
                        "Position": "Job position",
                        "Company": "Company name",
                        "Dates": "Duration or dates",
                        "Responsibilities": "Key responsibilities"
                    },
                    ...
                ],
                "Education": [
                    {
                        "Degree": "Degree name",
                        "Institution": "Institution name",
                        "Dates": "Duration or dates"
                    },
                    ...
                ],
                "Certifications": ["Certification1", "Certification2", "..."],
                "Languages": ["Language1", "Language2", "..."],
                "Projects": [
                    {
                        "Title": "Project title",
                        "Description": "Project description"
                    },
                    ...
                ],
                "Awards": ["Award1", "Award2", "..."]
            }
            
            Return only the JSON dictionary. Do not include any extra text outside or before the JSON structure.
            Please do not include any backticks. just send the json.

            Resume text:
            \(promptText)
            """
        
        let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? ""
        let model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                return text
            } else {
                return "Empty"
            }
        } catch {
            print("Error generating content: \(error)")
            return "Error"
        }
    }
    
    func storeResumeToUserDefaults(jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8) {
            UserDefaults.standard.set(jsonData, forKey: "resumeData")
            print("Resume stored in UserDefaults")
        } else {
            print("Failed to convert JSON string to Data")
        }
    }
    
    func deleteAllUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
            print("All UserDefaults data has been deleted")
        } else {
            print("Failed to get the app domain")
        }
    }
}

class ResumeViewModel: ObservableObject {
    @Published var resume: String

    init(resume: String) {
        self.resume = resume
    }
}

class UserPreference {
    static let shared = UserPreference()
    var shouldLoadUserDetailsAutomatically: Bool = false
}
