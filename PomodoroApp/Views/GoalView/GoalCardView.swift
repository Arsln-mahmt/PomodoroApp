import SwiftUI

struct GoalCardView: View {
    let goal: Goal
    var editAction: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Başlık
            Text(goal.title)
                .font(.headline)
                .foregroundColor(Color(hex: goal.colorHex).contrastingForeground)

            // İlerleme çubuğu
            ProgressView(value: progress)
                .accentColor(Color(hex: goal.colorHex).contrastingForeground)
                .frame(height: 8)
                .clipShape(Capsule())

            // Session bilgisi
            Text("Session \(min(goal.completedSessions + 1, goal.totalSessions))/\(goal.totalSessions)")
                .font(.caption)
            .foregroundColor(Color(hex: goal.colorHex).contrastingForeground.opacity(0.7))
        }
        .padding()
        .background(Color(hex: goal.colorHex))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(1), lineWidth: 1)
        )
        .cornerRadius(12)
        .shadow(radius: 2)
        .contextMenu {
            if let editAction = editAction {
                Button("Edit", action: editAction)
            }
        }
    }
    // İlerleme Çubuğu
    private var progress: Double {
        let completed = Double(goal.completedSessions)
        let total = Double(goal.totalSessions)
        return total == 0 ? 0 : completed / total
    }
}

#Preview {
    GoalCardView(goal: Goal(
        id: "sample-id",
        title: "Study SwiftUI",
        dailyMinutes: 25,
        totalSessions: 5,
        tips: ["Stay focused", "Take breaks"],
        colorHex: "#3498DB",
        createdAt: Date(),
        completedSessions: 2
    ))
}
