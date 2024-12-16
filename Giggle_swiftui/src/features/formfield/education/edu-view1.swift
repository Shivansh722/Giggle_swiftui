import SwiftUI

struct eduView: View {
    @State private var selectedOption = "No"
    @State private var navigateToeduView2 = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        // Header
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Education")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.primaryColor)
                                    Text("Details")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.onPrimaryColor)
                                }
                                .padding(.leading, geometry.size.width * 0.08)
                            }
                            Spacer()
                        }
                        .padding(.top, geometry.size.height * 0.02)
                        
                        Spacer()
                        
                        // Progress Bar
                        ProgressView(value: 40, total: 100)
                            .accentColor(Theme.primaryColor)
                            .padding(.horizontal, geometry.size.width * 0.08)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 12)
                        
                        // Main Question Text
                        (Text("A")
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(Theme.primaryColor)
                         + Text("re you pursuing your education")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                         + Text("?")
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(Theme.onPrimaryColor))
                        
                        // Picker
                        Picker("Are you pursuing your education?", selection: $selectedOption) {
                            Text("Yes").tag("Yes")
                            Text("No").tag("No")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.top, geometry.size.height * 0.4)
                        .onChange(of: selectedOption) { newValue in
                            if newValue == "Yes" {
                                navigateToeduView2 = true
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // NavigationLink
                    NavigationLink(destination: eduView2(), isActive: $navigateToeduView2) {
                        EmptyView()
                    }
                }
            }
        }
    }
}



#Preview {
    eduView()
}
