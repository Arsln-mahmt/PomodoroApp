//
//  LoginView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 21.04.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 24){
            Spacer()
            
            Text("Welcome Back")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 16){
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
            }
            
            if let error = viewModel.errorMessage{
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Login")
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $viewModel.isAuthenticated){
             MainView()
        }
    }
}

#Preview {
    LoginView()
}

