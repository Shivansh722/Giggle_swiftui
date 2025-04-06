//
//  profile-view.swift
//  Giggle_swiftui
//
//  Created by rjk on 30/12/24.
//

import Popovers
import SwiftUI

struct ProfileScreen: View {
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

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 16) {
                        HStack {
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
                                }
                                Templates.Menu(present: $isPopoverPresented) {
                                    Templates.MenuButton(title: "Edit Profile")
                                    {
                                        navigateToEdit = true
                                    }
//                                    Templates.MenuButton(title: "Saved Gigs") {
//                                        print("Button 2 pressed")
//                                    }
//                                    Templates.MenuButton(title: "Set Passkey") {
//                                        print("Button 2 pressed")
//                                    }
                                    Templates.MenuButton(title: "Logout") {
                                        Task {
                                            handleLogout()
                                        }
                                    }
                                } label: { _ in
                                    Color.clear
                                        .frame(width: 0, height: 0)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(
                            destination: edit_profile_view(),
                            isActive: $navigateToEdit
                        ) {
                            EmptyView()
                        }
                        // Profile Picture and Name
                        VStack(spacing: 8) {
                            if let profileImage = GlobalData.shared.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }

                            Text(FormManager.shared.formData.name)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            Text(FormManager.shared.formData.email)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 16)

                        // Stats Section
                        HStack(spacing: geometry.size.width / 6) {
                            StatView(title: jobApplied, subtitle: "Applied")
                            StatView(title: GiggleGrade, subtitle: "Giggle Grade")
                        }
                        .padding()
                        .padding(.top, 4)
                        .background(Theme.backgroundColor)

                        // Biography Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Biography")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                            }

                            Text(
                                bioGraphy
                            )
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        }
                        .padding(.horizontal)

                        // Resume Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Resume")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Spacer()

                                Text("Upload a resume")
                                    .foregroundColor(.blue)
                                    .font(.callout)
                                    .onTapGesture {
                                        showPickerChoice = true
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
                                Text("No resumes found.")
                                    .foregroundColor(.gray)
                                    .font(.callout)
                            } else {
                                ForEach(resumeFiles, id: \.self) { file in
                                    ResumeCardView(
                                        ResumeName: file[0]
                                    )
                                }
                            }
                        }

                        .padding()
                        .background(Color(hex: "343434").opacity(0.6))
                        .cornerRadius(10)
                        .padding(.top, 8)

                        // Experience Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Experience")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.onPrimaryColor)

                                Spacer()

                                Text("See all")
                                    .foregroundColor(.blue)
                                    .font(.callout)
                                    .onTapGesture {
                                        // Handle see all action
                                    }
                            }

                            ForEach(ExperienceStore.shared.experiences) { experience in
                                HStack {
                                    Image(systemName: "music.note")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading) {
                                        Text(experience.position)
                                            .foregroundColor(.white)
                                            .font(.body)
                                        
                                        Text(experience.companyName)
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(experience.location)
                                            .foregroundColor(Theme.onPrimaryColor)
                                            .font(.caption)
                                        
                                        Text("\(experience.startDate) - \(experience.endDate)")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(hex: "343434").opacity(0.6))
                            .cornerRadius(10)
                        }
                        .padding(.top, 8)

                        // Portfolio Section
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text("Portfolio")
//                                    .font(.title3)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(Theme.onPrimaryColor)
//
//                                Spacer()
//
//                                Text("See all")
//                                    .foregroundColor(.blue)
//                                    .font(.callout)
//                                    .onTapGesture {
//                                        // Handle see all action
//                                    }
//                            }
//
//                            LazyVGrid(
//                                columns: [
//                                    GridItem(.flexible()),
//                                    GridItem(.flexible()),
//                                    GridItem(.flexible()),
//                                ], spacing: 16
//                            ) {
//                                ForEach(1...6, id: \.self) { index in
//                                    Image("portfolio\(index)")  // Replace with portfolio images
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 100)
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding()
                }
                
                NavigationLink(destination: LoginSimpleView(), isActive: $navigate) {
                                           EmptyView()
                                       }
            }
            .background(Theme.backgroundColor)
            .onAppear {
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
        userDefault.set("", forKey: "status")
        let status = UserDefaults.standard.string(forKey: "status")
        print(status!)
        navigate = true
    }
}

struct StatView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.onPrimaryColor)

            Text(subtitle)
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

#Preview {
    ProfileScreen()
}
