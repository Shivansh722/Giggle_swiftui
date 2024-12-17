import SwiftUI

struct HomeView: View {
    @ObservedObject var formManager = FormManager.shared
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top section with Greeting and Profile icon
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hi")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                            
                            Text(formManager.formData.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                            .padding()
                    }
                    Spacer()
                    
                    ZStack {
                        // Image
                        Image("desk")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 1.0, height: geometry.size.height / 2)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 8)
                        
                        // Overlapping Custom Button
                        VStack {
                            Spacer()
                            CustomButton(
                                title: "NEXT",
                                backgroundColor: Theme.primaryColor,
                                action: {
                                    // Add Button Action Here
                                },
                                width: geometry.size.width * 0.5,
                                height: 50
                            )
                            .padding(.top, geometry.size.height * 0.08)
                            .padding(.horizontal, geometry.size.width * 0.18)
                        }
                    }
                    
                    VStack {
                        Text("Recommendations")
                             .font(.system(size: 24))
                             .fontWeight(.bold)
                             .foregroundColor(Theme.onPrimaryColor)
                             .padding(.horizontal, geometry.size.width * -0.45)
                        
                         JobCardView()
                        JobCardView()
                    }
                    .padding(.top, geometry.size.height * -0.6)
                    
                   
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
