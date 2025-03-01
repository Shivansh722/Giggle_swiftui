import SwiftUI
struct ResumeCardView: View {
    let ResumeName: String
    let ResumeSize: String

    var body: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.red)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(ResumeName)
                    .foregroundColor(Theme.onPrimaryColor)
                Text(ResumeSize)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(hex: "343434").opacity(0.6))
        .cornerRadius(10)
    }
}
