import SwiftUI

struct eduView2: View {
    @ObservedObject var formManager = FormManager.shared
    @State private var selectedPursuing = "12th pass"
    @State private var degreeName = ""
    @State private var specialization = ""
    @State private var completionYear = Date()
    @State private var universityName = ""
    @State private var navigateToskillView = false
    @State private var showAlert = false
    
    // Add FocusState to manage keyboard focus
    @FocusState private var focusedField: Field?
    enum Field {
        case degreeName, specialization, universityName
    }
    
    var pursuingOptions = ["12th pass", "Diploma", "ITI", "Under Graduate", "Post Graduate"]
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
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
                            .padding(.leading, 30) // Fixed padding
                        }
                        Spacer()
                    }
                    .padding(.top, 20) // Fixed padding
                    
                    Spacer()
                    
                    ProgressView(value: 70, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, 30) // Fixed padding
                        .padding(.top, -10) // Fixed negative padding
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("What are you currently pursuing?")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, 30) // Fixed padding
                        
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
                        .padding(.horizontal, 30) // Fixed padding
                        
                        Text("Enter your degree name:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, 30) // Fixed padding
                        
                        CustomTextField(
                            placeholder: "Degree Name",
                            isSecure: false,
                            text: $degreeName,
                            icon: "book"
                        )
                        .focused($focusedField, equals: .degreeName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .specialization
                        }
                        .padding(.horizontal, 10) // Fixed padding
                        
                        Text("Enter your specialization:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, 30) // Fixed padding
                        
                        CustomTextField(
                            placeholder: "Specialization",
                            isSecure: false,
                            text: $specialization,
                            icon: "text.book.closed"
                        )
                        .focused($focusedField, equals: .specialization)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .universityName
                        }
                        .padding(.horizontal, 10) // Fixed padding
                        
                        DateViewPicker(
                            selectedDate: $completionYear,
                            title: "Completion Year",
                            BackgroundColor: Theme.onPrimaryColor,
                            textColor: Theme.onPrimaryColor
                        )
                        .padding(.horizontal, 30) // Fixed padding
                        
                        Text("Enter your university name:")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, 30) // Fixed padding
                        
                        CustomTextField(
                            placeholder: "University Name",
                            isSecure: false,
                            text: $universityName,
                            icon: "building.columns"
                        )
                        .focused($focusedField, equals: .universityName)
                        .submitLabel(.go)
                        .onSubmit {
                            focusedField = nil // Dismiss keyboard on "Go"
                        }
                        .padding(.horizontal, 10) // Fixed padding
                        
                        
                        NavigationLink(destination: skillView(), isActive: $navigateToskillView) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            if validateFields() {
                                set_data()
                                navigateToskillView = true
                            } else {
                                showAlert = true
                            }
                        }) {
                            Text("NEXT")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50) // Approximate 80% of typical screen width
                                .background(Theme.primaryColor)
                                .cornerRadius(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center the button
                        .padding(.bottom, 20)
                        .padding(.top,20)
                        .padding(.horizontal, 30) // Fixed padding
                    }
                    .padding(.top, 20) // Fixed padding
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Missing Information"),
                        message: Text("Please fill in all required fields before proceeding."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onTapGesture {
                    focusedField = nil // Dismiss keyboard on tap anywhere
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadUserDataFromUserDefaults()
        }
    }
    
    private func validateFields() -> Bool {
        return !degreeName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !specialization.trimmingCharacters(in: .whitespaces).isEmpty &&
               !universityName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func set_data() {
        formManager.formData.pursuing = selectedPursuing
        formManager.formData.degreeName = degreeName
        formManager.formData.completionYear = completionYear
        formManager.formData.universityName = universityName
        formManager.formData.specialization = specialization
    }
    
    private func loadUserDataFromUserDefaults() {
        if UserPreference.shared.shouldLoadUserDetailsAutomatically {
            if let resumeData = UserDefaults.standard.data(forKey: "resumeData") {
                do {
                    if let resume = try JSONSerialization.jsonObject(with: resumeData, options: []) as? [String: Any] {
                        let educationArray = resume["Education"] as? [[String: Any]]
                        if let firstEducation = educationArray?.first,
                           let degree = firstEducation["Degree"] as? String,
                           let instution = firstEducation["Institution"] as? String {
                            if degree == "B.Tech" {
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
}

#Preview {
    eduView2()
}
