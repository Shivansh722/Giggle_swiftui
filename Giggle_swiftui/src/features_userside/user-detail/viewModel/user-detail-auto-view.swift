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
        
        let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "AIzaSyDDTPOZonoyL72gpye_bczBg90XLdXlBUs")
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
        UserDefaults.standard.removeObject(forKey: "resumeData")
        print("Previous resume data removed from UserDefaults")
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

import Foundation

class QuestionViewModel: ObservableObject {
    @Published var numeracyQuestions: [Question] = []
    @Published var literacyQuestions: [Question] = []

    struct Question: Identifiable, Hashable, Codable {
        let id = UUID()
        let question: String
        let options: [String]
        let correctAnswer: String

        enum CodingKeys: String, CodingKey {
            case question, options
            case correctAnswer = "correct_answer" // Match API response key
        }
    }

    struct GeneratedQuestions: Codable {
        let numeracy: [Question]
        let literacy: [Question]
    }

    func getQuestion(_ resume: String) async {
        let prompt = """
        You are an expert in generating assessment questions based on a candidate's resume. Given the following resume, create two separate arrays of multiple-choice questions (MCQs):

        1. **Numeracy (Math & Technical Questions)**:  
           - Include questions based on the candidate's technical skills (e.g., programming languages, frameworks, databases, AI tools).  
           - Also include general mathematics questions at a **10th-grade level**, covering topics like algebra, geometry, probability, and basic statistics. 
                - give 5 question

        2. **Literacy (Language-Specific Questions)**:  
           - If the resume specifies a language proficiency (e.g., French, Spanish, Hindi), create questions related to that language’s grammar, vocabulary, and comprehension.  
           - If no specific language is mentioned, generate standard English grammar and comprehension questions. 
            - give 5 question

        **Resume Text:**  
        \(resume)

        **Expected JSON Output Format:**  
        {
          "numeracy": [
            {
              "question": "Solve: If x + 5 = 12, what is the value of x?",
              "options": ["5", "6", "7", "8"],
              "correct_answer": "7"
            },
            {
              "question": "Which framework is commonly used in FastAPI to define and validate request bodies?",
              "options": ["Django", "Pydantic", "Flask", "SQLAlchemy"],
              "correct_answer": "Pydantic"
            }
          ],
          "literacy": [
            {
              "question": "Identify the correctly spelled word.",
              "options": ["Recieve", "Recieve", "Receive", "Recive"],
              "correct_answer": "Receive"
            },
            {
              "question": "What is the Spanish translation for 'Hello'?",
              "options": ["Hola", "Bonjour", "Ciao", "Hallo"],
              "correct_answer": "Hola"
            }
          ]
        }

        Return only the JSON.  
        Do not include any backticks—just send the JSON.
        """


        let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "AIzaSyDDTPOZonoyL72gpye_bczBg90XLdXlBUs")

        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text, let jsonData = text.data(using: .utf8) {
                let decodedResponse = try JSONDecoder().decode(GeneratedQuestions.self, from: jsonData)

                // Update questions in the main thread
                DispatchQueue.main.async {
                    self.numeracyQuestions = decodedResponse.numeracy
                    self.literacyQuestions = decodedResponse.literacy
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}


