import SwiftUI

struct PhoneNumberInputView: View {
    @State private var selectedCountryCode = "+1"
    @State private var phoneNumber = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                                .onChange(of: phoneNumber) { newValue in
                                    // Allow only digits and limit to 10 digits
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered.count <= 10 {
                                        phoneNumber = filtered
                                    } else {
                                        phoneNumber = String(filtered.prefix(10))
                                    }
                                }
                        }
                        .padding(.horizontal, 5)
                    )
            }
            .padding(.horizontal)

            Button(action: {
                // Check if phone number is exactly 10 digits
                if phoneNumber.count == 10 {
                    // Proceed with further actions
                    print("Phone number is valid: \(selectedCountryCode) \(phoneNumber)")
                } else {
                    // Show alert if phone number is not valid
                    alertMessage = "Please enter a valid 10-digit phone number."
                    showAlert = true
                }
            }) {
                Text("Submit")
                    .padding()
                    .background(Theme.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Phone Number"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
