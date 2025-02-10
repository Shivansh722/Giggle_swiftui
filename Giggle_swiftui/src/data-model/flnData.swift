//
//  flnData.swift
//  Giggle_swiftui
//
//  Created by admin49 on 10/02/25.
//

import Foundation

struct FlnData: Codable {
    var userId:String
    var flnId:String
    var fluencyScore:String
    var numeracyScore:Int
    var literacyScore:Int
    var giggleGrade:String
}

class FlnDataManager:ObservableObject {
    static let shared = FlnDataManager()
    private init() {}
    
    @Published var flnData = FlnData(userId: "",flnId: UUID().uuidString, fluencyScore: "", numeracyScore: 0, literacyScore: 0, giggleGrade: "G+")
}
