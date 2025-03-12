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

    let userId = "67a9e3659de7bda07a47"

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
                            Image("face-id")  // Replace with your profile image asset
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .shadow(radius: 5)

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
                            StatView(title: "27", subtitle: "Applied")
                            StatView(title: "G+", subtitle: "Giggle Grade")
                            StatView(title: "14", subtitle: "Endorses")
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
                                "Hello, my name is Haley and I am a digital artist based in Mumbai. After graduating with a bachelor's degree in graphic design, I began my freelancing career by creating pop culture digital art. I have been creating commissions for two years and have designed art for popular businesses such as Spiced and The Paper Pepper Club."
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
                                        // Handle upload resume action
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
                }
            }
        }
    }

    private func loadUserFiles() async {
        let files = await saveUserInfo.fetchFiles(userId: userId)
        DispatchQueue.main.async {
            self.resumeFiles = files
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
