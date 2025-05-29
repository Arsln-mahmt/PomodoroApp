import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var showCreateGoal = false
    @State private var selectedGoal: Goal?
    @State private var isNavigating = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.goals.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No goals yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.goals, id: \.id) { goal in
                            GoalCardView(goal: goal)
                                .onTapGesture {
                                    appState.currentRoute = .timer(goal: goal)
                                }
                                .contextMenu {
                                    Button("Edit") {
                                        selectedGoal = goal
                                    }
                                    Button("Delete", role: .destructive) {
                                        viewModel.deleteGoal(goal)
                                    }
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let goalToDelete = viewModel.goals[index]
                                viewModel.deleteGoal(goalToDelete)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }

                    .listStyle(.plain)
                }

                Button(action: {
                    showCreateGoal = true
                }) {
                    Text("New Goal")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 16)
            }
            .sheet(isPresented: $showCreateGoal, onDismiss: {
                viewModel.fetchGoals()
            }) {
                CreateGoalView(
                    navigationGoal: $selectedGoal,
                    isPresented: $showCreateGoal,
                    listViewModel: viewModel
                )
                .environmentObject(appState)
            }
            .sheet(item: $selectedGoal) { goal in
                EditGoalView(goal: goal, isPresented: .constant(true), listViewModel: viewModel)
            }
            .navigationTitle("Goals") // ✅ Başlık
            .navigationBarTitleDisplayMode(.large) // ✅ Büyük başlık görünümü
            .onAppear {
                print("✅ MainView görünür oldu, fetchGoals tetikleniyor")
                viewModel.fetchGoals()
            }

        }
        }
    
}

#Preview {
    MainView()
        .environmentObject(AppState())
}
