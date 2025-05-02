//
//  OnBoardVievModel.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 19.04.2025.
//

import SwiftUI

final class OnBoardViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var isHomeRedirect: Bool = false
    
    private let userDefaultsKey = "hasSeenOnboarding"
    
    init(){
        checkUserFirstTime()
    }
    
    func checkUserFirstTime(){
        let hasSeen = UserDefaults.standard.bool(forKey: userDefaultsKey)
        if hasSeen{
            isHomeRedirect = true
        }
    }
    
    func saveUserLoginAndRedirect(){
        UserDefaults.standard.set(true, forKey: userDefaultsKey)
        isHomeRedirect = true
    }
    
    func totalPages() -> Int {
        OnBoardModel.items.count - 1
    }
}
