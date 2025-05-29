//
//  CustomPrimaryButton.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 4.05.2025.
//

import SwiftUI

struct CustomPrimaryButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 5, x:0, y:4)
        }
    }
}

#Preview {
    CustomPrimaryButton(title: "Done", action: {})
        .padding()
}
