//
//  ProfileViewModel.swift
//  Giggle_swiftui
//
//  Created by rjk on 19/03/25.
//


import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var name: String = "Haley Jessica"
    @Published var email: String = "demo@gmail.com"
    @Published var biography: String = """
        Hello, my name is Haley and I am a digital artist based in Mumbai. After graduating with a bachelor's degree in graphic design, I began my freelancing career by creating pop culture digital art. I have been creating commissions for two years and have designed art for popular businesses such as Spiced and The Paper Pepper Club.
        """
}