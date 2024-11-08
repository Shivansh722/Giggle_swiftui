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

    @State private var isTextHidden: Bool = true

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(6)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                if isSecure {
                    Group {
                        if isTextHidden {
                            SecureField(placeholder, text: $text)
                                .autocapitalization(.none)       // Disable autocapitalization for secure fields
                                .disableAutocorrection(true)      // Disable autocorrection
                        } else {
                            TextField(placeholder, text: $text)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textContentType(isSecure ? .password : .none) // For better form autofill experience
                        }
                    }
                    .padding(.horizontal, 10)
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(placeholder.lowercased() == "email" ? .emailAddress : .default) // Set keyboard type for email
                        .textContentType(placeholder.lowercased() == "email" ? .emailAddress : .none)
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
            .font(.system(size: 16)) // Adjust font size
        }
        .padding(.horizontal, 20)
        .frame(height: 50)
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
