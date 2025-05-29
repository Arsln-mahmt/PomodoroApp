//
//  PomodoroAppApp.swift
//  PomodoroApp
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct PomodoroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appState = AppState()
   
    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
                            switch appState.currentRoute {
                case .splash:
                    SplashView()
                        .environmentObject(appState)

                case .onboarding:
                    OnBoardView()
                        .environmentObject(appState)

                case .welcome:
                    WelcomeView()
                        .environmentObject(appState)

                case .signup:
                    SignUpView()
                        .environmentObject(appState)

                case .login:
                    LoginView()
                        .environmentObject(appState)

                case .main:
                    MainTabView()
                        .environmentObject(appState)

                case .timer(let goal):
                    TimerView(goal: goal)
                        .environmentObject(appState)
                }
            }
        }
    }


private func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print(" Bildirim izni hatası: \(error.localizedDescription)")
        } else {
            print(" Bildirim izni verildi mi? \(granted)")
        }
    }
}
