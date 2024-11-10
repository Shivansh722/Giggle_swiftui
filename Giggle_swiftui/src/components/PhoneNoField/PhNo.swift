//
//  PhNo.swift
//  Giggle_swiftui
//
//  Created by user@91 on 10/11/24.
//

import SwiftUI

struct PhoneNumberInputView: View {
    @State private var selectedCountryCode = "+1" // Default to US country code
    @State private var phoneNumber = ""
    
    let countryCodes = ["+1", "+91", "+44", "+61", "+33"] // Add more country codes here

    var body: some View {
        VStack {
            HStack {
                // Country code picker
                Picker("Country Code", selection: $selectedCountryCode) {
                    ForEach(countryCodes, id: \.self) { code in
                        Text(code)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Change this style as per your UI preference
                
                // Phone number input
                TextField("Enter phone number", text: $phoneNumber)
                    .keyboardType(.phonePad) // This ensures the keyboard is for phone input
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            Text("Full Phone Number: \(selectedCountryCode) \(phoneNumber)")
                .padding(.top)
        }
        .padding()
    }
}
