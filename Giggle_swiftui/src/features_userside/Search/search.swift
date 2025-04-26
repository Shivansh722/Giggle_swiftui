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
                // Header with two-color text in a single row
                HStack(alignment: .firstTextBaseline) {
                    Text("Search")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text("Gigs")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.onPrimaryColor)
                    
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                
                // Search field
                CustomTextField(
                    placeholder: "Search by job title...",
                    isSecure: false,
                    text: $searchText,
                    icon: "magnifyingglass"
                )
                .padding(.horizontal, 16)
                
                // Results
                ScrollView {
                    if filteredJobs.isEmpty && !searchText.isEmpty {
                        Text("No jobs found matching '\(searchText)'")
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding()
                    } else {
                        ForEach(filteredJobs.indices, id: \.self) { index in
                            JobCardView(jobs: filteredJobs[index], flnID: flnID)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                                .onAppear {
                                    print("Rendering job: \(filteredJobs[index]["job_title"] ?? "unknown")")
                                }
                        }
                    }
                }
            }
            .padding(.top, 20)
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
