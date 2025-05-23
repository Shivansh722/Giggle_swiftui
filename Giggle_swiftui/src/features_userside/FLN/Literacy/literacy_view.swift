import SwiftUI

struct LiteracyView: View {
    @StateObject var viewModel = QuestionViewModel()
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedOption: Int? = nil
    @State private var score: Int = 0
    @State private var timeLeft: CGFloat = 90.0 // 1.5 minutes
    @State private var timer: Timer? = nil
    @State private var navigate: Bool = false
    @State private var animateOptions: Bool = false // For option appearance animation
    
    let totalTime: CGFloat = 90.0
    let optionButtonSize: CGSize = CGSize(width: 360, height: 80)

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Header Section
                HStack {
                    Text("Literacy")
                        .font(.title)
                        .bold()
                        .foregroundColor(Theme.onPrimaryColor)
                    Spacer()
                    Text("\(currentQuestionIndex + 1)/\(viewModel.literacyQuestions.count)")
                        .foregroundColor(.gray)
                    Spacer()
                    
                    // Formatted time display (minutes:seconds)
                    Text(formatTimeLeft())
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
                if !viewModel.literacyQuestions.isEmpty {
                    let currentQuestion = viewModel.literacyQuestions[currentQuestionIndex]
                    
                    HStack {
                        Text(currentQuestion.question)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Options List with Animation
                    VStack {
                        ForEach(currentQuestion.options.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
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
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                .padding()
                                .frame(width: optionButtonSize.width, height: optionButtonSize.height)
                                .background(Color(UIColor.darkGray))
                                .cornerRadius(20)
                                .scaleEffect(selectedOption == index ? 1.05 : 1.0) // Scale when selected
                                .shadow(color: selectedOption == index ? Color.red.opacity(0.3) : Color.clear, radius: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(animateOptions ? 1.0 : 0.0)
                            .scaleEffect(animateOptions ? 1.0 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.5).delay(Double(index) * 0.1),
                                value: animateOptions
                            )
                        }
                    }
                    .padding()
                    .onAppear {
                        animateOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                animateOptions = true
                            }
                        }
                    }
                    .onChange(of: currentQuestionIndex) { _ in
                        animateOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                animateOptions = true
                            }
                        }
                    }
                } else {
                    Text("Loading questions...")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
                
                // Next / Finish Button
                if currentQuestionIndex < viewModel.literacyQuestions.count - 1 {
                    Button(action: {
                        if selectedOption != nil {
                            selectedOption = nil
                            currentQuestionIndex += 1
                        }
                    }) {
                        Text("NEXT")
                            .frame(width: geometry.size.width * 0.8, height: 50)
                            .background(selectedOption == nil ? Color.gray : Theme.primaryColor)
                            .foregroundColor(Theme.onPrimaryColor)
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
                                FlnDataManager.shared.flnData.literacyScore = score
                            }
                            navigate = true
                        }
                    }) {
                        Text("FINISH")
                            .frame(width: geometry.size.width * 0.8, height: 50)
                            .background(selectedOption == nil ? Color.gray : Theme.primaryColor)
                            .foregroundColor(Theme.onPrimaryColor)
                            .cornerRadius(6)
                            .font(.headline)
                    }
                    .disabled(selectedOption == nil)
                    .background(
                        NavigationLink("", destination: NumeracyView(), isActive: $navigate)
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
    
    // Format time to minutes:seconds
    private func formatTimeLeft() -> String {
        let minutes = Int(timeLeft) / 60
        let seconds = Int(timeLeft) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
