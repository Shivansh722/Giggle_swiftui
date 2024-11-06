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
