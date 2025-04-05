//
//  FluencyView.swift
//  Giggle_swiftui
//
//  Created by admin49 on 18/12/24.
//

import SwiftUI
import Combine

struct FluencyView: View {
    @State var textValue: String = "Tap the button to start test"
    @State var speechRecognizer = SpeechRecognizer()
    @State var observer: ResultsObserver?
    @State var classificationScore: Double?

    @State private var timerText: String = "00:10"
    @State private var isRecording: Bool = false
    @State private var isButtonDisabled: Bool = false
    @State private var timer: Timer?
    @State private var remainingTime: Int = 10
    @State private var navigateToHome: Bool = false
    @State private var isScore: Bool = false
    
    @StateObject var SaveFLNdetails = FLNInfo(appService: AppService())

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Fluency")
                        .font(.title)
                        .bold()
                        .foregroundColor(Theme.tertiaryColor)
                    Spacer()
                }
                .padding(.leading, 20)

                Spacer()

                VStack {
                    Text("Hey " + FormManager.shared.formData.name + "!")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.gray)

                    Text(textValue)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                }

                Button {
                    startRecording()

                } label: {
                    Image(isRecording ? "FLN_MIC2" : "FLN_MIC")
                        .resizable()
                        .frame(width: 151, height: 151)
                }
                .disabled(isButtonDisabled)

                Text(timerText)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.top, 8)

                Spacer()

                if let score = classificationScore {
                    Text(
                        "Classification Score: \(String(format: "%.2f", score))%"
                    )
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Theme.tertiaryColor)
                    .padding(.top, 8)
                }

                Spacer()

                Button(action: {
                    if let score = classificationScore {
                        FlnDataManager.shared.flnData.fluencyScore = String(
                            format: "%.2f", score)
                        DispatchQueue.main.async{
                            Task{
                                await SaveFLNdetails.saveFlnInfo()
                                navigateToHome = true
                            }
                        }
                        
                    }
                }) {
                    Text("CONTINUE")
                        .frame(width: 300, height: 50)
                        .background(Theme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .font(.headline)
                }

                NavigationLink(
                    destination: FlnIntroView(), isActive: $navigateToHome
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)  // Hide the navigation bar
            .navigationBarBackButtonHidden(true)
        }
    }

    private func startRecording() {
        isRecording = true
        isButtonDisabled = true
        speechRecognizer.record(to: $textValue)

        remainingTime = 10
        timerText = "00:\(String(format: "%02d", remainingTime))"

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
                timerText = "00:\(String(format: "%02d", remainingTime))"
            } else {
                stopRecording()
            }
        }
    }

    private func stopRecording() {
        isRecording = false
        isButtonDisabled = false
        speechRecognizer.stopRecording()
        timer?.invalidate()
        timer = nil
        timerText = "00:10"

        DispatchQueue.main.async {
            classifySound { finalResult in
                classificationScore = finalResult
                print("The final classification result is: \(finalResult)%")
            }
        }
    }
}

#Preview {
    FluencyView()
}
