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
    @StateObject var flnInfo = FLNInfo(appService: AppService())
    @State private var flnID: String? = nil
    @State private var isLoading = true
    @State private var navigateToLiteracy = false
    @State private var notifications: [Notification] = []
    @State private var contentOpacity: Double = 0 // For fade-in animation
    @State private var showEmptyState: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack(alignment: .center) {
                        Text("Giggle")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                        Text("Alerts")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .opacity(contentOpacity)
                    .animation(.easeIn(duration: 0.3), value: contentOpacity)
                    
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .tint(Theme.onPrimaryColor)
                            .onAppear {
                                Task {
                                    await fetchFlnID()
                                }
                            }
                        Spacer()
                    } else if showEmptyState && notifications.isEmpty {
                        // Empty state view
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "bell.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Notifications Yet")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                            
                            Text("When you receive notifications, they'll appear here")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5).delay(0.2), value: contentOpacity)
                    } else {
                        // LinkedIn-style Notifications List
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(notifications.indices, id: \.self) { index in
                                    LinkedInNotificationCard(
                                        notification: notifications[index],
                                        job: index < jobs.count ? jobs[index] : [:],
                                        flnID: flnID,
                                        onDelete: {
                                            if let idx = notifications.firstIndex(where: { $0.id == notifications[index].id }) {
                                                withAnimation {
                                                    notifications.remove(at: idx)
                                                }
                                            }
                                        }
                                    )
                                    
                                    if index < notifications.count - 1 {
                                        Divider()
                                            .background(Color.gray.opacity(0.3))
                                    }
                                }
                            }
                        }
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5).delay(0.2), value: contentOpacity)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Animate content appearance
                withAnimation {
                    contentOpacity = 1
                }
                
                // Fix for notifications not appearing initially
                loadNotifications()
            }
        }
    }
    
    func fetchFlnID() async {
        flnID = await flnInfo.getFlnInfo()
        isLoading = false
        
        // Load notifications immediately after getting flnID
        loadNotifications()
    }
    
    // New function to load notifications
    private func loadNotifications() {
        if !isLoading && flnID != nil {
            // Convert jobs to notifications
            notifications = jobs.map { job in
                let timestamp = job["$createdAt"] as? String ?? ""
                let formattedTime = timeAgo(from: timestamp)
                
                return Notification(
                    avatarInitials: String(describing: job["companyName"] ?? "").prefix(2).uppercased(),
                    avatarIcon: "briefcase.fill",
                    title: "New job has been posted for role \(job["job_title"] ?? "") at \(job["companyName"] ?? "")",
                    subtitle: "\(job["location"] ?? "NA")",
                    timestamp: formattedTime,
                    hasActions: true
                )
            }
                                
            // Show empty state if needed (after a short delay to allow data loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showEmptyState = true
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
}

// LinkedIn-style notification card
struct LinkedInNotificationCard: View {
    let notification: Notification
    let job: [String: Any]
    let flnID: String?
    let onDelete: () -> Void
    @State private var navigateToGigInfo = false
    
    var body: some View {
        // Wrap the entire card in a NavigationLink
        NavigationLink(destination: GigInfoView(
            fln: flnID,
            jobId: job["$id"] as? String ?? "",
            jobs: job,
            base64Image: job["base64Image"] as? String
        ), isActive: $navigateToGigInfo) {
            HStack(alignment: .top, spacing: 12) {
                // Profile picture/avatar
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 48, height: 48)
                    
                    if let initials = notification.avatarInitials, !initials.isEmpty {
                        Text(initials)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.onPrimaryColor)
                    } else if let iconName = notification.avatarIcon {
                        Image(systemName: iconName)
                            .font(.system(size: 20))
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                }
                .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 6) {
                    // Notification content
                    Text(notification.title)
                        .font(.system(size: 16))
                        .foregroundColor(Theme.onPrimaryColor)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = notification.subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    // Timestamp
                    Text(notification.timestamp)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(Rectangle()) // Make the entire row tappable
            .background(Color.clear) // Clear background for the NavigationLink
        }
        .buttonStyle(PlainButtonStyle()) // Remove default NavigationLink styling
        // Add swipe-to-delete functionality
//        .swipeActions(edge: .trailing) {
//            Button(role: .destructive, action: onDelete) {
//                Label("Delete", systemImage: "trash")
//            }
//        }
    }
}
