import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GoalEntity.createdAt, ascending: false)],
        animation: .default
    )
    private var goals: FetchedResults<GoalEntity>

    var body: some View {
        NavigationView {
            VStack {
                if goals.isEmpty {
                    VStack(spacing: 12) {
                        Text("No goals yet.")
                            .font(.headline)
                            .foregroundColor(.gray)

                        NavigationLink(destination: CreatedGoalView()) {
                            Text("Create Your First Goal")
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    List {
                        ForEach(goals) { goal in
                            NavigationLink {
                                TimerView(goal: goal, context: viewContext)
                            } label: {
                                GoalCardView(goal: goal)
                            }
                        }
                        .onDelete(perform: deleteGoal)
                    }

                    .listStyle(PlainListStyle())
                }

                Spacer()

                NavigationLink(destination: CreatedGoalView()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Goal")
                    }
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(12)
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
            .navigationTitle("Your Goals")
        }
    }

    private func deleteGoal(at offsets: IndexSet) {
        offsets.map { goals[$0] }.forEach(viewContext.delete)
        try? viewContext.save()
    }
}
#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    // Örnek GoalEntity oluştur
    let exampleGoal = GoalEntity(context: context)
    exampleGoal.title = "Read 30 Pages"
    exampleGoal.targetMinutes = 120
    exampleGoal.completedMinutes = 45
    exampleGoal.createdAt = Date()

    // Veriyi kaydet (önizleme için gerekli değil ama hata çıkmasın diye)
    try? context.save()

    return MainView()
        .environment(\.managedObjectContext, context)
}
