import SwiftUI

struct NumeracyView: View {
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedOption: Int? = nil
    @State private var timeLeft: CGFloat = 300.0 // 5 minutes in seconds
    @State private var timer: Timer? = nil
    
    let totalTime: CGFloat = 300.0 // 5 minutes
    let questions = [
        ("What is 5 + 3?", ["6", "7", "8", "9"]),
        ("Which number is a prime number?", ["12", "15", "17", "20"]),
        ("What is the square of 4?", ["12", "14", "16", "18"]),
        ("Which of these is an even number?", ["13", "17", "19", "22"]),
        ("What is 10 divided by 2?", ["3", "4", "5", "6"])
    ]
    let optionButtonSize: CGSize = CGSize(width: 360, height: 80) // Changeable button size
    
    var body: some View {
        NavigationStack{
            
            
            GeometryReader { geometry in
                VStack {
                    // Title and Progress
                    HStack {
                        Text("Numeracy")
                            .font(.title)
                            .bold()
                            .foregroundColor(Theme.tertiaryColor)
                        
                        Spacer()
                        
                        Text("\(currentQuestionIndex + 1)/\(questions.count)")
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
                    Text(questions[currentQuestionIndex].0)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Options
                    VStack {
                        ForEach(questions[currentQuestionIndex].1.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    selectedOption = index
                                }
                            }) {
                                HStack {
                                    Circle()
                                        .strokeBorder(selectedOption == index ? Color.red : Color.gray, lineWidth: 2)
                                        .background(Circle().foregroundColor(selectedOption == index ? Color.red.opacity(0.2) : Color.clear))
                                        .frame(width: 24, height: 24)
                                    
                                    Text(questions[currentQuestionIndex].1[index])
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
                    
                    Spacer()
                    
                    // Next Button
                    Button(action: {
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                            selectedOption = nil
                        } else {
                            timer?.invalidate()
                            // Handle quiz completion here
                        }
                    }) {
                        if currentQuestionIndex < questions.count - 1 {
                            Text("NEXT")
                                .frame(width: geometry.size.width * 0.8, height: 50)
                                .background(Theme.primaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .font(.headline)
                                .onTapGesture {
                                    currentQuestionIndex += 1
                                }
                        } else {
                            NavigationLink {
                                FluencyView()
                            } label: {
                                Text("FINISH")
                                    .frame(width: geometry.size.width * 0.8, height: 50)
                                    .background(Theme.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Theme.backgroundColor)
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    timer?.invalidate()
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation {
                timeLeft -= 1.0
                if timeLeft <= 0 {
                    timer?.invalidate()
                    // Handle time over logic here
                }
            }
        }
    }
}

struct NumeracyView_Previews: PreviewProvider {
    static var previews: some View {
        NumeracyView()
    }
}
