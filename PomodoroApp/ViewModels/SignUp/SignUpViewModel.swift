import Foundation
import SwiftUI
import FirebaseAuth

final class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?

    func handleSignUp(onSuccess: @escaping () -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        errorMessage = nil
        print("Ready to sign up with email: \(email)")
        
        AuthService.shared.signUp(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Kayıt başarılı: \(user.email ?? "")")
                onSuccess()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("Firebase hata:", error.localizedDescription)  // ✅ string hata mesajı
                    print("Hata detayı:", (error as NSError).userInfo)
                }
            }
        }
    }
}
