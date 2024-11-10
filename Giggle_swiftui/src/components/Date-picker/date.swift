//
//  date.swift
//  Giggle_swiftui
//
//  Created by user@91 on 10/11/24.
//
/*
 
 The @Binding property wrapper is used in SwiftUI to create a two-way connection between a view and a piece of state that lives outside that view. By using @Binding, the CustomDatePicker can modify a Date variable that’s stored in the parent view, while the parent view still maintains control over that state. This is especially useful for reusable components like our CustomDatePicker.
 */
import SwiftUI

struct DateViewPicker: View {
    
    @Binding var selectedDate: Date
    var title: String
    var BackgroundColor: Color
    var textColor: Color = .black
    var padding : CGFloat = 10
    var cornerRadius: CGFloat = 6
    
    
    
    var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(textColor)
                    .padding(.bottom, 10)
                
                HStack {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden() // Hide the default DatePicker label
                        .datePickerStyle(CompactDatePickerStyle())
                        .foregroundColor(textColor)
                        .padding(padding)
                        .background(Theme.onPrimaryColor)
                        .cornerRadius(cornerRadius)
                }
            }
        }
}

#Preview {
    DateViewPicker(selectedDate: .constant(Date()), title: "Date Picker", BackgroundColor: .red)
}
