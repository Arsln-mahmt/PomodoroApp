//
//  NormalButton.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 19.04.2025.
//

import SwiftUI

struct NormalButton: View {
    var onTap: () -> Void
    var title: String
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

#Preview {
    NormalButton(onTap: {} , title: "Button")
}
