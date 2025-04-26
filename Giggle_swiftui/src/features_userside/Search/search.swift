//
//  search.swift
//  Giggle_swiftui
//
//  Created by user@91 on 26/04/25.
//

// SearchScreen.swift
import SwiftUI

struct SearchScreen: View {
    @ObservedObject var formManager = FormManager.shared
    @State private var searchText: String = ""
    @State private var filteredJobs: [[String: Any]] = []
    var jobresult: [[String: Any]]
    var flnID: String?
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                ZStack(alignment: .leading) {
                    Text("Search Gigs")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.onPrimaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 16)
                
                CustomTextField(placeholder: "Search by job title...", isSecure: false, text: $searchText, icon: "magnifyingglass")
                
                ScrollView {
                    if filteredJobs.isEmpty && !searchText.isEmpty {
                        Text("No jobs found matching '\(searchText)'")
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding()
                    } else {
                        ForEach(filteredJobs.indices, id: \.self) { index in
                            JobCardView(jobs: filteredJobs[index], flnID: flnID)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                .onAppear {
                                    print("Rendering job: \(filteredJobs[index]["job_title"] ?? "unknown")")
                                }
                        }
                    }
                }
            }
        }
        .onAppear {
            filteredJobs = jobresult
            print("Search tab appeared - jobs: \(filteredJobs.count)")
        }
        .onChange(of: searchText) { newValue in
            filterJobs(searchText: newValue)
        }
    }
    
    func filterJobs(searchText: String) {
        Task { @MainActor in
            if searchText.isEmpty {
                filteredJobs = jobresult
            } else {
                filteredJobs = jobresult.filter { jobDict in
                    guard let jobTitle = jobDict["job_title"] as? String else { return false }
                    return jobTitle.lowercased().contains(searchText.lowercased())
                }
            }
            print("Filtered jobs count: \(filteredJobs.count) for search: '\(searchText)'")
        }
    }
}
