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
    // State to manage the list of notifications
    @State private var notifications: [Notification] = [
        Notification(
            avatarInitials: "AB",
            avatarIcon: nil,
            title: "Ashwin Bose has invited you to apply for a UI/UX Designer role.",
            subtitle: nil,
            timestamp: "15h",
            hasActions: true
        ),
        Notification(
            avatarInitials: nil,
            avatarIcon: "briefcase.fill",
            title: "Your manager has shared a job opening",
            subtitle: "“A new position for Machine Learning Engineer is open. Apply now!”",
            timestamp: "15h",
            hasActions: false
        ),
        Notification(
            avatarInitials: nil,
            avatarIcon: "person.fill",
            title: "Samantha recommended you for a Software Developer position.",
            subtitle: nil,
            timestamp: "15h",
            hasActions: false
        ),
        Notification(
            avatarInitials: "SJ",
            avatarIcon: nil,
            title: "Steve has referred you for a Data Analyst role.",
            subtitle: nil,
            timestamp: "15h",
            hasActions: false
        )

    ]

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
                        
                        Spacer()
                        
                        // Header icons
                        HStack(spacing: 16) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
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
                                    
                                    // Red dot for the first notification
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
                                        
                                        // Timestamp and more icon
                                        VStack(alignment: .trailing) {
                                            Text(notification.timestamp)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    
                                    // Subtitle (if present)
                                    if let subtitle = notification.subtitle {
                                        Text(subtitle)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                            .lineLimit(1)
                                    }
                                    
                                    // Action buttons (if present)
                                    if notification.hasActions {
                                        HStack(spacing: 12) {
//                                            Button(action: {}) {
//                                                Text("Apply")
//                                                    .font(.system(size: 16))
//                                                    .fontWeight(.medium)
//                                                    .foregroundColor(.white)
//                                                    .frame(maxWidth: .infinity)
//                                                    .padding(.vertical, 8)
//                                                    .background(Theme.primaryColor)
//                                                    .cornerRadius(8)
//                                            }
                                            
//                                            Button(action: {}) {
//                                                Text("Decline")
//                                                    .font(.system(size: 16))
//                                                    .fontWeight(.medium)
//                                                    .foregroundColor(.white)
//                                                    .frame(maxWidth: .infinity)
//                                                    .padding(.vertical, 8)
//                                                    .background(Color.gray.opacity(0.3))
//                                                    .cornerRadius(8)
//                                            }
                                        }
                                    }
                                }
                            }
                            .listRowBackground(Theme.backgroundColor)
                            .listRowSeparatorTint(.gray)
                            // Swipe to delete (right-to-left)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    // Delete the notification
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
            .navigationBarHidden(true) // Hide default navigation bar
        }
    }
}

// Preview
#Preview{
    NotificationScreen()
}
