import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("welcomeview_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(20)

            Text("Let’s get productive!")
                .font(.title2)
                .bold()
                .padding(.top, 8)
                .padding(.bottom, 32)
            
            
            
            // MARK: Google Login Button
            Button(action: {
                guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
                    print("⛔️ RootViewController bulunamadı")
                    return
                }

                AuthService.shared.signInWithGoogle(presenting: rootVC) { result in
                    switch result {
                    case .success(let user):
                        print("✅ Google ile giriş başarılı: \(user.email ?? "")")
                        DispatchQueue.main.async {
                            appState.currentRoute = .main
                        }
                    case .failure(let error):
                        print("❌ Google ile giriş hatası: \(error.localizedDescription)")
                    }
                }
            }) {
                HStack {
                    Image("google_icon")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 20, height: 20)

                    Spacer()

                    Text("Continue with Google")
                        .foregroundColor(.white)
                        .fontWeight(.medium)

                    Spacer()
                }
                .padding()
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            // MARK: Email Signup Button
            Button(action: {
                appState.currentRoute = .signup
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)

                    Spacer()

                    Text("Sign up with Email")
                        .foregroundColor(.white)
                        .fontWeight(.medium)

                    Spacer()
                }
                .padding()
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            // MARK: Already Have Account
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button("Login") {
                    appState.currentRoute = .login
                }
                .fontWeight(.semibold)
            }
            .padding(.top, 12)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
