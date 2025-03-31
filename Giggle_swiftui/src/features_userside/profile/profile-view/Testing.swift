import SwiftUI

struct Testing: View {
    @StateObject var testResumeGeneration = QuestionViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    let resume = """
                    Amritesh Kumar, Email: amriteshk778@gmail.com, Phone: 9158188174, GitHub: github.com/AMRITESH240304. 
                    Education: B.Tech in CSE - Software Engineering, S.R.M Institute of Science and Technology (09/2022 – present), Chennai, India. 
                    Skills: Development - FastAPI, Express.js, Node.js, MongoDB + VectorDB, LangChain, AWS Bedrock, CrewAI, SwiftUI, Next.js. 
                    Programming Languages: Python, Swift, JavaScript, C++. 
                    """
                    
                    await testResumeGeneration.getQuestion(resume)
                }
            }) {
                Text("Generate Questions")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if !testResumeGeneration.numeracyQuestions.isEmpty {
                Text("Numeracy Questions")
                    .font(.headline)
                    .padding(.top)
                
                List(testResumeGeneration.numeracyQuestions) { question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.subheadline)
                            .bold()
                        
                        ForEach(question.options, id: \.self) { option in
                            Text("- \(option)")
                        }
                    }
                }
            }
            
            if !testResumeGeneration.literacyQuestions.isEmpty {
                Text("Literacy Questions")
                    .font(.headline)
                    .padding(.top)
                
                List(testResumeGeneration.literacyQuestions) { question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.subheadline)
                            .bold()
                        
                        ForEach(question.options, id: \.self) { option in
                            Text("- \(option)")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    Testing()
}
