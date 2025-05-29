import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var message: String?
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            Button("Send Reset Email") {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error as NSError? {
                        switch AuthErrorCode(rawValue: error.code) {
                            case .userNotFound:
                                message = "There is no user with this email address."
                            case .invalidEmail:
                                message = "The email address format is invalid."
                            case .tooManyRequests:
                                message = "Too many requests. Please try again later."
                            case .networkError:
                                message = "A network error occurred. Please check your connection."
                            default:
                                message = error.localizedDescription // fallback
                            }
                    } else {
                        message = "📩 A password reset link has been sent to your \(email) adress."
                    }
                    showAlert = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Password Reset"),
                message: Text(message ?? ""),
                dismissButton: .default(Text("OK"), action: {
                    dismiss()
                })
            )
        }
    }
}
