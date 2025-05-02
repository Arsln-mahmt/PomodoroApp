
import SwiftUI

@main
struct PomodoroApp: App {
    @StateObject var appState = AppState()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch appState.currentRoute {
                case .splash:
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                appState.currentRoute = .onboarding
                            }
                        }

                case .onboarding:
                    OnBoardView()
                        .environmentObject(appState)

                case .welcome:
                    WelcomeView()
                        .environmentObject(appState)
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
