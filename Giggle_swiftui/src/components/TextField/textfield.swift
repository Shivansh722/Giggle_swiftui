import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var isSecure: Bool
    @Binding var text: String
    var icon: String
    var errorMessage: String? // Optional error message
    
    @State private var isTextHidden: Bool = true // State variable that toggles visibility of the text (for secure fields)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) { // Use VStack to stack text field and error message
            ZStack {
                Theme.onPrimaryColor
                    .cornerRadius(6)
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                    
                    // Conditional text field or secure text field
                    if isSecure {
                        Group {
                            if isTextHidden {
                                SecureField(placeholder, text: $text)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                TextField(placeholder, text: $text)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textContentType(.password)
                            }
                        }
                        .padding(.horizontal, 10)
                    } else {
                        TextField(placeholder, text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 10)
                    }
                    
                    // Toggle button for showing/hiding password text
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
            
            // Optional error message
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.leading, 20) // Align with the text field’s content
            }
        }
        .padding(.horizontal, 20)
        .frame(maxHeight: errorMessage != nil ? 70 : 50) // Adjust height based on error presence
    }
}
