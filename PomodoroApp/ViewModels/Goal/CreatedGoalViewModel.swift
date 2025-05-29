import Foundation
import FirebaseAuth
import FirebaseFirestore

final class CreatedGoalViewModel: ObservableObject {
    @Published var tips: [String] = [""]
    @Published var title: String = ""
    @Published var dailyMinutes: Int = 25
    @Published var totalSession: Int = 7
    @Published var showAlert: Bool = false
    @Published var navigateToTimer: Bool = false
    @Published var errorMessage: String?
    @Published var selectedColor: String = "#3498DB"
    @Published var goalCreated: Bool = false  // 🔥 Entegrasyon için yeni alan

    func createGoal(startImmediately: Bool) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.errorMessage = "Title cannot be empty."
            self.showAlert = true
            return
        }

        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not logged in."
            self.showAlert = true
            return
        }

        let goalData: [String: Any] = [
            "title": self.title,
            "dailyMinutes": self.dailyMinutes,
            "totalSessions": self.totalSession,
            "tips": self.tips,
            "colorHex": self.selectedColor,
            "userId": userId,
            "completedSessions": 0,
            "createdAt": Timestamp()
        ]

        Firestore.firestore().collection("goals").addDocument(data: goalData) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = "Failed to create goal: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    print("✅ Goal added for userID: \(userId)")
                    if startImmediately {
                        self.navigateToTimer = true
                    } else {
                        self.goalCreated = true // 🔥 MainView’e dönebilmek için
                    }
                }
            }
        }
    }
}
