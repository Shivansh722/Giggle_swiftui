//
//  profile-view.swift
//  Giggle_swiftui
//
//  Created by rjk on 30/12/24.
//

import Popovers
import SwiftUI

struct ProfileScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegisterViewModel
    @State private var isPopoverPresented = false
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    @State private var resumeFiles: [[String]] = []
    @StateObject var logout = AppService()
    @State private var navigate: Bool = false
    @State private var navigateToEdit = false
    @State private var showPickerChoice:Bool = false
    @State private var isFilePickerPresented:Bool = false
    @StateObject private var uploadManager = ResumeUploadManager(
        apiEndpoint: "https://cloud.appwrite.io/v1",
        projectIdentifier: "67da77af003e5e94f856",
        storageBucketId: "67da7d55000bf31fb062"
    )
    @State private var jobApplied:String = ""
    @State private var endorsed:String = "0"
    @State private var bioGraphy:String = ""
    @State private var GiggleGrade:String = "No Grade"
    @State private var contentOpacity: Double = 0 // For fade-in animation
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    // Background with subtle gradient overlay
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    // Decorative elements
                    Circle()
                        .fill(Theme.primaryColor.opacity(0.05))
                        .frame(width: 200, height: 200)
                        .blur(radius: 30)
                        .offset(x: -geometry.size.width/2, y: 100)
                    
                    Circle()
                        .fill(Theme.primaryColor.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .blur(radius: 40)
                        .offset(x: geometry.size.width/2, y: 300)
                    
                    VStack(spacing: 16) {
                        // Header with back button and menu
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .imageScale(.large)
                                    .padding(8)
                            }
                            
                            Spacer()
                            
                            Text("Profile")
                                .font(.headline)
                                .foregroundColor(Theme.onPrimaryColor)
                            
                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    isPopoverPresented.toggle()
                                }) {
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .foregroundStyle(Theme.onPrimaryColor)
                                        .scaledToFit()
                                        .frame(width: 25, height: 19)
                                        .padding(8)
                                }
                                Templates.Menu(present: $isPopoverPresented) {
                                    Templates.MenuButton(title: "Edit Profile")
                                    {
                                        navigateToEdit = true
                                    }
                                    Templates.MenuButton(title: "Logout") {
                                        Task {
                                            handleLogout()
                                        }
                                    }
                                    .foregroundStyle(.red)
                                    Templates.MenuButton(title: "Delete Account") {
                                        Task {
                                            
                                        }
                                    }
                                    .foregroundStyle(.red)
                                } label: { _ in
                                    Color.clear
                                        .frame(width: 0, height: 0)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.3), value: contentOpacity)
                        
                        NavigationLink(
                            destination: edit_profile_view(),
                            isActive: $navigateToEdit
                        ) {
                            EmptyView()
                        }
                        
                        // Profile Picture and Name with animation
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Theme.primaryColor.opacity(0.1))
                                    .frame(width: 120, height: 120)
                                
                                if let profileImage = GlobalData.shared.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Theme.primaryColor.opacity(0.6), lineWidth: 2)
                                        )
                                        .shadow(color: Theme.primaryColor.opacity(0.3), radius: 5)
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                                }
                            }

                            VStack(spacing: 4) {
                                Text(FormManager.shared.formData.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)

                                Text(FormManager.shared.formData.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 8)
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5).delay(0.1), value: contentOpacity)

                        // Stats Section with improved visuals
                        HStack(spacing: geometry.size.width / 6) {
                            StatView(title: jobApplied, subtitle: "Applied")
                                .opacity(contentOpacity)
                                .animation(.easeIn(duration: 0.5).delay(0.2), value: contentOpacity)
                            
                            StatView(title: GiggleGrade, subtitle: "Giggle Grade")
                                .opacity(contentOpacity)
                                .animation(.easeIn(duration: 0.5).delay(0.3), value: contentOpacity)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Biography Section with improved styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Biography")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                                
                                Spacer()
                                
                                Image(systemName: "quote.bubble")
                                    .foregroundColor(Theme.primaryColor.opacity(0.7))
                            }
                            .padding(.bottom, 4)

                            if bioGraphy.isEmpty {
                                Text("No biography available. Edit your profile to add one.")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .italic()
                            } else {
                                Text(bioGraphy)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .lineSpacing(4)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5).delay(0.4), value: contentOpacity)

                        // Resume Section with improved styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Resume")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)

                                Spacer()

                                Button(action: {
                                    showPickerChoice = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Theme.primaryColor)
                                        
                                        Text("Upload")
                                            .foregroundColor(Theme.primaryColor)
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(
                                        Capsule()
                                            .fill(Theme.primaryColor.opacity(0.2))
                                    )
                                }
                                .actionSheet(isPresented: $showPickerChoice){
                                    ActionSheet(
                                        title: Text("Select Source"),
                                        buttons: [
                                            .default(Text("Files")) {
                                                isFilePickerPresented = true
                                            },
                                            .cancel()
                                        ]
                                    )
                                }
                                .sheet(isPresented: $isFilePickerPresented) {
                                    DocumentPicker { url in
                                        if let url = url {
                                            uploadManager.addSelectedResume(fileURL: url)
                                            Task {
                                                do{
                                                    try await uploadManager.updateResume()
                                                    await loadUserFiles()
                                                }catch{
                                                    
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if resumeFiles.isEmpty {
                                HStack {
                                    Image(systemName: "doc.text")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                        .frame(width: 40)
                                    
                                    Text("No resumes found.")
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(10)
                            } else {
                                ForEach(resumeFiles, id: \.self) { file in
                                    ResumeCardView1(
                                        ResumeName: file[0]
                                    )
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5).delay(0.5), value: contentOpacity)

                        // Experience Section with improved styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Experience")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)

                                Spacer()

                                Text("See all")
                                    .foregroundColor(Theme.primaryColor)
                                    .font(.subheadline)
                                    .onTapGesture {
                                        // Handle see all action
                                    }
                            }

                            if ExperienceStore.shared.experiences.isEmpty {
                                HStack {
                                    Image(systemName: "briefcase")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                        .frame(width: 40)
                                    
                                    Text("No experience added yet.")
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(10)
                            } else {
                                ForEach(ExperienceStore.shared.experiences) { experience in
                                    HStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(Theme.primaryColor.opacity(0.2))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: "briefcase.fill")
                                                .foregroundColor(Theme.primaryColor.opacity(0.8))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(experience.position)
                                                .foregroundColor(Theme.onPrimaryColor)
                                                .font(.system(size: 16, weight: .medium))
                                            
                                            Text(experience.companyName)
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text(experience.location)
                                                .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                                                .font(.caption)
                                            
                                            Text("\(experience.startDate) - \(experience.endDate)")
                                                .foregroundColor(.gray)
                                                .font(.caption)
                                        }
                                    }
                                    .padding()
                                    .background(Color(hex: "343434").opacity(0.6))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5).delay(0.6), value: contentOpacity)
                    }
                }
                
                NavigationLink(destination: RegisterView(), isActive: $navigate) {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Theme.backgroundColor)
            .onAppear {
                withAnimation {
                    contentOpacity = 1
                }
                Task {
                    await loadUserFiles()
                    await loadUserDetails()
                    await loadBioGraphy()
                }
            }
        }
    }
    
    private func loadBioGraphy() async {
        do{
            let result = try await saveUserInfo.getBio()
            bioGraphy = result
        } catch {
            
        }
    }

    private func loadUserFiles() async {
        let files = await saveUserInfo.fetchFiles()
        DispatchQueue.main.async {
            self.resumeFiles = files
        }
    }
    
    private func loadUserDetails() async {
        do {
            let (jobCount, grade) = try await saveUserInfo.fetchUser()
            jobApplied = jobCount
            GiggleGrade = grade
        } catch {
            print("Error loading user details: \(error)")
        }
    }

    private func handleLogout() {
        let userDefault = UserDefaults.standard
        viewModel.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "status")
        navigate = true
    }
}

// Enhanced StatView with better visual styling
struct StatView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Theme.onPrimaryColor)
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(width: 100)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
        )
    }
}

// Enhanced ResumeCardView with better visual styling
struct ResumeCardView1: View {
    var ResumeName: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Theme.primaryColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "doc.text.fill")
                    .foregroundColor(Theme.primaryColor.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ResumeName)
                    .foregroundColor(Theme.onPrimaryColor)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
            }
            
            Spacer()
            

        }
        .padding()
        .background(Color(hex: "343434").opacity(0.6))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileScreen()
}
