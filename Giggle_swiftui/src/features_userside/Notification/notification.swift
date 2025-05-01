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
                // Background with subtle gradient overlay
                Theme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Enhanced Header
                    VStack(spacing: 8) {
                        HStack(alignment: .center) {
                            Text("Giggle")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Notifications")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            
                            Spacer()
                            EmptyView()
                            
                        }

                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .opacity(contentOpacity)
                    .animation(.easeIn(duration: 0.3), value: contentOpacity)
                    
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .onAppear {
                                Task {
                                    await fetchFlnID()
                                }
                            }
                        Spacer()
                    } else if showEmptyState && notifications.isEmpty{
                        // Empty state view
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "bell.slash")
                                .font(.system(size: 60))
                                .foregroundColor(Theme.primaryColor.opacity(0.7))
                            
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
                        // Enhanced Notifications List
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(notifications.indices, id: \.self) { index in
                                    NotificationCard(
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
                                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 8)
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
        }
    }
    
    func fetchFlnID() async {
        flnID = await flnInfo.getFlnInfo()
        isLoading = false
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

// New component for notification cards
struct NotificationCard: View {
    let notification: Notification
    let job: [String: Any]
    let flnID: String?
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    @State private var navigateToGigInfo = false
    
    var body: some View {
        ZStack {
            
            // Card content
            HStack(alignment: .top, spacing: 16) {
                // Avatar with improved styling
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Theme.primaryColor, Theme.primaryColor.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 50, height: 50)
                        .shadow(color: Theme.primaryColor.opacity(0.3), radius: 3)
                    
                    if let initials = notification.avatarInitials, !initials.isEmpty {
                        Text(initials)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    } else if let icon = notification.avatarIcon {
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                    }
                    
                    if notification.hasActions {
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.white)
                            .overlay(
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.green)
                            )
                            .offset(x: 20, y: -20)
                    }
                }
                
                // Notification content with improved styling
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text(notification.title)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        Text(notification.timestamp)
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    
                    if let subtitle = notification.subtitle {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Theme.primaryColor.opacity(0.8))
                                .font(.system(size: 14))
                            
                            Text(subtitle)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .lineLimit(1)
                        }
                    }
                    
                    if notification.hasActions {
                        HStack(spacing: 12) {
                            NavigationLink(destination:
                                GigInfoView(
                                    fln: flnID,
                                    jobId: job["$id"] as? String ?? "",
                                    jobs: job,
                                    base64Image: job["base64Image"] as? String
                                ),
                                isActive: $navigateToGigInfo
                            ) {
                                Button(action: {
                                    navigateToGigInfo = true
                                }) {
                                    Text("View Details")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(Theme.primaryColor)
                                        .cornerRadius(20)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "343434").opacity(0.6))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            isSwiping = true
                            offset = gesture.translation.width
                        }
                    }
                    .onEnded { gesture in
                        withAnimation(.spring()) {
                            if gesture.translation.width < -100 {
                                onDelete()
                            } else {
                                offset = 0
                            }
                            isSwiping = false
                        }
                    }
            )
        }
    }
}
