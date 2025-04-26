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
                    HStack(alignment: .firstTextBaseline) {
                        Text("Giggle")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("Notifications")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    
                    // Notifications List
                    List {
                        ForEach(notifications) { notification in
                            HStack(alignment: .top, spacing: 12) {
                                // Avatar
                                ZStack(alignment: .topLeading) {
//                                    Circle()
//                                        .frame(width: 40, height: 40)
//                                        .foregroundColor(.gray.opacity(0.3))
//                                        .overlay(
//                                            Group {
//                                                if let initials = notification.avatarInitials {
//                                                    Text(initials)
//                                                        .font(.system(size: 16))
//                                                        .fontWeight(.bold)
//                                                        .foregroundColor(.white)
//                                                } else if let icon = notification.avatarIcon {
//                                                    Image(systemName: icon)
//                                                        .foregroundColor(.white)
//                                                        .font(.system(size: 20))
//                                                }
//                                            }
//                                        )
                                    
//                                    if notification.hasActions {
//                                        Circle()
//                                            .frame(width: 12, height: 12)
//                                            .foregroundColor(Theme.primaryColor)
//                                    }
                                }
                                
                                // Notification content
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(notification.title)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                            .lineLimit(2)
                                        
                                        Spacer()
                                        
                                        Text(notification.timestamp)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                        
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
                    let timestamp = job["$createdAt"] as? String ?? ""
                    let formattedTime = timeAgo(from: timestamp)
                    
                    return Notification(
                        avatarInitials: "",
                        avatarIcon: nil,
                        title: "New job has been posted for role \(job["job_title"]!) at \(job["companyName"]!)",
                        subtitle: "Location: \(job["location"]!)",
                        timestamp: formattedTime,
                        hasActions: true
                    )
                }
            }
        }
    }
    
    private func timeAgo(from isoDateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: isoDateString) else {
            return "Just now"
        }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return "\(years)y ago"
        } else if let months = components.month, months > 0 {
            return "\(months)mo ago"
        } else if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
    
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

