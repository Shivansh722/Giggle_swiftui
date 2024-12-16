//
//  JobCardView.swift
//  Giggle_swiftui
//
//  Created by user@91 on 16/12/24.
//

import SwiftUI

struct JobCardView: View {
    var body: some View {
       
            // Background Color
           
            
            VStack {
                // Card View
                VStack(spacing: 16) {
                    HStack(alignment: .center) {
                        // Logo and Text
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Product Designer")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Google inc • California, USA")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        
                        Spacer()
                        
                        // Bookmark Icon
                        Button(action: {}) {
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: 20, height: 30)
                                .foregroundColor(Color.gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Salary Section
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("₹90K")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("/Mo")
                            .font(.system(size: 16))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.top, -8)
                    
                    // Tags and Time
                    HStack {
                        HStack(spacing: 8) {
                            Text("Senior designer")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                            
                            Text("Part time")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                        }
                        Spacer()
                        Text("2 days ago")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                    }
                }
                .padding()
                .background(Theme.backgroundColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 16)
            }
        }
    }


#Preview {
    JobCardView()
}
