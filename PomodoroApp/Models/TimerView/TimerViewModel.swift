//
//  TimerViewModel.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 21.04.2025.
//

import Foundation
import Combine
import CoreData

final class TimerViewModel: ObservableObject {
    @Published var remainingSecond: Int = 1500
    @Published var isRunning: Bool = false
    
    private var cancallable: AnyCancellable?
    public let goal: GoalEntity
    private let viewContext: NSManagedObjectContext
    private let startinSeconds: Int
    
    init(remainingSecond: Int, isRunning: Bool, cancallable: AnyCancellable? = nil, goal: GoalEntity, viewContext: NSManagedObjectContext) {
        self.remainingSecond = remainingSecond
        self.isRunning = isRunning
        self.cancallable = cancallable
        self.goal = goal
        self.viewContext = viewContext
    
    }
    
    func start(){
        guard !isRunning else { return }
        isRunning = true
        cancallable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in
                self?.tick()
                
            }
    }
    
    
    
    func pause() {
        isRunning = false
        cancallable?.cancel()
        
    }
    
    func reset() {
        pause()
        remainingSecond = 1500
    }
    
    private func tick() {
        if remainingSecond > 0 {
            remainingSecond -= 1
        }else {
            completeSession()
        }
    }
    
    private func completeSession() {
        pause()
        goal.completedMinutes += 25
        try? viewContext.save()
        
    }
    
    func timeString() -> String {
        let m = remainingSecond / 60
        let s = remainingSecond % 60
        return String(format: "%02d:%02d", m,s)
    }
}
