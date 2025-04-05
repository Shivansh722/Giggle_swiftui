//
//  flnData.swift
//  Giggle_swiftui
//
//  Created by admin49 on 10/02/25.
//

import Foundation

struct FlnData {
    var userId:String
    var flnId:String
    var fluencyScore:String
    var numeracyScore:Int
    var literacyScore:Int
    var giggleGrade:String
    var transcriptionHistory: [(text: String, timestamp: TimeInterval, timeSinceLast: TimeInterval)]
    var CoherencePer:Double
    var GrammarPer:Double
    var VocabularyPer:Double
    var PronunciationPer:Double
    var coherenceCOntent:String
    var grammarContent:String
    var vocabularyContent:String
    var pronunciationContent:String
}

class FlnDataManager:ObservableObject {
    static let shared = FlnDataManager()
    private init() {}
    
    @Published var flnData = FlnData(userId: "",flnId: UUID().uuidString, fluencyScore: "", numeracyScore: 0, literacyScore: 0, giggleGrade: "",transcriptionHistory: [],CoherencePer:0.0,GrammarPer:0.0,VocabularyPer:0.0,PronunciationPer:0.0,coherenceCOntent:"",grammarContent:"",vocabularyContent:"",pronunciationContent:"")
}
