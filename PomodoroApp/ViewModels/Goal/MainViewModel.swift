//
//  MainViewModel.swift
//  PomodoroApp
//
//  Updated by ChatGPT - 17.05.2025
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class MainViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    


    func fetchGoals() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⛔️ User not logged in")
            return
        }

        Firestore.firestore()
            .collection("goals")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("⛔️ Error fetching goals: \(error.localizedDescription)")
                    return
                }

                self.goals = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let title = data["title"] as? String,
                        let dailyMinutes = data["dailyMinutes"] as? Int,
                        let totalSessions = data["totalSessions"] as? Int,
                        let tips = data["tips"] as? [String],
                        let colorHex = data["colorHex"] as? String,
                        let timestamp = data["createdAt"] as? Timestamp
                    else { return nil }

                    let completedSessions = data["completedSessions"] as? Int ?? 0

                    return Goal(
                        id: doc.documentID,
                        title: title,
                        dailyMinutes: dailyMinutes,
                        totalSessions: totalSessions,
                        tips: tips,
                        colorHex: colorHex,
                        createdAt: timestamp.dateValue(),
                        completedSessions: completedSessions
                    )
                } ?? []
            }
    }

    func deleteGoal(_ goal: Goal) {
        guard !goal.id.isEmpty else {
            print("⚠️ Hedef goal id boş, silinemiyor.")
            return
        }

        print("🧩 Siliniyor: \(goal.title) → ID: \(goal.id)")

        Firestore.firestore()
            .collection("goals")
            .document(goal.id)
            .delete { error in
                if let error = error {
                    print("❌ Firestore'dan silinemedi: \(error.localizedDescription)")
                } else {
                    print("✅ Firestore'dan silindi: \(goal.id)")
                    self.fetchGoals()
                }
            }
    }
}
