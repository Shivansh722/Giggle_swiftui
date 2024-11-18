//
//  chipViewModel.swift
//  Giggle_swiftui
//
//  Created by user@91 on 18/11/24.
//

import SwiftUI

class PreferenceViewModel: ObservableObject {
    
    struct PreferenceModel: Identifiable {
        let id = UUID()
        var isSelected: Bool
        let title: String
    }
    
    @Published var PreferenceArray: [PreferenceModel]

    init() {
        self.PreferenceArray = [
            PreferenceModel(isSelected: false, title: "Swift"),
            PreferenceModel(isSelected: false, title: "Kotlin"),
            PreferenceModel(isSelected: false, title: "Java"),
            PreferenceModel(isSelected: false, title: "JavaScript"),
            PreferenceModel(isSelected: false, title: "Python")
        ]
    }

    // init(items: [String]) {
    //     self.PreferenceArray = items.map { PreferenceModel(isSelected: false, title: $0) }
    // }
    // This initializer takes an array of strings (items) as input.
    // It maps each string to a PreferenceModel with 'isSelected' set to false and
    // the string as the 'title'. The resulting array is then assigned to 'PreferenceArray'.
    
    func getSelectedPreferences() -> [String] {
        return PreferenceArray.filter { $0.isSelected }.map { $0.title }
    }
    // This function returns an array of titles for all selected preferences.
    // It first filters the 'PreferenceArray' to include only those items
    // where 'isSelected' is true, then maps the filtered result to an array of their titles.
}
