import SwiftUI

struct CompletionOverlay: View {
    var title: String
    var message: String
    var buttonTitle: String
    var animationName: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                    

            Text(message)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            CustomPrimaryButton(title: buttonTitle, action: onDismiss)
                .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: 300, minHeight: 250)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        .transition(.scale)
        .zIndex(10) // sadece overlay’in önde olması için eklendi
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        CompletionOverlay(
            title: "🎉 Great Job!",
            message: "You completed a Pomodoro!",
            buttonTitle: "Done",
            animationName: "confetti",
            onDismiss: {}
        )
    }
}
