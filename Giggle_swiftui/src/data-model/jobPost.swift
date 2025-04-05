//
//  jobPost.swift
//  Giggle_swiftui
//
//  Created by admin49 on 05/03/25.
//

import Foundation

struct GetJobPost:Identifiable, Codable {
    var id: UUID
    var jobTitle: String
    var jobTrait: String
    var jobType: String
    var location: String
    var salary: String
    var companyName: String
    var jobDescription: String
    var position: String
    var qualification: String
    var experience: String
    var specialisation: String
    var facilities: [String]
    var requirements: [String]
}

class JobFormManager: ObservableObject {
    static let shared = JobFormManager()
    private init() {}
    
    @Published var formData = GetJobPost(id: UUID(), jobTitle: "", jobTrait: "", jobType: "", location: "", salary: "", companyName: "", jobDescription: "", position: "", qualification: "", experience: "", specialisation: "", facilities: [""], requirements: [""])
}

class JobTitleManager: ObservableObject {
    static let shared = JobTitleManager()
    private init() {} // Private initializer to ensure singleton
    
    @Published var jobPosts: [GetJobPostTest] = []
}

struct GetJobPostTest {
    var jobTitle: String
    var companyName: String
}
