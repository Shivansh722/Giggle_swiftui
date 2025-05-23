//
//  fln-info.swift
//  Giggle_swiftui
//
//  Created by admin49 on 10/02/25.
//

import Foundation

import Foundation
import SwiftUI
import Appwrite

class FLNInfo: ObservableObject {
    let client: Client
    let database: Databases
    let appService: AppService
    let databaseID:String = "67da78cd00052312da62"
    let UserCollectionID:String = "67da79a900157497cced"
    let FLNCollectionID:String = "67da7a890023a1f7ed53"
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    
    func getFlnInfo() async -> String? {
        let defaults = UserDefaults.standard
        guard let userId = defaults.value(forKey: "userID") as? String else {
            print("Error: userID not found")
            return nil
        }
        
        do {
            let document = try await database.getDocument(
                databaseId: databaseID,
                collectionId: UserCollectionID,
                documentId: userId
            )
            
            if let fln_id = document.data["fln_id"]?.value as? String {
                return fln_id
            } else {
                print("FLN ID not found or is null")
                return nil
            }
        } catch {
            print("Error fetching document: \(error.localizedDescription)")
            return nil
        }
    }
    func getFlnUpdatedAt(flnId: String) async -> (String?,String?) {
        do {
            let document = try await database.getDocument(
                databaseId: databaseID,
                collectionId: FLNCollectionID,
                documentId: flnId
            )
            
            let updatedAt = document.updatedAt
            let grade = document.data["giggle_grade"]?.value as? String
            FlnDataManager.shared.flnData.giggleGrade = (document.data["giggle_grade"]?.value as? String)!
            FlnDataManager.shared.flnData.fluencyScore = (document.data["fluency_score"]?.value as? String)!
            FlnDataManager.shared.flnData.literacyScore = Int((document.data["literacy_score"]?.value as? Int)!)
            FlnDataManager.shared.flnData.numeracyScore = Int((document.data["numeracy_score"]?.value as? Int)!)
            print("Raw updatedAt value: \(updatedAt) grade \(grade ?? "null ")")
            // Create a more flexible date formatter
            let isoFormatter = DateFormatter()
            isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Common Appwrite format
            
            if let date = isoFormatter.date(from: updatedAt) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "EEEE, dd MMM" // "Saturday, 26 Oct"
                return (outputFormatter.string(from: date), grade)
            } else {
                print("Failed to parse date: \(updatedAt)")
                return (updatedAt,grade) // Fallback
            }
            
        } catch {
            print("Error fetching FLN document: \(error.localizedDescription)")
            return (nil,nil)
        }
    }
    
    // Example function combining both to get updatedAt from userID
    func getUserFlnUpdatedAt() async -> (String?,String?){
        guard let flnId = await getFlnInfo() else {
            print("Could not get FLN ID")
            return (nil,nil)
        }
        
        return await getFlnUpdatedAt(flnId: flnId)
    }

    func calculateGrade(literacyScore: Int, numeracyScore: Int, fluencyStringScore: String) -> String {
        // Convert fluency string score to Int safely
        guard let fluencyScore = Double(fluencyStringScore) else {
            print("Error: Invalid fluency score format")
            return "N" // Default grade if conversion fails
        }
        
        let totalScore = (Double(literacyScore + numeracyScore) / 10.0) * 100
        let cumulativeScore = (totalScore + Double(fluencyScore)) / 2.0
        
        switch cumulativeScore {
        case 90...100:
            return "G+"
        case 70..<90:
            return "G"
        case 60..<70:
            return "G-"
        default:
            return "N"
        }
    }
    
    func saveFlnInfo() async {
        let defaults = UserDefaults.standard
        guard let userId = defaults.value(forKey: "userID") as? String else {
            print("Error: userID not found")
            return
        }
        
        print("fluency score   " + FlnDataManager.shared.flnData.fluencyScore)
        let giggleGrade = calculateGrade(
                literacyScore: FlnDataManager.shared.flnData.literacyScore,
                numeracyScore: FlnDataManager.shared.flnData.numeracyScore,
                fluencyStringScore: FlnDataManager.shared.flnData.fluencyScore
            )
            
            FlnDataManager.shared.flnData.giggleGrade = giggleGrade
        
        do {
            let data: [String: Any] = [
                "user_id": userId,
                "fluency_score": FlnDataManager.shared.flnData.fluencyScore,
                "literacy_score": FlnDataManager.shared.flnData.literacyScore,
                "numeracy_score": FlnDataManager.shared.flnData.numeracyScore,
                "giggle_grade": giggleGrade
            ]

            let result = try await database.createDocument(
                databaseId: databaseID,
                collectionId: FLNCollectionID,
                documentId: UUID().uuidString,
                data: data
            )

            if let flnId = result.data["$id"] {
                let updateData: [String: Any] = ["fln_id": String(describing: flnId)]
                _ = try await database.updateDocument(
                    databaseId: databaseID,
                    collectionId: UserCollectionID,
                    documentId: userId,
                    data: updateData
                )
            } else {
                print("Error: Unable to extract document ID")
            }
        } catch {
            print("Error saving FLN info:", error)
        }
    }
}
