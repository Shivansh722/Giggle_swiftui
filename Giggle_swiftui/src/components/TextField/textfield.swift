//import SwiftUI
//
//struct CustomTextField: View {
//    var placeholder: String
//    var isSecure: Bool
//    @Binding var text: String
//    var icon: String
//    
//    @State private var isTextHidden: Bool = true
//    
//    var body: some View {
//        ZStack {
//            Color.white
//                .cornerRadius(6)
//            
//            HStack {
//                if isSecure {
//                    Group {
//                        if isTextHidden {
//                            SecureField(placeholder, text: $text)
//                        } else {
//                            TextField(placeholder, text: $text)
//                        }
//                    }
//                    .padding(.horizontal, 15)
//                } else {
//                    TextField(placeholder, text: $text)
//                        .padding(.horizontal, 15)
//                }
//                
//                if isSecure {
//                    Button(action: {
//                        isTextHidden.toggle()
//                    }) {
//                        Image(systemName: isTextHidden ? "eye.slash.fill" : "eye.fill")
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.trailing, 15)
//                }
//            }
//            .frame(height: 50)
//        }
//        .padding(.horizontal, 30)
//        .frame(height: 50)
//    }
//}
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var isSecure: Bool
    @Binding var text: String
    var icon: String
    @State private var selectedCountryCode: String = "+91" // Default country code
    @State private var isTextHidden: Bool = true

    // List of country codes
    let countryCodes = ["+91", "+1", "+44", "+81", "+61"] // Add more codes as needed

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(6)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                // Country Code Picker
                Picker("Country Code", selection: $selectedCountryCode) {
                    ForEach(countryCodes, id: \.self) { code in
                        Text(code).tag(code)
                    }
                }
                .frame(width: 70) // Adjust width as needed
                .clipped()
                .pickerStyle(MenuPickerStyle())
                
                if isSecure {
                    Group {
                        if isTextHidden {
                            SecureField(placeholder, text: Binding(
                                get: { self.text },
                                set: { newValue in
                                    self.text = filterPhoneInput(newValue)
                                }
                            ))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            TextField(placeholder, text: Binding(
                                get: { self.text },
                                set: { newValue in
                                    self.text = filterPhoneInput(newValue)
                                }
                            ))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textContentType(isSecure ? .password : .none)
                        }
                    }
                    .padding(.horizontal, 10)
                } else {
                    TextField(placeholder, text: Binding(
                        get: { self.text },
                        set: { newValue in
                            self.text = filterPhoneInput(newValue)
                        }
                    ))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 10)
                }

                if isSecure {
                    Button(action: {
                        isTextHidden.toggle()
                    }) {
                        Image(systemName: isTextHidden ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                }
            }
            .frame(height: 50)
            .font(.system(size: 16))
        }
        .padding(.horizontal, 20)
        .frame(height: 50)
    }
    
    // Function to filter phone number input to 10 digits
    private func filterPhoneInput(_ input: String) -> String {
        let filtered = input.filter { "0123456789".contains($0) } // Only allow digits
        return String(filtered.prefix(10)) // Limit to 10 digits
    }
}


///*
// GeometryReader: This is used in each component to access the parent view’s dimensions.
// Dynamic Widths and Heights: For each component, widths and heights are set as fractions of the parent view’s size, making them flexible.
// Padding and Font Size: Both padding and font sizes are made dynamic, adjusting based on available space for a responsive experience.
// */
//
//import SwiftUI
//
//struct CustomTextField: View {
//    var placeholder: String
//    var isSecure: Bool
//    @Binding var text: String
//    var icon: String
//
//    @State private var isTextHidden: Bool = true
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Color.white
//                    .cornerRadius(6)
//                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
//                
//                HStack {
//                    Image(systemName: icon)
//                        .foregroundColor(.gray)
//                        .padding(.leading, geometry.size.width * 0.05) // Dynamic left padding
//                    
//                    if isSecure {
//                        Group {
//                            if isTextHidden {
//                                SecureField(placeholder, text: $text)
//                                    .autocapitalization(.none)
//                                    .disableAutocorrection(true)
//                            } else {
//                                TextField(placeholder, text: $text)
//                                    .autocapitalization(.none)
//                                    .disableAutocorrection(true)
//                                    .textContentType(isSecure ? .password : .none)
//                            }
//                        }
//                        .padding(.horizontal, geometry.size.width * 0.03) // Dynamic padding
//                    } else {
//                        TextField(placeholder, text: $text)
//                            .autocapitalization(.none)
//                            .disableAutocorrection(true)
//                            .keyboardType(placeholder.lowercased() == "email" ? .emailAddress : .default)
//                            .textContentType(placeholder.lowercased() == "email" ? .emailAddress : .none)
//                            .padding(.horizontal, geometry.size.width * 0.03) // Dynamic padding
//                    }
//
//                    if isSecure {
//                        Button(action: {
//                            isTextHidden.toggle()
//                        }) {
//                            Image(systemName: isTextHidden ? "eye.slash.fill" : "eye.fill")
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.trailing, geometry.size.width * 0.05) // Dynamic right padding
//                    }
//                }
//                .frame(height: geometry.size.height * 0.1) // Responsive height
//                .font(.system(size: geometry.size.width * 0.05)) // Responsive font size
//            }
//            .padding(.horizontal, geometry.size.width * 0.05) // Adjusted horizontal padding
//            .frame(height: geometry.size.height * 0.12) // Adjusted height
//        }
//    }
//}
