//
//  userData.swift
//  Giggle_swiftui
//
//  Created by admin49 on 17/12/24.
//

import Foundation

struct FormData {
    var userId: String
    var name: String
    var email: String
    var address: String
    var phone: String
    var DOB: String
    var gender: String
    var pursuing: String
    var degreeName: String
    var universityName: String
    var specialization: String
    var completionYear: Date
    var resumeIds: [String] = []
}

class FormManager: ObservableObject {
    static let shared = FormManager()
    private init() {}

    @Published var formData = FormData(
        userId: "", name: "", email: "", address: "", phone: "", DOB: "",
        gender: "", pursuing: "", degreeName: "", universityName: "",
        specialization: "", completionYear: Date(), resumeIds: [])
}
