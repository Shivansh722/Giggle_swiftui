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
        projectIdentifier: "677299c0003044510787",
        storageBucketId: "67863b500019e5de0dd8"
    )
    @State private var jobApplied:String = ""
    @State private var endorsed:String = "0"

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
                                    Templates.MenuButton(title: "Saved Gigs") {
                                        print("Button 2 pressed")
                                    }
                                    Templates.MenuButton(title: "Set Passkey") {
                                        print("Button 2 pressed")
                                    }
                                    Templates.MenuButton(title: "Logout") {
                                        Task {
                                            await handleLogout()
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
                                    Image("face-id")
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
                            StatView(title: "G+", subtitle: "Giggle Grade")
                            StatView(title: endorsed, subtitle: "Endorses")
                        }
                        .padding()
                        .padding(.top, 16)
                        .background(Theme.backgroundColor)

                        // Biography Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Biography")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            Text(
                                FormManager.shared.formData.Biography
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
                                        ResumeName: file[0], ResumeSize: file[1]
                                    )
                                }
                            }
                        }

                        .padding()
                        .background(Color(hex: "343434").opacity(0.6))
                        .cornerRadius(10)
                        .padding(.horizontal)
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

                            HStack {
                                Image(systemName: "music.note")  // Replace with company logo if available
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    Text("UX Intern")
                                        .foregroundColor(.white)
                                        .font(.body)

                                    Text("Spotify")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("San Jose, US")
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .font(.caption)

                                    Text("Dec 20 - Feb 21")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                            .padding()
                            .background(Color(hex: "343434").opacity(0.6))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Portfolio Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Portfolio")
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

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                ], spacing: 16
                            ) {
                                ForEach(1...6, id: \.self) { index in
                                    Image("portfolio\(index)")  // Replace with portfolio images
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
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
                }
            }
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
            let result = try await saveUserInfo.fetchUser()
            jobApplied = result
        } catch {
            print("Error loading user details: \(error)")
        }
    }

    private func handleLogout() async {
        let result = await logout.logout()

        switch result {
        case .success:
            DispatchQueue.main.async {
                navigate = true
            }
        case .error(let message):
            print("Logout failed: \(message)")
        }
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
