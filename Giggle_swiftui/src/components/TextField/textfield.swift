import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var isSecure: Bool
    @Binding var text: String
    var icon: String
    
    @State private var isTextHidden: Bool = true// State variable that toggles visibility of the text (for secure fields)

    
    //binding to create a two-way connection between a property that stores data, and a view that displays and changes the data.
 // reflects the text input here between the TextField and the parent view

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(6)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                //making conditional textfield or secured Text field as required
           
                
                if isSecure {
                    
                    //Group is a container view that allows you to group multiple views together without altering the layout.
                    //It’s often used for conditional views like here, where we need different TextField
                    
                   /* The Binding initializer takes two closures:

                    get: This closure retrieves the current value of text (like reading the current value).
                    set: This closure is called whenever the value changes, allowing custom logic to filter the input before it’s saved to text.
                    swift
                    Copy code
                    */

                    
                    
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
