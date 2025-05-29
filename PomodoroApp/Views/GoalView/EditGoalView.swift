//
//  EditGoalView.swift
//  PomodoroApp
//
//  Updated by ChatGPT for Firestore sync - 17.05.2025
//

import SwiftUI
import FirebaseFirestore

struct EditGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var listViewModel: MainViewModel

    @State var goal: Goal
    @State private var title: String
    @State private var dailyMinutes: Int = 5
    @State private var totalSessions: Int
    @State private var tips: [String]
    @State private var selectedColor: String

    init(goal: Goal, isPresented: Binding<Bool>, listViewModel: MainViewModel) {
        _goal = State(initialValue: goal)
        _title = State(initialValue: goal.title)
        _dailyMinutes = State(initialValue: goal.dailyMinutes)
        _totalSessions = State(initialValue: goal.totalSessions)
        _tips = State(initialValue: goal.tips)
        _selectedColor = State(initialValue: goal.colorHex)
        _isPresented = isPresented
        self.listViewModel = listViewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                    Stepper("Daily Minutes: \(dailyMinutes)", value: $dailyMinutes, in: 5...180, step: 5)
                    Stepper("Total Sessions: \(totalSessions)", value: $totalSessions, in: 1...100)
                }

                Section(header: Text("Tips")) {
                    ForEach(0..<tips.count, id: \ .self) { index in
                        TextField("Tip \(index + 1)", text: Binding(
                            get: { tips[index] },
                            set: { tips[index] = $0 }
                        ))
                    }

                    Button("Add Tip") {
                        tips.append("")
                    }
                    .foregroundColor(.blue)
                }

                Section(header: Text("Color")) {
                    ColorPickerSectionView(selectedColor: $selectedColor)
                }

                Button("Save Changes") {
                    updateGoalInFirestore()
                }
               
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func updateGoalInFirestore() {
        let updatedData: [String: Any] = [
            "title": title,
            "dailyMinutes": dailyMinutes,
            "totalSessions": totalSessions,
            "tips": tips,
            "colorHex": selectedColor,
            "createdAt": Timestamp(date: goal.createdAt)
        ]

        Firestore.firestore().collection("goals").document(goal.id).updateData(updatedData) { error in
            if let error = error {
                print("❌ Failed to update goal: \(error.localizedDescription)")
            } else {
                print("✅ Goal updated successfully")
                listViewModel.fetchGoals() // 🔥 Listeyi anında güncelle
                dismiss()
            }
        }
    }
}

#Preview {
    let sampleGoal = Goal(
        id: "sample_id",
        title: "Sample Goal",
        dailyMinutes: 30,
        totalSessions: 5,
        tips: ["Stay focused", "Avoid distractions"],
        colorHex: "#FF6B6B",
        createdAt: Date(),
        completedSessions: 2
    )

    return EditGoalView(goal: sampleGoal, isPresented: .constant(true), listViewModel: MainViewModel())
}
