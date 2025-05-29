import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var rotate = false

    var body: some View {
        VStack {
            Spacer()

            Image("Splash_icon")
                .resizable()
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(rotate ? 360 : 0))
                .animation(Animation.linear(duration: 2.5).repeatForever(autoreverses: false), value: rotate)
                .onAppear {
                    rotate = true
                }

            Text("Pomodoro App")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 20)

            Spacer()

            Text("Focus. Build. Win.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                appState.checkRoute()
            }
        }
    }
}

#Preview {
    SplashView().environmentObject(AppState())
}
