import SwiftUI

struct CreatedGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreatedGoalViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Title")) {
                    TextField("Enter your goal", text: $viewModel.title)
                }

                Section(header: Text("Time Settings")) {
                    Stepper("Daily: \(viewModel.dailyMinutes) min", value: $viewModel.dailyMinutes, in: 5...180, step: 5)
                    Stepper("Total: \(viewModel.totalDays) days", value: $viewModel.totalDays, in: 1...90)
                }

                Section {
                    Button("Create Only") {
                        viewModel.createGoal(in: viewContext, startImmediately: false)
                        dismiss()
                    }

                    Button("Create & Start") {
                        viewModel.createGoal(in: viewContext, startImmediately: true)
                    }
                    .foregroundColor(.green)
                }
            }
            .navigationTitle("New Goal")
            .alert("Please enter a goal title.", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            }
            .navigationDestination(isPresented: $viewModel.navigateToTimer) {
                if let goal = viewModel.createdGoal {
                    TimerView(goal: goal, context: viewContext)
                }
            }
        }
    }
}
#Preview {
    let context = PersistenceController.preview.container.viewContext
    return CreatedGoalView()
        .environment(\.managedObjectContext, context)
}
