import SwiftUI

struct TimerProgressView: View {
    var progress: Double
    var timeText: String
    var progressColor: Color
    var trackColor: Color
    var timeTextColor: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    trackColor,
                    lineWidth: 20)
                .opacity(0.2)
                .foregroundColor(progressColor)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: progress)

            Text(timeText)
                .font(.system(size: 44, weight: .bold, design: .monospaced))
                .foregroundColor(timeTextColor)
        }
        .frame(width: 220, height: 220)
    }
}

#Preview {
    TimerProgressView(progress: 0.6, timeText: "05:00", progressColor: Color.blue, trackColor: Color.accentColor, timeTextColor: .black)
}
