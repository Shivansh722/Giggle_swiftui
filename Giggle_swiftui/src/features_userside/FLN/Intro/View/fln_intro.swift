//
//  Untitled.swift
//  Giggle_swiftui
//
//  Created by rjk on 09/03/25.
//

import SwiftUI
import WebKit

// Create a WebView representable
struct WebView: UIViewRepresentable {
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

struct FlnIntroView: View {
    var selectedRole: ChooseViewModel.Role?
    @State private var navigate: Bool = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Replace Image with WebView for GIF
                WebView(url: Bundle.main.url(forResource: "block 2", withExtension: "gif") ?? URL.desktopDirectory)
                    .frame(width: 200, height: 200)
                    .padding(.top, 40)
                
                
                VStack(spacing: 30) {
                    IntroItem(
                        icon: "Pass Fail",
                        text: "Complete 5 questions each from Literacy and Numeracy"
                    )
                    IntroItem(
                        icon: "Clock",
                        text: "You will have 5 minutes to complete each section"
                    )
                    IntroItem(
                        icon: "microphone",
                        text: "Fluency section will be a voice based assessment to check your fluency"
                    )
                    IntroItem(
                        icon: "proctor",
                        text: "You will be monitored throughout the assessment"
                    )
                }
                .padding(.top, 30 )
                
                Spacer()
                
                Button(action: {
                    navigate = true
                    
                    // logic for fetch resume give to gemini and store the question in array
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
                    destination: LiteracyView(),
                    isActive: $navigate
                ) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    FlnIntroView()
}
