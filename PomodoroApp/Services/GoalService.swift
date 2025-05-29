import FirebaseFirestore

class GoalService {
    static let shared = GoalService()
    private let db = Firestore.firestore()
    
    func addGoal(title: String, dailyMinutes: Int, totalSessions: Int, tips: [String], colorHex: String, userId: String) {
        let data: [String: Any] = [
            "title": title,
            "dailyMinutes": dailyMinutes,
            "totalSessions": totalSessions,
            "tips": tips,
            "colorHex": colorHex,
            "userId": userId,
            "createdAt": Timestamp()
        ]
        
        db.collection("goals").addDocument(data: data) { error in
            if let error = error {
                print("❌ Goal could not be added: \(error.localizedDescription)")
            } else {
                print("✅ Goal added successfully!")
            }
        }
    }
}
