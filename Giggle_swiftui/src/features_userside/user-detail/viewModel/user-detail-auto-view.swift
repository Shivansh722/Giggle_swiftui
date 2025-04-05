import Foundation
import GoogleGenerativeAI
import UIKit
import Vision

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
                    print(
                        "Error during text recognition: \(error.localizedDescription)"
                    )
                    continuation.resume(returning: "")
                    return
                }

                if let observations = request.results
                    as? [VNRecognizedTextObservation]
                {
                    let extractedText = self.processObservations(observations)
                    print("Extracted Text:\n\(extractedText)")
                    continuation.resume(returning: extractedText)
                } else {
                    continuation.resume(returning: "")
                }
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let requestHandler = VNImageRequestHandler(
                cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([request])
            } catch {
                print(
                    "Failed to perform text recognition request: \(error.localizedDescription)"
                )
                continuation.resume(returning: "")
            }
        }
    }

    private func processObservations(
        _ observations: [VNRecognizedTextObservation]
    ) -> String {
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

        let model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: "AIzaSyDDTPOZonoyL72gpye_bczBg90XLdXlBUs")
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

class FluencyResult: ObservableObject {
    struct EvaluationResult: Decodable {
        let CoherencePer: Double
        let GrammarPer: Double
        let VocabularyPer: Double
        let PronunciationPer: Double
        let coherenceContent: String
        let grammarContent: String
        let vocabularyContent: String
        let pronunciationContent: String
    }

    func getFluencyResult() async throws {
        let trancript = FlnDataManager.shared.flnData.transcriptionHistory
        let transcript = FlnDataManager.shared.flnData.transcriptionHistory
        print("ksdjkfdjs",trancript)
        let prompt = """
        You are an English language assessment assistant. Analyze the following speech transcription history, which includes both the spoken text and the time-related metadata (timestamps and time gaps between words). Use this information to assess the speaker's fluency and overall spoken English skills.

        Each entry contains:
        - text: Cumulative transcript spoken so far.
        - timestamp: Time (in seconds) since the start of recording when this was spoken.
        - timeSinceLast: The time difference (in seconds) since the previous entry.

        Using this information, provide a detailed evaluation with the following:

        1. "CoherencePer": Percentage (0-100) score indicating how logically and clearly the speaker expresses ideas and maintains flow in speech.
        2. "GrammarPer": Percentage score evaluating grammatical accuracy and sentence structure.
        3. "VocabularyPer": Percentage score evaluating the range and contextual appropriateness of vocabulary.
        4. "PronunciationPer": Percentage score evaluating clarity, accuracy, and naturalness of pronunciation.

        In addition, provide a **short but specific content explanation** for each category:
        - "coherenceContent"
        - "grammarContent"
        - "vocabularyContent"
        - "pronunciationContent"

        **Fluency tips:**
        - Fast or natural timeSinceLast values (e.g., < 0.5s) may indicate fluent speech.
        - Frequent long pauses or irregular rhythm (e.g., > 1s) may suggest hesitation or disfluency.
        - Consider how pauses affect coherence and pronunciation flow.

        Here is the transcription history:

        \(transcript)

        Return a valid JSON object only with the keys:
        "CoherencePer", "GrammarPer", "VocabularyPer", "PronunciationPer", "coherenceContent", "grammarContent", "vocabularyContent", "pronunciationContent"

        Do not include any text outside the JSON response. No explanations, headers, or backticks.
        """


        let model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: "AIzaSyDDTPOZonoyL72gpye_bczBg90XLdXlBUs")
        do {
            let response = try await model.generateContent(prompt)

            guard var text = response.text else {
                print("No response text from Gemini.")
                return
            }

            // 🧹 Clean text: Remove backticks, leading/trailing whitespaces
            text = text.replacingOccurrences(of: "```json", with: "")
            text = text.replacingOccurrences(of: "```", with: "")
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)

            guard let jsonData = text.data(using: .utf8) else {
                print("Failed to convert cleaned text to Data.")
                return
            }

            let result = try JSONDecoder().decode(
                EvaluationResult.self, from: jsonData)

