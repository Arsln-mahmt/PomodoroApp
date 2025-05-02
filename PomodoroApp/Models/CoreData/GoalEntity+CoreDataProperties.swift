//
//  GoalEntity+CoreDataProperties.swift
//  PomodoroApp
//
//  Created by Mahmut Arslan on 18.04.2025.
//
//

import Foundation
import CoreData


extension GoalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalEntity> {
        return NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var targetMinutes: Int64
    @NSManaged public var completedMinutes: Int64
    @NSManaged public var createdAt: Date?
    @NSManaged public var dailyMinutes: Int16
    @NSManaged public var totalDays: Int16
}

extension GoalEntity : Identifiable {

}
