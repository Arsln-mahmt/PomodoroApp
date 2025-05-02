import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var currentRoute: Route = .splash

    enum Route {
        case splash
        case onboarding
        case welcome
    }

    func markOnboardingSeen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        currentRoute = .welcome
    }

    init() {
        let seen = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.currentRoute = seen ? .welcome : .splash
    }
}
