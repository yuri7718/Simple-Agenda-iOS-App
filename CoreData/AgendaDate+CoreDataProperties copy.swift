//
//  AgendaDate+CoreDataProperties.swift
//  
//
//  Created by Qiang Xu on 2020-07-07.
//
//

import Foundation
import CoreData


extension AgendaDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgendaDate> {
        return NSFetchRequest<AgendaDate>(entityName: "AgendaDate")
    }

    @NSManaged public var agendaDate: Date
    @NSManaged public var hasEvents: NSSet

}

// MARK: Generated accessors for hasEvents
extension AgendaDate {

    @objc(addHasEventsObject:)
    @NSManaged public func addToHasEvents(_ value: AgendaEvent)

    @objc(removeHasEventsObject:)
    @NSManaged public func removeFromHasEvents(_ value: AgendaEvent)

    @objc(addHasEvents:)
    @NSManaged public func addToHasEvents(_ values: NSSet)

    @objc(removeHasEvents:)
    @NSManaged public func removeFromHasEvents(_ values: NSSet)

}
