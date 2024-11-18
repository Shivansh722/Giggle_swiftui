import SwiftUI

struct PreferenceView: View {
    let title: String
    @Binding var isSelected: Bool

    var body: some View {
        Text(title)
            .font(.body)
            .lineLimit(1)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .foregroundColor(isSelected ? .white : .black)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(isSelected ? Color.red : Color.yellow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.white, lineWidth: isSelected ? 0 : 1)
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

//https://github.com/manish-chaurasiya-23/CustomChipViewSwiftUI
