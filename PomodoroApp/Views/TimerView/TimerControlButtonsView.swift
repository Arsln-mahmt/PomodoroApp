import SwiftUI

struct TimerControlButtonsView: View {
    let isRunning: Bool
    let isCompleted: Bool
    let shouldHideStartButton: Bool

    let onStartPause: () -> Void
    let onReset: () -> Void

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 16) {
                if !isCompleted && !shouldHideStartButton {
                    Button(action: onStartPause) {
                        Label(isRunning ? "Pause" : "Start",
                              systemImage: isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width * 0.65) // Start butonu geniş
                            .background(isRunning ? Color.orange : Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.leading, -40)
                }

                Button("Reset") {
                    if !isCompleted && !shouldHideStartButton {
                        onReset()
                    }
                }
                .font(.title3)
                .foregroundColor(.white)
                .padding()
                .frame(width: geometry.size.width * 0.25) // Reset daha dar
                .background(isCompleted || shouldHideStartButton ? Color.gray : Color.red)
                .cornerRadius(12)
                .disabled(isCompleted || shouldHideStartButton)
            }
            .frame(width: geometry.size.width)
            .padding(.horizontal)
        }
        .frame(height: 60) // Buton yüksekliği
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TimerControlButtonsView(
        isRunning: false,
        isCompleted: false,
        shouldHideStartButton: false,
       
        onStartPause: {
            print("Start or Pause tapped")
        },
        onReset: {
            print("Reset tapped")
        }
    )
    .padding()
}
