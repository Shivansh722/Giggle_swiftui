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
    
    // Filter options
    let jobTypes = ["All", "Full-time", "Part-time", "Remote", "On-Site", "Contract", "Internship"]
    let jobTraits = ["All", "Technical", "Management", "Creative", "Support", "Sales"]
    let locations = ["All", "Mumbai", "Delhi", "Kolkata", "Chennai", "Bengaluru", "Pune", "Hyderabad"]
    let salaryRange: ClosedRange<Double> = 0...10000
    
    var jobresult: [[String: Any]]
    var flnID: String?
    
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
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.primaryColor)
                        .font(.system(size: 20))
                    
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
                    
                    TextField("Search by job title, company, or keywords...", text: $searchText)
                        .padding(.vertical, 12)
                        .foregroundColor(.black)
                    
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
                .background(Color.white)
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
                                    .foregroundColor(.white)
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
                                    .padding(.horizontal, 16)
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
        }
        .onChange(of: searchText) { newValue in
            applyFilters()
        }
    }
    
    // Apply all filters
    private func applyFilters() {
        Task { @MainActor in
            var filtered = jobresult
            
            // Apply text search
            if !searchText.isEmpty {
                filtered = filtered.filter { jobDict in
                    guard let jobTitle = jobDict["job_title"] as? String,
                          let companyName = jobDict["companyName"] as? String else { return false }
                    
                    return jobTitle.lowercased().contains(searchText.lowercased()) ||
                           companyName.lowercased().contains(searchText.lowercased())
                }
            }
            
            // Apply job type filter
            if selectedJobType != "All" {
                filtered = filtered.filter { jobDict in
                    guard let jobType = jobDict["job_type"] as? String else { return false }
                    return jobType == selectedJobType
                }
            }
            
            // Apply job trait filter
            if selectedJobTrait != "All" {
                filtered = filtered.filter { jobDict in
                    guard let jobTrait = jobDict["job_trait"] as? String else { return false }
                    return jobTrait == selectedJobTrait
                }
            }
            
            // Apply location filter
            if selectedLocation != "All" {
                filtered = filtered.filter { jobDict in
                    guard let location = jobDict["location"] as? String else { return false }
                    return location.contains(selectedLocation)
                }
            }
            
            // Apply salary filter
            filtered = filtered.filter { jobDict in
                guard let salaryString = jobDict["salary"] as? String,
                      let salary = Double(salaryString) else { return false }
                return salary >= selectedSalaryRange.lowerBound && salary <= selectedSalaryRange.upperBound
            }
            
            // Check if any filter is applied
            isFilterApplied = selectedJobType != "All" || 
                              selectedJobTrait != "All" || 
                              selectedLocation != "All" || 
                              selectedSalaryRange.lowerBound > salaryRange.lowerBound || 
                              selectedSalaryRange.upperBound < salaryRange.upperBound
            
            filteredJobs = filtered
        }
    }
    
    // Reset all filters
    private func resetFilters() {
        selectedJobType = "All"
        selectedJobTrait = "All"
        selectedLocation = "All"
        selectedSalaryRange = salaryRange
        isFilterApplied = false
        applyFilters()
    }
}

// Custom Filter Chip View
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
                .foregroundColor(isSelected ? .white : Theme.onPrimaryColor)
        }
    }
}

// Custom Range Slider
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
