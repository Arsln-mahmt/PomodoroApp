import Foundation
import Combine
import SwiftUI
import AudioToolbox
import FirebaseFirestore

final class TimerViewModel: ObservableObject {
    @Published var remainingSecond: Int
    @Published var isRunning: Bool = false
    @Published var isCompleted: Bool = false
    @Published var showSessionComplete = false
    @Published var showFinalComplete = false
    @Published var currentSession: Int = 0
    @Published var shouldHideStartButtonAfterCompletion = false
    @Published var manuallyMarkedComplete: Bool = false

    


    public let goal: Goal
    private let startingSeconds: Int
    private var cancellable: AnyCancellable?
    private var backgroundEnteredAt: Date?
    private var notificationAlreadySent: Bool = false
    private var sessionAlreadyCompleted: Bool = false
    

    var isLastSessionCompleted: Bool {
        return currentSession >= goal.totalSessions
    }
    
    var isGoalCompleted: Bool {
        goal.completedSessions >= goal.totalSessions
    }
    
   


    
 


    init(goal: Goal, isTestMode: Bool = false) {
        self.goal = goal
        self.startingSeconds = isTestMode ? 5 : goal.dailyMinutes * 60
        self.remainingSecond = TimerCache.shared.load(for: goal.id) ?? startingSeconds
        self.currentSession = goal.completedSessions
        self.isCompleted = goal.completedSessions >= goal.totalSessions
        self.shouldHideStartButtonAfterCompletion = self.isCompleted
    }


    func startTimer() {
        guard !isRunning else { return }

        if remainingSecond <= 0 {
            remainingSecond = startingSeconds
        }

        isRunning = true
        backgroundEnteredAt = nil

        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.remainingSecond > 0 {
                    self.remainingSecond -= 1
                } else {
                    self.timerCompleted()
                }
            }
    }

    func pauseTimer() {
        isRunning = false
        cancellable?.cancel()
    }

    func resetTimer() {
        pauseTimer()
        remainingSecond = startingSeconds  // Her durumda sıfırla

        isCompleted = false
        sessionAlreadyCompleted = false
        notificationAlreadySent = false
    }


    func timerCompleted() {
        guard !sessionAlreadyCompleted else { return }

        isRunning = false
        isCompleted = true
        sessionAlreadyCompleted = true

        if !notificationAlreadySent {
            sendCompletionNotification()
            notificationAlreadySent = true
        }

        if currentSession + 1 >= goal.totalSessions {
            incrementCompletedSessions()
            showFinalComplete = true
            shouldHideStartButtonAfterCompletion = true
        } else {
            showSessionComplete = true
        }
    }


    func sendCompletionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🎯 Session Complete!"
        content.body = "You’ve successfully completed a Pomodoro session."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled")
            }
        }
    }

    func handleBackgroundEntry() {
        if isRunning {
            backgroundEnteredAt = Date()
        }
    }

    func handleForegroundEntry() {
        if let backgroundTime = backgroundEnteredAt {
            let elapsed = Int(Date().timeIntervalSince(backgroundTime))
            remainingSecond -= elapsed
            if remainingSecond <= 0 {
                timerCompleted()
            }
        }
        backgroundEnteredAt = nil
    }

    func prepareNextSession() {
        if currentSession + 1 >= goal.totalSessions {
            incrementCompletedSessions()
            showFinalComplete = true
        } else {
            incrementCompletedSessions()
            currentSession += 1
            remainingSecond = startingSeconds
            isCompleted = false
            sessionAlreadyCompleted = false
            notificationAlreadySent = false
        }
    }


    func incrementCompletedSessions() {
        print("🔁 completedSessions güncelleniyor → goalID: \(self.goal.id)")

        guard !goal.id.isEmpty else {
            print("⚠️ Goal ID boş, güncelleme yapılmadı")
            return
        }

        let goalRef = Firestore.firestore().collection("goals").document(self.goal.id)

        goalRef.getDocument { snapshot, error in
            if let error = error {
                print("❌ Belge alınamadı: \(error.localizedDescription)")
                return
            }

            guard snapshot?.exists == true else {
                print("❌ Belge mevcut değil.")
                return
            }

            goalRef.updateData([
                "completedSessions": FieldValue.increment(Int64(1))
            ]) { error in
                if let error = error {
                    print("❌ Firestore güncelleme hatası: \(error.localizedDescription)")
                } else {
                    print("✅ completedSessions başarıyla artırıldı → \(self.goal.id)")
                    NotificationCenter.default.post(name: .goalSessionUpdated, object: nil)
                }
            }
        }
    }

}
