//
//  AgendaEvent+CoreDataProperties.swift
//  
//
//  Created by Qiang Xu on 2020-07-07.
//
//

import Foundation
import CoreData


extension AgendaEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgendaEvent> {
        return NSFetchRequest<AgendaEvent>(entityName: "AgendaEvent")
    }

    @NSManaged public var eventDescription: String
    @NSManaged public var eventTitle: String
    @NSManaged public var scheduledOn: AgendaDate

}
