import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var isSecure: Bool
    @Binding var text: String
    var icon: String
    
    @State private var isTextHidden: Bool = true // State variable that toggles visibility of the text (for secure fields)
    
    // Binding to create a two-way connection between a property that stores data and a view that displays and changes the data.
    // Reflects the text input here between the TextField and the parent view

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(6)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                // Making conditional text field or secure text field as required
                if isSecure {
                    // Group is a container view that allows you to group multiple views together without altering the layout.
                    // It’s often used for conditional views like here, where we need different TextField
                    
                    Group {
                        if isTextHidden {
                            SecureField(placeholder, text: $text)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            TextField(placeholder, text: $text)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .textContentType(isSecure ? .password : .none)
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
        .padding(.horizontal, 20)
        .frame(height: 50)
    }
}
