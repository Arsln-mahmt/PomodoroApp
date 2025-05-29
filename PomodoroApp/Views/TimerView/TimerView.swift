import SwiftUI

struct TimerView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState

    @State private var showGoalAlreadyCompletedAlert = false
    @StateObject var viewModel: TimerViewModel

    init(goal: Goal, isTestMode: Bool = false) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(goal: goal, isTestMode: isTestMode))
    }

    var body: some View {
        let themeColor = Color(hex: viewModel.goal.colorHex)
        let totalSeconds = viewModel.goal.dailyMinutes * 60
        let progress = 1.0 - Double(viewModel.remainingSecond) / Double(totalSeconds)
        let isWhiteBackground = viewModel.goal.colorHex.uppercased() == "#FFFFFF"
        let timeTextColor: Color = isWhiteBackground ? .black : .white
        let timeAndProgressColor: Color = isWhiteBackground ? .black : .white
        let progressTrackColor: Color = isWhiteBackground ? .gray : Color.white.opacity(0.3)

        NavigationStack {
            ZStack {
                themeColor.ignoresSafeArea()

                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(viewModel.goal.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(themeColor.contrastingForeground)
                        Text("Session \(viewModel.currentSession + 1) / \(viewModel.goal.totalSessions)")
                            .font(.subheadline)
                            .foregroundColor(themeColor.contrastingForeground.opacity(0.7))
                    }
                    Spacer()

                    TimerProgressView(
                        progress: progress,
                        timeText: viewModel.remainingSecond.formattedTime,
                        progressColor: timeAndProgressColor,
                        trackColor: progressTrackColor,
                        timeTextColor: timeTextColor
                    )

                    Spacer()

                    if !viewModel.shouldHideStartButtonAfterCompletion {
                        TimerControlButtonsView(
                            isRunning: viewModel.isRunning,
                            isCompleted: viewModel.isCompleted,
                            shouldHideStartButton: viewModel.shouldHideStartButtonAfterCompletion,
                            onStartPause: {
                                viewModel.isRunning ? viewModel.pauseTimer() : viewModel.startTimer()
                            },
                            onReset: {
                                viewModel.resetTimer()
                            }
                        )
                    }

                    if viewModel.goal.tips.contains(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                        TipsView(tips: viewModel.goal.tips)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 120)
                    }

                    Spacer()
                }
                .padding()

                Spacer()

                if viewModel.isGoalCompleted || viewModel.manuallyMarkedComplete {
                    Button(action: {
                        withAnimation {
                            appState.currentRoute = .main
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back to Goals")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isWhiteBackground ? Color.black.opacity(0.2) : Color.white.opacity(0.2))
                        .foregroundColor(isWhiteBackground ? .black : .white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 350)
                }


                if viewModel.showFinalComplete {
                    CompletionOverlay(
                        title: "🎊 Goal Completed!",
                        message: "You’ve successfully completed all sessions.",
                        buttonTitle: "Done",
                        animationName: "confetti",
                        onDismiss: {
                            viewModel.showFinalComplete = false
                            viewModel.manuallyMarkedComplete = true
                        }
                    )
                    .padding()
                    .transition(.scale)
                    .zIndex(10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            appState.currentRoute = .main
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 17, weight: .medium))
                            Text("Back")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(isWhiteBackground ? .black : .white)
                    }
                }
            })
            .onDisappear {
                TimerCache.shared.save(for: viewModel.goal.id, seconds: viewModel.remainingSecond)
            }
            .onChange(of: scenePhase) {
                if scenePhase == .background {
                    viewModel.handleBackgroundEntry()
                } else if scenePhase == .active {
                    viewModel.handleForegroundEntry()
                }
            }
            .animation(.easeInOut, value: viewModel.showFinalComplete)
            .alert("🎉 Session Complete!", isPresented: $viewModel.showSessionComplete) {
                Button("Done") {
                    viewModel.resetTimer()
                    viewModel.prepareNextSession()
                }
            }
            .alert("This goal is already completed!", isPresented: $showGoalAlreadyCompletedAlert) {
                Button("Done", role: .cancel) { }
            }
        }
    }

    #Preview {
        TimerView(goal: Goal(
            id: "preview",
            title: "Preview Goal",
            dailyMinutes: 25,
            totalSessions: 3,
            tips: ["Take breaks", "Stay focused"],
            colorHex: "#3498DB",
            createdAt: Date(),
            completedSessions: 3
        ))
        .environmentObject(AppState())
    }
}
