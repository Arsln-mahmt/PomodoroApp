import Foundation
import FirebaseAuth

class AppState: ObservableObject {
    @Published var currentRoute: Route = .splash

    init() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.checkRoute()
        }
    }

    enum Route {
        case splash
        case onboarding
        case welcome
        case signup
        case login
        case main
        case timer(goal: Goal)
    }

     func checkRoute() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

        if let _ = Auth.auth().currentUser {
            self.currentRoute = .main
        } else if !hasSeenOnboarding {
            self.currentRoute = .onboarding
        } else {
            self.currentRoute = .welcome
        }
    }

    func markOnboardingSeen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        currentRoute = .welcome
    }
}
