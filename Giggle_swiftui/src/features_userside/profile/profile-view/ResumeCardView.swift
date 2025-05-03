import SwiftUI
struct ResumeCardView: View {
    let ResumeName: String

    var body: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(Theme.primaryColor)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(ResumeName)
                    .foregroundColor(Theme.onPrimaryColor)
            }
        }
        .padding()
        .background(Color(hex: "343434").opacity(0.6))
        .cornerRadius(10)
    }
}
