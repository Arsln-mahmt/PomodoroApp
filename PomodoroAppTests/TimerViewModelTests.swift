import XCTest
@testable import PomodoroApp
import CoreData

final class TimerViewModelTests: XCTestCase {

    var context: NSManagedObjectContext!

    @MainActor override func setUp() {
        super.setUp()
        context = PersistenceController.preview.container.viewContext
    }

    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func testStart_setsIsRunningTrue() {
        let goal = mockGoal()
        let viewModel = TimerViewModel(goal: goal, viewContext: context, isTestMode: true)

        viewModel.start()
        
        XCTAssertTrue(viewModel.isRunning)
    }
    
     func testPause_setIsRunningFalse() {
         let goal = mockGoal()
         let viewModel = TimerViewModel(goal: goal, viewContext: context, isTestMode: true)
         
         
         viewModel.start()
         viewModel.pause()
         
         XCTAssertFalse(viewModel.isRunning, "Pause sonrası isRunning false olmalı")
    }
    
    func testReset_setsRemainingSecondsCorrectly() {
        let goal = mockGoal()
        let viewModel = TimerViewModel(goal: goal, viewContext: context, isTestMode: true)
        
        viewModel.start()
        viewModel.remainingSecond = 10
        viewModel.reset()
        
        let excepted = Int(goal.dailyMinutes) * 60
        XCTAssertEqual(viewModel.remainingSecond, excepted, "Reset sonrası remainingSecond doğru ayarlanmalı")
    }
    
    func testTick_whenRemainingSecondZero_incrementsCompletedSessions() {
        let goal = mockGoal()
        let viewModel = TimerViewModel(goal: goal, viewContext: context, isTestMode: true)
        
        viewModel.remainingSecond = 1
        viewModel.tick()  // remainingSecond sıfırlanır
        viewModel.tick()  // session() çağrılır
        
        context.refresh(goal, mergeChanges: true)
        
        XCTAssertEqual(goal.completedSessions, 1, "Süre bitince completedSessions artmalı")
    }

    /// MOCK GOAL
    func mockGoal() -> GoalEntity {
        let goal = GoalEntity(context: context)
        goal.id = UUID()
        goal.title = "Test Goal"
        goal.targetMinutes = 100
        goal.dailyMinutes = 25
        goal.totalSessions = 4
        goal.completedSessions = 0
        goal.createdAt = Date()
        return goal
    }
}
