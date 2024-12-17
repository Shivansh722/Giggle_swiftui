//
//  edu-view2.swift
//  Giggle_swiftui
//
//  Created by user@91 on 16/11/24.
//

import SwiftUI

struct eduView2: View {
    @ObservedObject var formManager = FormManager.shared
    @State private var selectedPursuing = "12th pass" // Default dropdown value
    @State private var degreeName = ""
    @State private var specialization = ""
    @State private var completionYear = Date()
    @State private var universityName = ""
    @State private var navigateToskillView = false
    
    var pursuingOptions = ["12th pass", "Diploma", "ITI", "Under Graduate", "Post Graduate"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Education")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text("Details")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            .padding(.leading, geometry.size.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer()
                    
                    ProgressView(value: 60, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.top, geometry.size.height * -0.01)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Pursuing Picker
                        Text("What are you currently pursuing?")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, geometry.size.width * 0.08)
                        
                        Picker(selection: $selectedPursuing, label: Text(selectedPursuing)) {
                            ForEach(pursuingOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, maxHeight: 15)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, geometry.size.width * 0.08)
                        
                        // Degree Name
                        Text("Enter your degree name:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, geometry.size.width * 0.08)
                        
                        CustomTextField(
                            placeholder: "Degree Name",
                            isSecure: false,
                            text: $degreeName,
                            icon: "book"
                            
                        )
                        .padding(.horizontal, geometry.size.width * 0.03)
                        
                        
                        // Specialization
                        Text("Enter your specialization:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, geometry.size.width * 0.08)
                        
                        CustomTextField(
                            placeholder: "Specialization",
                            isSecure: false,
                            text: $specialization,
                            icon: "text.book.closed"
                        )
                        .padding(.horizontal, geometry.size.width * 0.03)
                        
                        
                        // Completion Year (Date Picker)
                        Text("Select your completion year:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, geometry.size.width * 0.08)
                        
                        DateViewPicker(
                            selectedDate: $completionYear,
                            title: "Completion Year",
                            BackgroundColor: Theme.onPrimaryColor,
                            textColor: Theme.primaryColor
                        )
                        .padding(.horizontal, geometry.size.width * 0.08)
                        
                        // University Name
                        Text("Enter your university name:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, geometry.size.width * 0.08)
                        
                        CustomTextField(
                            placeholder: "University Name",
                            isSecure: false,
                            text: $universityName,
                            icon: "building.columns"
                        )
                        .padding(.horizontal, geometry.size.width * 0.03)
                        
                        
                        Spacer()
                        
                        NavigationLink(destination: skillView(), isActive: $navigateToskillView) {
                            EmptyView()
                        }
                        
                        // Next Button
                        CustomButton(
                            title: "NEXT",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                set_data()
                                navigateToskillView = true
                                
                            },
                            width: geometry.size.width * 0.8,
                            height: 50
                        )
                        .padding(.bottom, 20)
                        .padding(.leading, geometry.size.width * -0.06)
                        .padding(.horizontal, geometry.size.width * 0.08)
                    }
                    .padding(.top, geometry.size.height * 0.02)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            loadUserDataFromUserDefaults()
        }
    }
    
    private func set_data(){
        formManager.formData.pursuing = selectedPursuing
        formManager.formData.degreeName = degreeName
        formManager.formData.completionYear = completionYear
        formManager.formData.universityName = universityName
        formManager.formData.specialization = specialization
    }
    
    private func loadUserDataFromUserDefaults() {
        if let resumeData = UserDefaults.standard.data(forKey: "resumeData") {
            do {
                if let resume = try JSONSerialization.jsonObject(with: resumeData, options: []) as? [String: Any] {
                    let educationArray = resume["Education"] as? [[String: Any]]
                    if let firstEducation = educationArray?.first,
                       let degree = firstEducation["Degree"] as? String, let instution = firstEducation["Institution"] as? String{
                        if (degree == "B.Tech"){
                            self.selectedPursuing = "Under Graduate"
                        } else {
                            self.selectedPursuing = degree
                        }
                        self.degreeName = degree
                        self.universityName = instution
                        
                    } else {
                        print("Degree not found in Education")
                    }
                }
            } catch {
                print("Error decoding resume data: \(error.localizedDescription)")
            }
        } else {
            print("No resume data found in UserDefaults")
        }
    }
}

#Preview {
    eduView2()
}
