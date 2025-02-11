import SwiftUI

struct LiteracyView: View {
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedOption: Int? = nil
    @State private var score: Int = 0
    @State private var timeLeft: CGFloat = 300.0 // 5 minutes in seconds
    @State private var timer: Timer? = nil
    @State private var navigate: Bool = false
//    @EnvironmentObject var flnDataManager: FlnDataManager // ✅ Use EnvironmentObject
    
    let totalTime: CGFloat = 300.0 // 5 minutes
    let questions = [
        ("Which part of a sentence provides more information about the subject?", ["Verb", "Object", "Predicate", "Clause"], 2),
        ("What is the main action word in a sentence?", ["Noun", "Adjective", "Verb", "Clause"], 2),
        ("What part of speech describes a noun?", ["Adverb", "Preposition", "Adjective", "Pronoun"], 2),
        ("What connects clauses or sentences?", ["Conjunction", "Verb", "Predicate", "Article"], 0),
        ("Which refers to a person, place, or thing?", ["Verb", "Adjective", "Noun", "Clause"], 2)
    ]
    let optionButtonSize: CGSize = CGSize(width: 360, height: 80)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Header Section
                HStack {
                    Text("Literacy")
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
                
                // Options List
                VStack {
                    ForEach(questions[currentQuestionIndex].1.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedOption = index
                                if index == questions[currentQuestionIndex].2 {
                                    score += 1
                                }
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
                
                // Next / Finish Button
                if currentQuestionIndex < questions.count - 1 {
                    Button(action: {
                        selectedOption = nil
                        currentQuestionIndex += 1
                    }) {
                        Text("NEXT")
                            .frame(width: geometry.size.width * 0.8, height: 50)
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .font(.headline)
                    }
                } else {
                    Button(action: {
                        timer?.invalidate()
                        timer = nil
                        
                        print("Final Score before update: \(score)")
                        
                        DispatchQueue.main.async{
                            FlnDataManager.shared.flnData.literacyScore = score
                        }
                        navigate = true
                    }) {
                        Text("FINISH")
                            .frame(width: geometry.size.width * 0.8, height: 50)
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .font(.headline)
                    }
                    .background(
                        NavigationLink("", destination: NumeracyView(), isActive: $navigate)
                            .hidden()
                    )
                }
            }
            .background(Theme.backgroundColor)
            .onAppear {
                startTimer()
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

#Preview {
   
}
