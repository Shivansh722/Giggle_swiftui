// SearchScreen.swift
import SwiftUI

struct SearchScreen: View {
    @ObservedObject var formManager = FormManager.shared
    @State private var searchText: String = ""
    @State private var filteredJobs: [[String: Any]] = []
    @State private var showFilters: Bool = false
    @State private var selectedJobType: String = "All"
    @State private var selectedSalaryRange: ClosedRange<Double> = 0...10000
    @State private var selectedLocation: String = "All"
    @State private var selectedJobTrait: String = "All"
    @State private var isFilterApplied: Bool = false
    var jobresult: [[String: Any]]
    var flnID: String?
    
    let jobTypes = ["All", "Full-time", "Part-time", "Remote", "On-Site", "Contract", "Internship"]
    let jobTraits = ["All", "Technical", "Management", "Creative", "Support", "Sales"]
    let locations = ["All", "Mumbai", "Delhi", "Kolkata", "Chennai", "Bengaluru", "Pune", "Hyderabad"]
    let salaryRange: ClosedRange<Double> = 0...10000
    
    var body: some View {
        ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        // Header with animation
                        HStack() {
                            Text("Search")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Gigs")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    showFilters.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(isFilterApplied ? Theme.primaryColor : Theme.onPrimaryColor)
                                    
                                    Text("Filters")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isFilterApplied ? Theme.primaryColor : Theme.onPrimaryColor)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(isFilterApplied ? Theme.primaryColor.opacity(0.2) : Color.gray.opacity(0.2))
                                )
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        
                        // Search field with enhanced design
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            
                            TextField("Search by job title, company, or keywords", text: $searchText)
                                .padding(.vertical, 12)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 12)
                                }
                            }
                        }
                        .background(Theme.onPrimaryColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        // Filter panel
                        if showFilters {
                            VStack(spacing: 16) {
                                // Job Type Filter
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Job Type")
                                        .font(.headline)
                                        .foregroundColor(Theme.onPrimaryColor)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(jobTypes, id: \.self) { type in
                                                FilterChipView(
                                                    title: type,
                                                    isSelected: selectedJobType == type,
                                                    action: { selectedJobType = type }
                                                )
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                                
                                // Job Trait Filter
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Job Category")
                                        .font(.headline)
                                        .foregroundColor(Theme.onPrimaryColor)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(jobTraits, id: \.self) { trait in
                                                FilterChipView(
                                                    title: trait,
                                                    isSelected: selectedJobTrait == trait,
                                                    action: { selectedJobTrait = trait }
                                                )
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                                
                                // Location Filter
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Location")
                                        .font(.headline)
                                        .foregroundColor(Theme.onPrimaryColor)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(locations, id: \.self) { location in
                                                FilterChipView(
                                                    title: location,
                                                    isSelected: selectedLocation == location,
                                                    action: { selectedLocation = location }
                                                )
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                                
                                // Salary Range Filter
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Salary Range")
                                            .font(.headline)
                                            .foregroundColor(Theme.onPrimaryColor)
                                        
                                        Spacer()
                                        
                                        Text("$\(Int(selectedSalaryRange.lowerBound)) - $\(Int(selectedSalaryRange.upperBound))")
                                            .font(.subheadline)
                                            .foregroundColor(Theme.primaryColor)
                                    }
                                    
                                    RangeSlider(range: $selectedSalaryRange, bounds: salaryRange)
                                        .frame(height: 30)
                                }
                                
                                // Filter action buttons
                                HStack {
                                    Button(action: {
                                        resetFilters()
                                    }) {
                                        Text("Reset")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Theme.onPrimaryColor)
                                            .padding(.vertical, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    
                                    Button(action: {
                                        applyFilters()
                                        withAnimation {
                                            showFilters = false
                                        }
                                    }) {
                                        Text("Apply")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Theme.onPrimaryColor)
                                            .padding(.vertical, 12)
                                            .frame(maxWidth: .infinity)
                                            .background(Theme.primaryColor)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        // Results count
                        HStack {
                            Text("\(filteredJobs.count) jobs found")
                                .font(.subheadline)
                                .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                            
                            Spacer()
                            
                            if isFilterApplied {
                                HStack(spacing: 4) {
                                    Text("Filters applied")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.primaryColor)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Theme.primaryColor)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Results
                        if filteredJobs.isEmpty {
                            VStack(spacing: 20) {
                                Spacer()
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(Theme.onPrimaryColor.opacity(0.3))
                                
                                Text(searchText.isEmpty && !isFilterApplied ? "Search for jobs" : "No jobs found")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(Theme.onPrimaryColor)
                                
                                Text(searchText.isEmpty && !isFilterApplied ?
                                     "Try searching for job titles, companies, or keywords" :
                                     "Try adjusting your search or filters")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Spacer()
                            }
                            .padding(.top, 40)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(filteredJobs.indices, id: \.self) { index in
                                        JobCardView(jobs: filteredJobs[index], flnID: flnID)
                                    }
                                }
                                .padding(.top, 16)
                                .padding(.bottom, 100) // Extra padding at bottom for better scrolling
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
    
    func resetFilters() {
        Task { @MainActor in
            // Reset all filter states to their default values
            selectedJobType = "All"
            selectedJobTrait = "All"
            selectedLocation = "All"
            selectedSalaryRange = 0...10000
            isFilterApplied = false
            
            // Reset filtered jobs to original jobresult
            filteredJobs = jobresult
            
            print("Filters reset - jobs restored: \(filteredJobs.count)")
        }
    }

    func applyFilters() {
        Task { @MainActor in
            filteredJobs = jobresult.filter { jobDict in
                print("Raw job_type: \(jobDict["job_type"] ?? "nil")")
                
                let jobTypeMatch: Bool
                if selectedJobType == "All" {
                    jobTypeMatch = true
                } else if let jobType = jobDict["job_type"] {
                    let jobTypeString = "\(jobType)"
                    jobTypeMatch = jobTypeString.lowercased().contains(selectedJobType.lowercased())
                } else {
                    jobTypeMatch = false
                }
                print("Job Type Match: \(jobTypeMatch) for job: \(jobDict["job_title"] ?? "Unknown")")

                let jobTraitMatch: Bool
                if selectedJobTrait == "All" {
                    jobTraitMatch = true
                } else if let jobTrait = jobDict["job_trait"] {
                    let jobTraitString = "\(jobTrait)"
                    jobTraitMatch = jobTraitString.lowercased().contains(selectedJobTrait.lowercased())
                } else {
                    jobTraitMatch = false
                }
                print("Job Trait Match: \(jobTraitMatch) for job: \(jobDict["job_title"] ?? "Unknown")")

                let locationMatch: Bool
                if selectedLocation == "All" {
                    locationMatch = true
                } else if let location = jobDict["location"] {
                    let locationString = "\(location)"
                    locationMatch = locationString.lowercased().contains(selectedLocation.lowercased())
                } else {
                    locationMatch = false
                }
                print("Location Match: \(locationMatch) for job: \(jobDict["job_title"] ?? "Unknown")")

                let salaryMatch: Bool
                if let salary = jobDict["salary"], let salaryValue = Double("\(salary)") {
                    salaryMatch = selectedSalaryRange.contains(salaryValue)
                } else {
                    salaryMatch = true
                }
                print("Salary Match: \(salaryMatch) for job: \(jobDict["job_title"] ?? "Unknown")")

                let searchMatch: Bool
                if !searchText.isEmpty {
                    guard let jobTitle = jobDict["job_title"] else { return false }
                    let jobTitleString = "\(jobTitle)"
                    searchMatch = jobTitleString.lowercased().contains(searchText.lowercased())
                } else {
                    searchMatch = true
                }
                print("Search Match: \(searchMatch) for job: \(jobDict["job_title"] ?? "Unknown")")

                return jobTypeMatch && jobTraitMatch && locationMatch && salaryMatch && searchMatch
            }

            isFilterApplied = selectedJobType != "All" ||
                             selectedJobTrait != "All" ||
                             selectedLocation != "All" ||
                             selectedSalaryRange != salaryRange

            print("Filters applied - jobs filtered: \(filteredJobs.count)")
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

struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Theme.primaryColor : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? Theme.onPrimaryColor : Theme.onPrimaryColor)
        }
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                    .cornerRadius(3)
                
                // Selected Range
                Rectangle()
                    .fill(Theme.primaryColor)
                    .frame(width: CGFloat((range.upperBound - range.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width,
                           height: 6)
                    .offset(x: CGFloat((range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width)
                    .cornerRadius(3)
                
                // Lower Thumb
                Circle()
                    .fill(Theme.primaryColor)
                    .frame(width: 24, height: 24)
                    .offset(x: CGFloat((range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(value.location.x / geometry.size.width)
                                range = max(bounds.lowerBound, min(newValue, range.upperBound - 500))...range.upperBound
                            }
                    )
                
                // Upper Thumb
                Circle()
                    .fill(Theme.primaryColor)
                    .frame(width: 24, height: 24)
                    .offset(x: CGFloat((range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * Double(value.location.x / geometry.size.width)
                                range = range.lowerBound...min(bounds.upperBound, max(newValue, range.lowerBound + 500))
                            }
                    )
            }
        }
    }
}
