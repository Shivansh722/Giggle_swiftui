// gig-lister-view.swift
// Giggle_swiftui
// Created by admin49 on 12/03/25.

import SwiftUI
import WebKit

// WebView definition matching your existing implementation
struct WebClientView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false // Make webview transparent
        webView.backgroundColor = .clear // Set clear background
        webView.scrollView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

// Gig Model
struct Gig: Identifiable, Equatable {
    let id: UUID = UUID()
    var companyName: String
    var jobRole: String
    var hoursPerWeek: String
    var location: String
    var isRemote: Bool
    var postedDate: Date
    var jobDescription: String
    var requirements: [String]
    var position: String
    var qualification: String
    var experience: String
    var jobType: String
    var specialization: String
    var facilities: [String]
}

// Gig Manager
class GigManager: ObservableObject {
    static let shared = GigManager()
    @Published var gigs: [Gig] = []
    
    private init() {}
    
    func addGig(_ gig: Gig) {
        DispatchQueue.main.async {
            self.gigs.append(gig)
            print("Gig added: \(gig.companyName), Total gigs: \(self.gigs.count)")
        }
    }
}

// Bullet Point Input View
struct BulletPointInput: View {
    @Binding var items: [String]
    @State private var newItem = ""
    @State private var showWarning = false
    
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items.indices, id: \.self) { index in
                HStack {
                    Text("•")
                        .foregroundColor(.red)
                    TextField("", text: $items[index])
                        .foregroundColor(.white)
                        .frame(height: 44)
                        .padding(.horizontal, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.5))
                        )
                }
            }
            
            HStack {
                Text("•")
                    .foregroundColor(.red)
                TextField(placeholder, text: $newItem)
                    .foregroundColor(.white)
                    .frame(height: 44)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.5))
                    )
                    .submitLabel(.done)
                    .onSubmit {
                        if !newItem.isEmpty {
                            if items.count < 5 {
                                items.append(newItem)
                                newItem = ""
                            } else {
                                showWarning = true
                            }
                        }
                    }
            }
        }
        .alert("Maximum Limit Reached", isPresented: $showWarning) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can only add up to 5 items.")
        }
    }
}

// Gig Details Screen
struct GigDetailsScreen: View {
    @ObservedObject var gigManager: GigManager
    
    @State private var companyName = ""
    @State private var jobRole = ""
    @State private var hoursPerWeek = ""
    @State private var location = ""
    @State private var isRemote = false
    @State private var postedDate = Date()
    @State private var jobDescription = ""
    @State private var requirements: [String] = []
    @State private var position = ""
    @State private var qualification = ""
    @State private var experience = ""
    @State private var jobType = "Full-time"
    @State private var specialization = ""
    @State private var facilities: [String] = []
    
    @Environment(\.dismiss) var dismiss
    
    private let jobTypeOptions = ["Full-time", "Part-time", "Contract", "Temporary", "Internship"]
    
    private var isFormInvalid: Bool {
        companyName.isEmpty || jobRole.isEmpty || hoursPerWeek.isEmpty || location.isEmpty ||
        jobDescription.isEmpty || position.isEmpty || qualification.isEmpty ||
        experience.isEmpty || specialization.isEmpty
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("List Your Gig")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.onPrimaryColor)
                        .padding(.top, 20)
                    
                    WebView(url: Bundle.main.url(forResource: "jobs-list", withExtension: "gif") ?? URL(fileURLWithPath: NSTemporaryDirectory()))
                        .frame(width: 300, height: 300)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    
                    // Basic Information Section
                    VStack(spacing: 15) {
                        Text("Basic Information")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal,20)
                        
