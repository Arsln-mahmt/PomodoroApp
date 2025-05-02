import SwiftUI
import CoreData

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    init(goal: GoalEntity, context: NSManagedObjectContext) {
        self.viewModel = TimerViewModel(
            remainingSecond: 150, // test için düşük değer vermişsin, istersen 1500 yap
            isRunning: false,
            cancallable: nil,
            goal: goal,
            viewContext: context
        )
    }
    
    var body: some View {
            VStack(spacing: 40) {
                // Başlık
                Text(viewModel.goal.title ?? "Focus Session")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                // Zaman ve daire
                ZStack {
                    Circle()
                        .stroke(lineWidth: 16)
                        .opacity(0.2)
                        .foregroundColor(.gray)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(viewModel.progress))
                        .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
                        .foregroundColor(viewModel.isRunning ? .green : .blue)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.2), value: viewModel.progress)

                    Text(viewModel.timeString())
                        .font(.system(size: 44, weight: .bold, design: .monospaced))
                }
                .frame(width: 220, height: 220)
                .padding(.bottom, 8)

                // Butonlar
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.isRunning ? viewModel.pause() : viewModel.start()
                    }) {
                        Label(viewModel.isRunning ? "Pause" : "Start",
                              systemImage: viewModel.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isRunning ? Color.orange : Color.green)
                            .cornerRadius(12)
                    }

                    Button("Reset") {
                        viewModel.reset()
                    }
                    .font(.title3)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let goal = GoalEntity(context: context)
    goal.title = "Test Goal"
    goal.targetMinutes = 100
    goal.completedMinutes = 25
    
    return TimerView(goal: goal, context: context)
}

