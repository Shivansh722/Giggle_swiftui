//
//  FluencyScoreView.swift
//  Giggle_swiftui
//
//  Created by rjk on 05/04/25.
//

import SwiftUI

struct FluencyScoreView: View {
    var categories: [Category] = [
        Category(name: "Fluency & Coherence", percentage: FlnDataManager.shared.flnData.CoherencePer, color: .green, content: FlnDataManager.shared.flnData.coherenceCOntent),
        Category(name: "Grammar & Structure", percentage: FlnDataManager.shared.flnData.GrammarPer, color: .blue, content: FlnDataManager.shared.flnData.grammarContent),
        Category(name: "User Vocabulary", percentage: FlnDataManager.shared.flnData.VocabularyPer, color: .pink, content: FlnDataManager.shared.flnData.vocabularyContent),
        Category(name: "User Pronunciation", percentage: FlnDataManager.shared.flnData.PronunciationPer, color: .yellow, content: FlnDataManager.shared.flnData.pronunciationContent)
    ]
    
    @State private var navigateToNext = false
    @State private var navigateToFluency = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            // Main content with ScrollView
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Fluency")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                            .padding(.top, 15)
                        Text("Result")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 15)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    
                    // Chart and Legend in HStack
                    HStack(spacing: 20) {
                        // Stacked Progress Ring Chart (Left Side)
                        ZStack {
                            // Outer ring (Fluency & Coherence - Green)
                            StackedRing(
                                percentage: categories[0].percentage,
                                color: categories[0].color,
                                ringWidth: 7,
                                diameter: 180
                            )
                            
                            // Second ring (Grammar & Structure - Blue)
                            StackedRing(
                                percentage: categories[1].percentage,
                                color: categories[1].color,
                                ringWidth: 7,
                                diameter: 155
                            )
                            
                            // Third ring (User Vocabulary - Pink)
                            StackedRing(
                                percentage: categories[2].percentage,
                                color: categories[2].color,
                                ringWidth: 7,
                                diameter: 130
                            )
                            
                            // Inner ring (User Pronunciation - Yellow)
                            StackedRing(
                                percentage: categories[3].percentage,
                                color: categories[3].color,
                                ringWidth: 7,
                                diameter: 105
                            )
                            
                            Text("71%") // Center percentage
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                                .bold()
                        }
                        .frame(width: 180, height: 180)
                        
                        // Legend (Right Side)
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(categories, id: \.name) { category in
                                HStack {
                                    Circle()
                                        .fill(category.color)
                                        .frame(width: 10, height: 10)
                                    Text(category.name)
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(Int(category.percentage * 100))%")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Containers
                    ForEach(categories, id: \.name) { category in
                        ContainerView(title: category.name, content: category.content ?? "No content available")
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                    }
                    Spacer().frame(height: 70)
                }
            }
            
            // Sticky buttons at the bottom
            VStack {
                Spacer()
                
                HStack(spacing: 20) {
//                    Button(action: {
//                        // Retest action
//                        navigateToFluency = true
//                    }) {
//                        Text("RETEST")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Theme.primaryColor)
//                            .cornerRadius(6)
//                    }
                    
                    Button(action: {
                        navigateToNext = true
                    }) {
                        Text("NEXT")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primaryColor)
                            .cornerRadius(6)
                    }
                }
                .padding(.bottom, 4)
                .padding(.top, 10)
                .padding(.horizontal, 30)
                .background(Theme.backgroundColor)
                .background(
                    NavigationLink(
                        destination: FLNScoreView(),
                        isActive: $navigateToNext
                    ) {
                        EmptyView()
                    }
                )
                .background(
                    NavigationLink(
                        destination: FluencyView(),
                        isActive: $navigateToFluency
                    ) {
                        EmptyView()
                    }
                )
            }
        }
        .background(Theme.backgroundColor)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

// Model for category data
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let percentage: Double // Between 0 and 1
    let color: Color
    let content: String? // Optional content for containers
}

// New Stacked Ring View for concentric circles
struct StackedRing: View {
    let percentage: Double
    let color: Color
    let ringWidth: CGFloat
    let diameter: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: ringWidth)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: min(percentage, 1.0))
                .stroke(style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut, value: percentage)
        }
        .frame(width: diameter, height: diameter)
    }
}

// Container View for each category
struct ContainerView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 10)
            
            Text(content)
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "343434").opacity(0.61))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    FluencyScoreView()
}
