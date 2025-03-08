//
//  jobPost.swift
//  Giggle_swiftui
//
//  Created by admin49 on 05/03/25.
//

import Foundation

struct GetJobPost:Identifiable, Codable {
    let id: String
    let jobTitle: String
    let jobTrait: String
    let jobType: String
    let location: String
    let salary: String
    let createdAt: String
    let updatedAt: String
}

