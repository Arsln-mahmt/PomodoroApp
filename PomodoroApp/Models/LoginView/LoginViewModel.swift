//
//  LoginViewModel.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 21.04.2025.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    func login() {
        if email.lowercased( ) == "admin@admin.com" && password == "123456" {
            isAuthenticated = true
        }else {
            errorMessage = "Email or password is incorrect"
        }
    }
}
