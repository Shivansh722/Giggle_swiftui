//
//  literacy.swift
//  Giggle_swiftui
//
//  Created by user@91 on 09/01/25.
//

import SwiftUI

struct QuizView: View {
    @State private var selectedOption: Int? = nil
    @State private var timeLeft: CGFloat = 1.0 // 1.0 means 100% progress
    @State private var timer: Timer? = nil
    
    let totalTime: CGFloat = 5.0 // 5 seconds
    let options = ["Verb", "Object", "Predicate", "Clause"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Title and Progress
                HStack {
                    Text("Literacy")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("05/08")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(String(format: "%.2f", timeLeft * totalTime))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Progress Bar
                ProgressView(value: timeLeft)
                    .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                    .padding(.horizontal)
                
                // Question
                Text("Which part of a sentence provides more information about the subject?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                
                // Options
                VStack(spacing: 16) {
                    ForEach(options.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedOption = index
                            }
                        }) {
                            HStack {
                                Circle()
                                    .strokeBorder(selectedOption == index ? Color.blue : Color.gray, lineWidth: 2)
                                    .background(Circle().foregroundColor(selectedOption == index ? Color.blue.opacity(0.2) : Color.clear))
                                    .frame(width: 24, height: 24)
                                
                                Text(options[index])
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.darkGray))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                
                Spacer()
                
                // Next Button
                Button(action: {
                    // Action for Next Button
                }) {
                    Text("NEXT")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .background(Color.black)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation {
                timeLeft -= 0.02 / totalTime
                if timeLeft <= 0 {
                    timer?.invalidate()
                }
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
