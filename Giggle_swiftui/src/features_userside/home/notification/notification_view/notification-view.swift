//
//  notification-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 16/03/25.
//

import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let avatarInitials: String?
    let avatarIcon: String?
    let title: String
    let subtitle: String?
    let timestamp: String
    let hasActions: Bool
}

struct NotificationScreen: View {
    let jobs: [[String: Any]]
    @State private var notifications: [Notification] = []

    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Text("Notifications")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Notifications List
                    List {
                        ForEach(notifications) { notification in
                            HStack(alignment: .top, spacing: 12) {
                                // Avatar
                                ZStack(alignment: .topLeading) {
                                    Circle()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .overlay(
                                            Group {
                                                if let initials = notification.avatarInitials {
                                                    Text(initials)
                                                        .font(.system(size: 16))
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white)
                                                } else if let icon = notification.avatarIcon {
                                                    Image(systemName: icon)
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 20))
                                                }
                                            }
                                        )
                                    
                                    if notification.hasActions {
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(Theme.primaryColor)
                                    }
                                }
                                
                                // Notification content
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(notification.title)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                            .lineLimit(2)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text(notification.timestamp)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    
                                    if let subtitle = notification.subtitle {
                                        Text(subtitle)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                            .lineLimit(1)
                                    }
                                    
                                    if notification.hasActions {
                                        HStack(spacing: 12) {
                                            // Your button code can be uncommented here if needed
                                        }
                                    }
                                }
                            }
                            .listRowBackground(Theme.backgroundColor)
                            .listRowSeparatorTint(.gray)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
                                        notifications.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Convert jobs to notifications
                notifications = jobs.map { job in
                    return Notification(
                        avatarInitials: "",
                        avatarIcon: nil,
                        title: "New job has been posted of role\(job["job_title"]!) at \(job["companyName"]!)",
                        subtitle: "Location: \(job["location"]!)",
                        timestamp: job["$createdAt"] as? String ?? getCurrentTimestamp(),
                        hasActions: true
                    )
                }
            }
        }
    }
    
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}
