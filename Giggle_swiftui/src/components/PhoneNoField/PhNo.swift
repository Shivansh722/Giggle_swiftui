import SwiftUI

struct PhoneNumberInputView: View {
    @Binding var selectedCountryCode: String
    @Binding var phoneNumber: String
    @Binding var showAlert: Bool
    @Binding var alertMessage: String

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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Phone Number"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
