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
            .foregroundColor(isSelected ? .white : .white)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(isSelected ? Theme.primaryColor : .clear)  // Transparent when unselected
            )
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Theme.primaryColor, lineWidth: isSelected ? 0 : 1)  // Stroke only when unselected
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}
//https://github.com/manish-chaurasiya-23/CustomChipViewSwiftUI
