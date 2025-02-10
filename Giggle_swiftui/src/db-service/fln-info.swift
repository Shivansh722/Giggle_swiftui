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
    let databaseID:String = "67729cb100158022ba8e"
    let UserCollectionID:String = "67729cdc0016234d1704"
    let FLNCollectionID:String = "67a9ae4e003d4845905c"
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    
    func saveFlnInfo() async {
        let defaults = UserDefaults.standard
        guard let userId = defaults.value(forKey: "userID") as? String else {
            print("Error: userID not found")
            return
        }

        do {
            let data: [String: Any] = [
                "user_id": userId,
                "fluency_score": FlnDataManager.shared.flnData.fluencyScore,
                "literacy_score": FlnDataManager.shared.flnData.literacyScore,
                "numeracy_score": FlnDataManager.shared.flnData.numeracyScore,
                "giggle_grade": FlnDataManager.shared.flnData.giggleGrade
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
