//
//  CreatedGoalViewModelTests.swift
//  PomodoroAppTests
//
//  Created by Mahmut Arslan on 10.05.2025.
//

import Foundation
import XCTest
@testable import PomodoroApp
import CoreData

final class CreateGoalViewModelTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    @MainActor override func setUp(){
        super.setUp()
        context = PersistenceController.preview.container.viewContext
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
     func testCreateGoal_withEmptyTitle_showsAlert() {
        let viewModel = CreatedGoalViewModel()
        viewModel.title = "" // boş başlık
        viewModel.createGoal(in: context, startImmediately: false)
        
        XCTAssertTrue(viewModel.showAlert, "Boş başlık verildiğinde showAlert true olmalı")
    }
    
    func testCreateGoal_withValidTitle_createsGoal() {
        let viewModel = CreatedGoalViewModel()
        viewModel.title = "Test Goal"
        viewModel.dailyMinutes = 30
        viewModel.totalSession = 5
        
        viewModel.createGoal(in: context, startImmediately: false)
        
        let request: NSFetchRequest<GoalEntity> = GoalEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "Test Goal")
        
        let results = try? context.fetch(request)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 1, "Veri tabanında 1 adet hedef olmalı")
    }

        func testCreateGoal_withStartImmediately_setsNavigation() {
        let viewModel = CreatedGoalViewModel()
        viewModel.title = "Another Goal"
        viewModel.dailyMinutes = 45
        viewModel.totalSession = 3
        
        viewModel.createGoal(in: context, startImmediately: true)
        
        XCTAssertNotNil(viewModel.createdGoal, "createdGoal atanmalı")
        XCTAssertTrue(viewModel.navigateToTimer, "navigateToTimer true olmalı")
    }


}
