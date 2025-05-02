//
//  OnBoardModel.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 19.04.2025.
//

import Foundation

struct OnBoardModel: Identifiable {
    let id = UUID()
    let imageName: String
    let title : String
    let description : String
    
    static let items: [OnBoardModel] = [
        OnBoardModel(
            imageName: "target", title: "Set Your Focus", description: "Define your daily goals and stay orginized"
        
            ),
        OnBoardModel(
            imageName: "timer", title: "Pomodoro Sessions", description: "Work in focused bursts with built in timers"
            
        ),
        OnBoardModel(
            imageName: "chart.bar", title: "Track Your Progress", description: "Visualize how far you 've come and stay motivated"
            
        )
    ]
}
