//
//  WelcomeView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 20.04.2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 16){
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Welcome to Pomodoro App")
                .font(.title)
                .bold()
            
            Text("You 've completed the onboarding")
                .foregroundColor(.gray)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeView()
}
