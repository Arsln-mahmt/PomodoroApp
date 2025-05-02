//
//  SliderCard.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 19.04.2025.
//

import SwiftUI

struct SliderCard: View {
    let model: OnBoardModel
    var imageHeight: CGFloat
    
    var body: some View {
        VStack {
            Image(systemName: model.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: imageHeight)
                .foregroundColor(.black)
            
            Text(model.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(model.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.horizontal)
        }
        .padding(.horizontal)
       
        
    }
}

#Preview {
    SliderCard(model: OnBoardModel(
        imageName: "target",
        title: "Set Your Focus",
        description: "Define your daily goals and stay organized"),
        imageHeight: 200)
}
