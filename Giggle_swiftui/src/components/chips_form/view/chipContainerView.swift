import SwiftUI

struct ChipContainerView: View {
    @ObservedObject var viewModel: PreferenceViewModel

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 10) {
                ForEach(getRows(geometry: geo).enumerated().map { RowWrapper(index: $0.offset, row: $0.element) }) { rowWrapper in
                    HStack(alignment: .center, spacing: 5) {
                        ForEach(rowWrapper.row) { item in
                            PreferenceView(title: item.title, isSelected: Binding(
                                get: { item.isSelected },
                                set: { newValue in
                                    if let index = viewModel.PreferenceArray.firstIndex(where: { $0.id == item.id }) {
                                        viewModel.PreferenceArray[index].isSelected = newValue
                                    }
                                }
                            ))
                        }
                    }
                    .frame(width: geo.size.width, alignment: .center) // Centers the row
                }
            }
        }
    }
    
    private func getRows(geometry: GeometryProxy) -> [[PreferenceViewModel.PreferenceModel]] {
        var rows: [[PreferenceViewModel.PreferenceModel]] = []
        var currentRow: [PreferenceViewModel.PreferenceModel] = []
        var rowWidth: CGFloat = 0
        let padding: CGFloat = 5
        let maxWidth = geometry.size.width - 40 // Adjust according to your need
        
        for item in viewModel.PreferenceArray {
            var itemWidth = textWidth(for: item.title)
            if currentRow.count > 1 {
                itemWidth += padding
            }
            if rowWidth + itemWidth > maxWidth {
                rows.append(currentRow)
                currentRow = [item]
                rowWidth = itemWidth
            } else {
                currentRow.append(item)
                rowWidth += itemWidth
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        return rows
    }
    
    private func textWidth(for text: String) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 30 // Horizontal padding inside the chip
    }
}

struct RowWrapper: Identifiable {
    let id = UUID()
    let index: Int
    let row: [PreferenceViewModel.PreferenceModel]
}
