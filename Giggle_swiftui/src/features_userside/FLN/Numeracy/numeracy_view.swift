import SwiftUI

struct NumeracyView: View {
    @StateObject var viewModel = QuestionViewModel()
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedOption: Int? = nil
    @State private var score: Int = 0
    @State private var timeLeft: CGFloat = 300.0 // 5 minutes
    @State private var timer: Timer? = nil
    @State private var navigate: Bool = false
    
    let totalTime: CGFloat = 300.0
    let optionButtonSize: CGSize = CGSize(width: 360, height: 80)

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Header Section
                HStack {
                    Text("Numeracy")
                        .font(.title)
                        .bold()
                        .foregroundColor(Theme.tertiaryColor)
                    Spacer()
                    Text("\(currentQuestionIndex + 1)/\(viewModel.numeracyQuestions.count)")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(format: "%.2f", timeLeft))
                        .foregroundColor(.gray)
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Progress Bar
                ProgressView(value: timeLeft / totalTime)
                    .progressViewStyle(LinearProgressViewStyle(tint: Theme.primaryColor))
                    .padding(.horizontal)
                
                // Question
                if !viewModel.numeracyQuestions.isEmpty {
                    let currentQuestion = viewModel.numeracyQuestions[currentQuestionIndex]
                    
                    Text(currentQuestion.question)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Options List
                    VStack {
                        ForEach(currentQuestion.options.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    selectedOption = index
                                    if currentQuestion.options[index] == currentQuestion.correctAnswer {
                                        score += 1
                                    }
                                }
                            }) {
                                HStack {
                                    Circle()
                                        .strokeBorder(selectedOption == index ? Color.red : Color.gray, lineWidth: 2)
                                        .background(Circle().foregroundColor(selectedOption == index ? Color.red.opacity(0.2) : Color.clear))
                                        .frame(width: 24, height: 24)
                                    
                                    Text(currentQuestion.options[index])
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                .padding()
                                .frame(width: optionButtonSize.width, height: optionButtonSize.height)
                                .background(Color(UIColor.darkGray))
                                .cornerRadius(20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                } else {
                    Text("Loading questions...")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
                
                // Next / Finish Button
                if currentQuestionIndex < viewModel.numeracyQuestions.count - 1 {
                    Button(action: {
                        if selectedOption != nil {
                            selectedOption = nil
                            currentQuestionIndex += 1
                        }
                    }) {
                        Text("NEXT")
                            .frame(width: geometry.size.width * 0.8, height: 50)
                            .background(selectedOption == nil ? Color.gray : Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .font(.headline)
                    }
                    .disabled(selectedOption == nil)
                } else {
                    Button(action: {
                        if selectedOption != nil {
                            timer?.invalidate()
                            timer = nil
                            DispatchQueue.main.async {
                                FlnDataManager.shared.flnData.numeracyScore = score
                            }
                            navigate = true
                        }
                    }) {
                        Text("FINISH")
                            .frame(width: geometry.size.width * 0.8, height: 50)
                            .background(selectedOption == nil ? Color.gray : Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .font(.headline)
                    }
                    .disabled(selectedOption == nil)
                    .background(
                        NavigationLink("", destination: FluencyIntroView(), isActive: $navigate)
                            .hidden()
                    )
                }
            }
            .background(Theme.backgroundColor)
            .onAppear {
                startTimer()
                Task {
                    let resume = """
                    Amritesh Kumar, Email: amriteshk778@gmail.com, Phone: 9158188174, GitHub: github.com/AMRITESH240304. 
                    Education: B.Tech in CSE - Software Engineering, S.R.M Institute of Science and Technology (09/2022 – present), Chennai, India. 
                    Skills: Development - FastAPI, Express.js, Node.js, MongoDB + VectorDB, LangChain, AWS Bedrock, CrewAI, SwiftUI, Next.js. 
                    Programming Languages: Python, Swift, JavaScript, C++. 
                    """
                    await viewModel.getQuestion(resume)
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation {
                if timeLeft > 0 {
                    timeLeft -= 1.0
                } else {
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }
}
