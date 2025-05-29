import SwiftUI

struct CreateGoalView: View {
    @StateObject private var viewModel = CreatedGoalViewModel()

    @Binding var navigationGoal: Goal?
    @Binding var isPresented: Bool
    var listViewModel: MainViewModel

    @State private var showTimer: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                // 🔹 Bölünmüş hazır alt bileşenler
                GoalInfoSectionView(
                    title: $viewModel.title,
                    dailyMinutes: $viewModel.dailyMinutes,
                    totalSessions: $viewModel.totalSession
                )

                TipsSectionView(tips: $viewModel.tips)

                ColorPickerSectionView(selectedColor: $viewModel.selectedColor)

                // 🔹 Butonlar
                Section {
                 Button("Create Goal") {
                        viewModel.createGoal(startImmediately: false)
                    }
                }
            }
            .navigationTitle("Create Goal")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Oops"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: viewModel.goalCreated) { created in
                if created {
                    isPresented = false
                }
            }
            .sheet(isPresented: $showTimer) {
                TimerView(
                    goal: Goal(
                        id: UUID().uuidString,
                        title: viewModel.title,
                        dailyMinutes: viewModel.dailyMinutes,
                        totalSessions: viewModel.totalSession,
                        tips: viewModel.tips,
                        colorHex: viewModel.selectedColor,
                        createdAt: Date(),
                        completedSessions: 0
                    )
                )

            }
        }
    }
}

#Preview {
    CreateGoalView(
        navigationGoal: .constant(nil),
        isPresented: .constant(true),
        listViewModel: MainViewModel()
    )
}
