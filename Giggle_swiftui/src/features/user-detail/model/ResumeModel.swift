struct ResumeModel: Codable {
    let name: String
    let contact: String
    let summary: String
    let skills: [String]
    let experience: [String]
    let education: [String]
    let certifications: [String]
    let languages: [String]
    let projects: [Project]
    let awards: [String]
}

struct Project: Codable {
    let title: String
    let description: String
}
