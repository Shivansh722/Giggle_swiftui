//
//  clientData.swift
//  Giggle_swiftui
//
//  Created by admin49 on 09/02/25.
//

import Foundation

struct ClientData: Codable {
    var name: String
    var DOB: Date
    var gender: String
    var phone: String
    var employerDetail: String
    var workTrait: String
    var storeName: String
    var location: String
    var photos: [String] = []
}

class ClientFormManager: ObservableObject {
    static let shared = ClientFormManager()
    private init() {}

    @Published var clientData = ClientData(name: "", DOB: Date(), gender: "", phone: "", employerDetail: "",workTrait: "", storeName: "", location: "")
}