                        CustomTextField(placeholder: "Company Name", isSecure: false, text: $companyName, icon: "building.2.fill")
                        CustomTextField(placeholder: "Job Role", isSecure: false, text: $jobRole, icon: "briefcase.fill")
                        CustomTextField(placeholder: "Salary (Per Month)", isSecure: false, text: $hoursPerWeek, icon: "dollarsign.circle.fill")
                        CustomTextField(placeholder: "Location", isSecure: false, text: $location, icon: "map.fill")
                        Toggle("Remote Work", isOn: $isRemote)
                            .padding(.horizontal, 23)
                            .foregroundColor(.white)
                        DatePicker("Posted Date", selection: $postedDate, displayedComponents: .date)
                            .padding(.horizontal, 23)
                            .datePickerStyle(.compact)
                            .colorInvert()
                    }
                    
                    // Job Details Section
                    VStack(spacing: 15) {
                        Text("Job Description (max 60 words)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading) {
                            TextEditor(text: $jobDescription)
                                .foregroundColor(.white)
                                .frame(height: 100)
                                .frame(maxWidth: 370)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.5))
                                )
                                .onChange(of: jobDescription) { newValue in
                                    let words = newValue.split { $0.isWhitespace }.count
                                    if words > 60 {
                                        jobDescription = String(newValue.split { $0.isWhitespace }.prefix(60).joined(separator: " "))
                                    }
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Basic Requirements")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            CustomTextField(placeholder: "Position", isSecure: false, text: $position, icon: "person.fill")
                            CustomTextField(placeholder: "Qualification", isSecure: false, text: $qualification, icon: "graduationcap.fill")
                            CustomTextField(placeholder: "Experience", isSecure: false, text: $experience, icon: "clock.arrow.circlepath")
                            CustomTextField(placeholder: "Specialization", isSecure: false, text: $specialization, icon: "star.fill")

                            HStack(alignment: .center, spacing: 10) {
                                Text("Job Type")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                
                                Picker("Job Type", selection: $jobType) {
                                    ForEach(jobTypeOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(.white)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                            .padding(.horizontal, 20)
                            VStack {
                                Text("Other Requirements")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                BulletPointInput(items: $requirements, placeholder: "Add requirement")
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        
                        
                        VStack(alignment: .leading) {
                            Text("Facilities")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            BulletPointInput(items: $facilities, placeholder: "Add facility")
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Buttons
                    HStack(spacing: 10) {
                        CustomButton(
                            title: "Cancel",
                            backgroundColor: .clear,
                            action: { dismiss() },
                            width: 150,
                            height: 60,
                            cornerRadius: 10,
                            hasStroke: true
                        )
                        
                        CustomButton(
                            title: "Save Gig",
                            backgroundColor: isFormInvalid ? Color.gray : Theme.primaryColor,
                            action: {
                                let newGig = Gig(
                                    companyName: companyName,
                                    jobRole: jobRole,
                                    hoursPerWeek: hoursPerWeek,
                                    location: location,
                                    isRemote: isRemote,
                                    postedDate: postedDate,
                                    jobDescription: jobDescription,
                                    requirements: requirements,
                                    position: position,
                                    qualification: qualification,
                                    experience: experience,
                                    jobType: jobType,
                                    specialization: specialization,
                                    facilities: facilities
                                )
                                gigManager.addGig(newGig)
                                
                                // Update JobFormManager
                                JobFormManager.shared.formData.id = UUID()
                                JobFormManager.shared.formData.companyName = companyName
                                JobFormManager.shared.formData.location = location
                                JobFormManager.shared.formData.salary = hoursPerWeek
                                JobFormManager.shared.formData.jobType = isRemote ? "Remote" : "On-site"
                                JobFormManager.shared.formData.jobTitle = jobRole // Note: Overwriting jobTitle here
                                JobFormManager.shared.formData.jobTrait = specialization
                                JobFormManager.shared.formData.jobDescription = jobDescription
                                JobFormManager.shared.formData.position = position
                                JobFormManager.shared.formData.qualification = qualification
                                JobFormManager.shared.formData.specialisation = specialization
                                JobFormManager.shared.formData.experience = experience
                                JobFormManager.shared.formData.facilities = facilities
                                JobFormManager.shared.formData.requirements = requirements
                                
                                
                                // Post job asynchronously
                                Task {
                                    do {
                                        try await JobPost(appService: AppService()).postJob()
                                        print("Job posted successfully")
                                    } catch {
                                        print("Failed to post job: \(error)")
                                    }
                                }
                                
                                dismiss()
                            },
                            width: 150,
                            height: 60,
                            cornerRadius: 10,
                            hasStroke: false
                        )
                        .disabled(isFormInvalid)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Preview Fix
#Preview {
    GigDetailsScreen(gigManager: GigManager.shared)
}
