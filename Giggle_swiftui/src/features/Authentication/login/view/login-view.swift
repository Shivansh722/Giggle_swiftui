//
//  login-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 01/11/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVissible: Bool = false
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
                Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
                    .padding(.top, 50)
                    
                
               
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.bottom, 30)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Theme.onPrimaryColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 30 )
                
                HStack {
                    if isPasswordVissible {
                        TextField("Password", text: $password)
                    }
                    else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: {
                        isPasswordVissible.toggle()
                    }) {
                        Image(systemName: isPasswordVissible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(.trailing, 30)
                }
            
            //sign up button laal wali
            Button(action: {
                //sign up action
            }) {
                Text("SIGN UP")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.primaryColor)
                    .foregroundStyle(Theme.onPrimaryColor)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    
            }
            .padding(.top, 20)
            
            //OR WALI DIV
            HStack {
                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                    .padding(.leading, 30)
                
                Text("OR")
                    .foregroundColor(Color.gray)
                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                    .padding(.leading, 30)
                }
            .padding(.vertical, 20)
        }
        
        
    }
}


