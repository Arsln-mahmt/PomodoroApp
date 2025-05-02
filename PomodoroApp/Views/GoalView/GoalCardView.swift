//
//  GoalCardView.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 21.04.2025.
//

import SwiftUI

struct GoalCardView: View {
    var goal: GoalEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(goal.title ?? "No title")
                .font(.headline)
            
            Text("Progress: \(goal.completedMinutes)/\(goal.targetMinutes) min")
                .font(.subheadline)
                .foregroundColor(.gray)
            
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let goal = GoalEntity(context: context)
    goal.title = "Learn SwiftUI"
    goal.targetMinutes = 100
    goal.completedMinutes = 40

    return GoalCardView(goal: goal)
        .previewLayout(.sizeThatFits)
        .padding()
}

