//
//  PhNo.swift
//  Giggle_swiftui
//
//  Created by user@91 on 10/11/24.
//

import SwiftUI

struct PhoneNumberInputView: View {
    @State private var selectedCountryCode = "+1"
    @State private var phoneNumber = ""
    
    let countryCodes = ["+1", "+91", "+44", "+61", "+33"]

    var body: some View {
        VStack {
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Theme.onPrimaryColor)
                    .frame(height: 60)
                    .overlay(
                        HStack {
                            
                            Picker("Country Code", selection: $selectedCountryCode) {
                                ForEach(countryCodes, id: \.self) { code in
                                    Text(code)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 80)
                            .padding(.leading, 10)
                            
                            
                            TextField("Enter phone number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .padding(10)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(height: 40)
                        }
                        .padding(.horizontal, 5)
                    )
            }
            .padding(.horizontal)
        }
    }
}
