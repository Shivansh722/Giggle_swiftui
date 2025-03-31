import SwiftUI

struct FLNScoreView: View {
    @State private var navigatetoHome: Bool = false
    @State private var flnID: String? = nil
    @State private var naviagtetoLiteracy: Bool = false
    @State private var fluencyScore = FlnDataManager.shared.flnData.fluencyScore
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Text("Overall")
                        .font(.title)
                        .bold()
                        .foregroundColor(Theme.primaryColor)
                    + Text(" Score")
                        .font(.title)
                        .bold()
                        .foregroundColor(Theme.tertiaryColor)
                    Spacer()
                }
                .padding(.leading, 20)

                Spacer()

                HStack {
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Fluency")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("\(FlnDataManager.shared.flnData.fluencyScore)%")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(Theme.secondaryColor)
                        }
                        .padding([.trailing, .leading], 20)

                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Literacy & Numeracy")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(Theme.tertiaryColor)
                            }
                            Spacer()
                            // Compute averageScore inline here
                            let numeracyScores = FlnDataManager.shared.flnData.numeracyScore
                            let literacyScores = FlnDataManager.shared.flnData.literacyScore
                            let totalPossibleScore = 10
                            let averagePercentage: Int = (numeracyScores + literacyScores) * 100 / totalPossibleScore
                            
                            Text("\(averagePercentage)%")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(Theme.secondaryColor)
                        }
                        .padding([.trailing, .leading], 20)
                    }
                }

                Spacer()

                Text("Giggle Grading")
                    .font(.title)
                    .bold()
                    .foregroundColor(Theme.tertiaryColor)

                ZStack {
                    Text(FlnDataManager.shared.flnData.giggleGrade)
                        .font(.system(size: 72))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.secondaryColor)
                }
                .frame(width: 172, height: 108)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .white.opacity(0.2), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.6, green: 0.6, blue: 0.6).opacity(0.05), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 1.23, y: 0),
                        endPoint: UnitPoint(x: -0.2, y: 1.17)
                    )
                )
                .cornerRadius(22)

                Image("A true Giggler!!")
                    .resizable()
                    .frame(width: 127, height: 25)

                Spacer()

                VStack(spacing: 20) {
                    Button(action: {
                        naviagtetoLiteracy = true
                    }) {
                        Text("RETEST")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                    }
                    
                    NavigationLink(destination: FlnIntroView(), isActive: $naviagtetoLiteracy) {
                        EmptyView()
                    }

                    Button(action: {
                        navigatetoHome = true
                    }) {
                        Text("APPLY WITH GIGGLE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Theme.primaryColor)
                            .cornerRadius(6)
                    }
                    NavigationLink(destination: HomeView(), isActive: $navigatetoHome) {
                        EmptyView()
                    }
                }
                .padding([.horizontal, .bottom], 20)
            }
            .task {
                reverse()
            }
        }
    }
    
    func reverse() {
        if var store = Int(fluencyScore), store >= 35 || store <= 65 {
            store += 20
            fluencyScore = String(store)
            print(fluencyScore)
        }
    }
}

#Preview {
    FLNScoreView()
}
