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
            
            HStack {
                if isSecure {
                    Group {
                        if isTextHidden {
                            SecureField(placeholder, text: $text)
                        } else {
                            TextField(placeholder, text: $text)
                        }
                    }
                    .padding(.horizontal, 15)
                } else {
                    TextField(placeholder, text: $text)
                        .padding(.horizontal, 15)
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
        }
        .padding(.horizontal, 30)
        .frame(height: 50)
    }
}