            // Set values in data manager
            DispatchQueue.main.async {
                
                FlnDataManager.shared.flnData.CoherencePer = result.CoherencePer
                FlnDataManager.shared.flnData.GrammarPer = result.GrammarPer
                FlnDataManager.shared.flnData.VocabularyPer = result.VocabularyPer
                FlnDataManager.shared.flnData.PronunciationPer = result.PronunciationPer
                FlnDataManager.shared.flnData.coherenceCOntent = result.coherenceContent
                FlnDataManager.shared.flnData.grammarContent = result.grammarContent
                FlnDataManager.shared.flnData.vocabularyContent = result.vocabularyContent
                FlnDataManager.shared.flnData.pronunciationContent = result.pronunciationContent
                
                let avgScore = (result.CoherencePer + result.GrammarPer + result.VocabularyPer + result.PronunciationPer) / 4.0
                FlnDataManager.shared.flnData.fluencyScore = String(avgScore)
                print(FlnDataManager.shared.flnData.vocabularyContent)
                print(FlnDataManager.shared.flnData.CoherencePer)
                print(FlnDataManager.shared.flnData.pronunciationContent)
            }
        } catch {
            print("Error during fluency result processing: \(error)")
        }

    }
}

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
            case correctAnswer = "correct_answer"  // Match API response key
        }
    }

    struct GeneratedQuestions: Codable {
        let numeracy: [Question]
        let literacy: [Question]
    }

    private let defaultNumeracyQuestions: [Question] = [
        Question(
            question: "What is 15% of 200?",
            options: ["20", "30", "25", "35"],
            correctAnswer: "30"),
        Question(
            question: "If 2x + 3 = 7, what is x?",
            options: ["1", "2", "3", "4"],
            correctAnswer: "2"),
        Question(
            question:
                "What is the area of a rectangle with length 5 and width 3?",
            options: ["15", "16", "8", "10"],
            correctAnswer: "15"),
        Question(
            question:
                "If a die is rolled, what’s the probability of getting a 6?",
            options: ["1/3", "1/4", "1/6", "1/2"],
            correctAnswer: "1/6"),
        Question(
            question: "What is 3² + 4²?",
            options: ["20", "25", "15", "10"],
            correctAnswer: "25"),
    ]

    private let defaultLiteracyQuestions: [Question] = [
        Question(
            question: "Which word is a synonym for 'happy'?",
            options: ["Sad", "Joyful", "Angry", "Tired"],
            correctAnswer: "Joyful"),
        Question(
            question: "What is the plural of 'child'?",
            options: ["Childs", "Children", "Childes", "Child"],
            correctAnswer: "Children"),
        Question(
            question: "Which sentence is grammatically correct?",
            options: [
                "She run fast", "She runs fast", "She running fast",
                "She runned fast",
            ],
            correctAnswer: "She runs fast"),
        Question(
            question: "What is the opposite of 'big'?",
            options: ["Large", "Huge", "Small", "Tall"],
            correctAnswer: "Small"),
        Question(
            question: "Which word is spelled correctly?",
            options: ["Recieve", "Receive", "Recive", "Receeve"],
            correctAnswer: "Receive"),
    ]

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
                }
              ],
              "literacy": [
                {
                  "question": "Identify the correctly spelled word.",
                  "options": ["Recieve", "Recieve", "Receive", "Recive"],
                  "correct_answer": "Receive"

                }
              ]
            }
            Return only the JSON dictionary. Do not include any extra text outside or before the JSON structure.
            Please do not include any backticks. just send the json.
            """

        let model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: "AIzaSyDDTPOZonoyL72gpye_bczBg90XLdXlBUs")

        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text, let jsonData = text.data(using: .utf8)
            {
                let decodedResponse = try JSONDecoder().decode(
                    GeneratedQuestions.self, from: jsonData)

                // Update questions in the main thread
                DispatchQueue.main.async {
                    self.numeracyQuestions = decodedResponse.numeracy
                    self.literacyQuestions = decodedResponse.literacy
                }
            } else {
                // Fallback to default questions if response is invalid
                DispatchQueue.main.async {
                    self.numeracyQuestions = self.defaultNumeracyQuestions
                    self.literacyQuestions = self.defaultLiteracyQuestions
                }
            }
        } catch {
            print("Error: \(error)")
            DispatchQueue.main.async {
                self.numeracyQuestions = self.defaultNumeracyQuestions
                self.literacyQuestions = self.defaultLiteracyQuestions
            }
        }
    }
}
