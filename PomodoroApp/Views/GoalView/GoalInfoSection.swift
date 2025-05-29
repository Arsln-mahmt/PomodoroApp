//
//  GoalInfoSection.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 15.05.2025.
//

import SwiftUI

struct GoalInfoSectionView: View {
    @Binding var title: String
    @Binding var dailyMinutes: Int 
    @Binding var totalSessions: Int

    var body: some View {
        Section(header: Text("Goal Info")) {
            TextField("Title", text: $title)
            Stepper("Daily: \(dailyMinutes) min", value: $dailyMinutes, in: 1...180, step: 5)
            Stepper("Total: \(totalSessions) sessions", value: $totalSessions, in: 1...90)
        }
    }
}
#Preview(traits: .sizeThatFitsLayout) {
    GoalInfoSectionView(
        title: .constant("Read Book"),
        dailyMinutes: .constant(25),
        totalSessions: .constant(5)
    )
    
    .padding()
}


