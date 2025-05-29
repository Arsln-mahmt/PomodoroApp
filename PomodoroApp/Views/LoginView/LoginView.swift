import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = LoginViewModel()

    @State private var isLoading = false
    @State private var loginStatusMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                // Back Button
                HStack {
                    Button(action: {
                        appState.currentRoute = .welcome
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                            Text("Back")
                                .font(.subheadline)
                        }
                        .foregroundColor(.primary)
                    }
                    .padding(.leading)
                    .padding(.top, 16)
                    
                    Spacer()
                }

                Spacer()

                VStack(spacing: 24) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 12)
                        

                    VStack(spacing: 16) {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)

                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    if isLoading {
                        ProgressView()
                        if let status = loginStatusMessage {
                            Text(status)
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }

                    Button(action: {
                        isLoading = true
                        loginStatusMessage = "Logging in..."
                        viewModel.errorMessage = nil

                        AuthService.shared.signIn(email: viewModel.email, password: viewModel.password) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let user):
                                    print("✅ Giriş başarılı: \(user.email ?? "")")
                                    loginStatusMessage = "Login successful"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        appState.currentRoute = .main
                                    }
                                case .failure(let error):
                                    viewModel.errorMessage = error.localizedDescription
                                    loginStatusMessage = nil
                                    isLoading = false
                                }
                            }
                        }
                    }) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 4)
                    }

                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot password?")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                }
               
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 350)
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                MainView()
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AppState())
}
