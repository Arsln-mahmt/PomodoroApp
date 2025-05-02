//
//  CreatedGoalViewModel.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 2.05.2025.
//

import Foundation
import CoreData
import SwiftUI

final class CreatedGoalViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dailyMinutes: Int = 25
    @Published var totalDays: Int = 7
    @Published var showAlert: Bool = false
    @Published var navigateToTimer: Bool = false
    
    var createdGoal: GoalEntity?
    
    func createGoal(in context: NSManagedObjectContext, startImmediately: Bool) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert = true
            return
            
        }
        
        let goal = GoalEntity(context: context)
        goal.title = title
        goal.dailyMinutes = Int16(dailyMinutes)
        goal.totalDays = Int16(totalDays)
        goal.completedMinutes = 0
        goal.createdAt = Date()
        
        do{
            try context.save()
                if startImmediately {
                    createdGoal = goal
                    navigateToTimer = true
                 }
                } catch {
                    print("Error saving \(error.localizedDescription)")
                }
        
    }
    
    
}
