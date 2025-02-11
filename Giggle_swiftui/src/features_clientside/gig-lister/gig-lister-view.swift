import SwiftUI

struct GigDetailsScreen: View {
    @State private var gigTitle: String = ""
    @State private var city: String = ""
    @State private var minSalary: String = ""
    @State private var maxSalary: String = ""
    @State private var hoursPerWeek: String = ""
    @State private var staffNeeded: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Heading with different colors
            HStack {
                Text("Gig")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
                Text("Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.onPrimaryColor)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            // Form fields
            VStack(alignment: .leading, spacing: 16) {
                // Gig Title
                Text("I want to hire a:")
                    .font(.subheadline)
                    .foregroundColor(Theme.onPrimaryColor)
                TextField("e.g., Software Developer", text: $gigTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .foregroundColor(Theme.onPrimaryColor)
                
                // City
                Text("In the city:")
                    .font(.subheadline)
                    .foregroundColor(Theme.onPrimaryColor)
                TextField("e.g., San Francisco", text: $city)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .foregroundColor(Theme.onPrimaryColor)
                
                // Salary Range
                Text("I will pay a salary between:")
                    .font(.subheadline)
                    .foregroundColor(Theme.onPrimaryColor)
                HStack {
                    TextField("Min", text: $minSalary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(Theme.onPrimaryColor)
                    Text("to")
                        .foregroundColor(Theme.onPrimaryColor)
                    TextField("Max", text: $maxSalary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(Theme.onPrimaryColor)
                }
                
                // Hours Per Week
                Text("Amount of hours required weekly:")
                    .font(.subheadline)
                    .foregroundColor(Theme.onPrimaryColor)
                TextField("e.g., 20", text: $hoursPerWeek)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .foregroundColor(Theme.onPrimaryColor)
                
                // Number of Staff Needed
                Text("Number of staff needed:")
                    .font(.subheadline)
                    .foregroundColor(Theme.onPrimaryColor)
                TextField("e.g., 5", text: $staffNeeded)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .foregroundColor(Theme.onPrimaryColor)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Submit Button
            Button(action: {
                // Handle form submission
                print("Gig Title: \(gigTitle)")
                print("City: \(city)")
                print("Salary Range: \(minSalary) to \(maxSalary)")
                print("Hours Per Week: \(hoursPerWeek)")
                print("Staff Needed: \(staffNeeded)")
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Theme.primaryColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Create Gig", displayMode: .inline)
    }
}

struct GigDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        GigDetailsScreen()
    }
}
