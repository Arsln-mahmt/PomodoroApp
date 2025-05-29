//
//  SignUpView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 4.05.2025.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var appState : AppState
    @StateObject private var viewModel = SignUpViewModel()
    
    
    var body: some View {
        
        VStack(spacing: 24){
           
            
            HStack {
                Button(action: {
                    appState.currentRoute = .welcome
                }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        
                    Text("Back")
                       
                }
                .foregroundColor(.primary)
            
                Spacer()
            }
           
            
            VStack(spacing: 16){
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                SecureField("Password",text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                SecureField("Confirm Password",text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                CustomPrimaryButton(title: "Sign Up") {
                    viewModel.handleSignUp{
                        appState.currentRoute = .main
                           
                }
            }
                .padding(.top, 24)
            }
            .padding(.bottom, 200)
           
            
          
            Spacer()
    }
        .padding()
   
    }
}

#Preview {
    SignUpView().environmentObject(AppState())
}
