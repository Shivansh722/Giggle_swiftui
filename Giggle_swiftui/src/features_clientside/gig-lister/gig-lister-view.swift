//
//  gig-lister-view.swift
//  Giggle_swiftui
//
//  Created by admin49 on 12/03/25.
//

import SwiftUI

// Gig Model
struct Gig: Identifiable {
    let id: UUID = UUID()
    var companyName: String
    var category: String
    var hoursPerWeek: String
    var location: String
    var isRemote: Bool
    var postedDate: Date
}

// Gig Manager
class GigManager: ObservableObject {
    @Published var gigs: [Gig] = []
    
    func addGig(_ gig: Gig) {
        gigs.append(gig)
    }
}

// Gig Details Screen
struct GigDetailsScreen: View {
    @ObservedObject var gigManager: GigManager
    
    @State private var companyName = ""
    @State private var category = ""
    @State private var hoursPerWeek = ""
    @State private var location = ""
    @State private var isRemote = false
    @State private var postedDate = Date()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("List Your Gig")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Company Name", isSecure: false, text: $companyName, icon: "building.2.fill")
                    CustomTextField(placeholder: "Category", isSecure: false, text: $category, icon: "briefcase.fill")
                    CustomTextField(placeholder: "Hours per Week", isSecure: false, text: $hoursPerWeek, icon: "clock.fill")
                    CustomTextField(placeholder: "Location", isSecure: false, text: $location, icon: "map.fill")
                    
                    Toggle("Remote Work", isOn: $isRemote)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                    
                    DatePicker("Posted Date", selection: $postedDate, displayedComponents: .date)
                        .padding(.horizontal, 20)
                        .datePickerStyle(.compact)
                        .colorInvert()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Buttons at the bottom
                HStack(spacing: 10) {
                    CustomButton(
                        title: "Cancel",
                        backgroundColor: Theme.primaryColor,
                        action: { dismiss() },
                        width: nil,
                        height: 60,
                        cornerRadius: 10,
                        hasStroke: false
                    )
                    .frame(maxWidth: .infinity)

                    CustomButton(
                        title: "Save Gig",
                        backgroundColor: .clear,
                        action: {
                            let newGig = Gig(
                                companyName: companyName,
                                category: category,
                                hoursPerWeek: hoursPerWeek,
                                location: location,
                                isRemote: isRemote,
                                postedDate: postedDate
                            )
                            gigManager.addGig(newGig)
                            dismiss() // Close the modal
                        },
                        width: nil,
                        height: 60,
                        cornerRadius: 10,
                        hasStroke: true
                    )
                    .frame(maxWidth: .infinity)
                    .disabled(companyName.isEmpty || category.isEmpty || hoursPerWeek.isEmpty || location.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 200)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Preview Fix
#Preview {
    GigDetailsScreen(gigManager: GigManager()) // Passes a GigManager instance for preview
}
