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
            ZStack {
                // Background box with custom styles
                RoundedRectangle(cornerRadius: 10)
                    .fill(Theme.onPrimaryColor) // Background color with opacity for light gray
                    .frame(height: 60) // Height of the entire box
                    .overlay(
                        HStack {
                            // Country code picker
                            Picker("Country Code", selection: $selectedCountryCode) {
                                ForEach(countryCodes, id: \.self) { code in
                                    Text(code)
                                }
                            }
                            .pickerStyle(MenuPickerStyle()) // Dropdown style for country code selection
                            .frame(width: 80) // Set fixed width for the picker
                            .padding(.leading, 10)
                            
                            // Phone number input
                            TextField("Enter phone number", text: $phoneNumber)
                                .keyboardType(.phonePad) // Phone number keyboard
                                .padding(10)
                                .textFieldStyle(PlainTextFieldStyle()) // TextField style without border
                                .frame(height: 40)
                        }
                        .padding(.horizontal, 5)
                    )
            }
            .padding(.horizontal) // Padding around the box
        }
    }
}
