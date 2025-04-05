//
//  FluencyIntroView.swift
//  Giggle_swiftui
//
//  Created by rjk on 22/03/25.
//

//
//  Untitled.swift
//  Giggle_swiftui
//
//  Created by rjk on 09/03/25.
//

import SwiftUI
import WebKit

// Create a WebView representable
struct WebFluencyView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false // Make webview transparent
        webView.backgroundColor = .clear // Set clear background
        webView.scrollView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct FluencyIntroView: View {
    var selectedRole: ChooseViewModel.Role?
    @State private var navigate: Bool = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Fluency")
                        .font(.title)
                        .bold()
                        .foregroundColor(Theme.tertiaryColor)
                        .padding(.top, 40)
                    Spacer()
                }
                .padding(.leading, 20)
                // Replace Image with WebView for GIF
                WebFluencyView(url: Bundle.main.url(forResource: "mic", withExtension: "gif") ?? URL.desktopDirectory)
                    .frame(width: 250, height: 250)
                
                
                VStack(spacing: 30) {
                    IntroItem(
                        icon: "Pass Fail",
                        text: "You will have 10 seconds to complete the fluency test"
                    )
                    IntroItem(
                        icon: "Clock",
                        text: "Your time will start immediately after clicking on the button"
                    )
                    IntroItem(
                        icon: "microphone",
                        text: "You have to speak about yourself as fluent as possible"
                    )
                    IntroItem(
                        icon: "proctor",
                        text: "Our model will determine your fluency based on your voice"
                    )
                }
                
                Spacer()
                
                Button(action: {
                    Task{
                        navigate = true
                    }
                    
                }) {
                    Text("CONTINUE")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .frame(alignment: .center)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .frame(width: 323)
                .background(Color(Theme.primaryColor))
                .cornerRadius(8)
                .padding()
                
                NavigationLink(
                    destination: FluencyView(),
                    isActive: $navigate
                ) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    FluencyIntroView()
}
