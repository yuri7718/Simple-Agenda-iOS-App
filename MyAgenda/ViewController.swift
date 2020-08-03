//
//  ViewController.swift
//  MyAgenda
//
//  Created by Qiang Xu on 2020-07-05.
//  Copyright © 2020 Qiang Xu. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class ViewController: UIViewController, FSCalendarDelegate {
        
    @IBOutlet var calendar: FSCalendar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedAgendaDate: AgendaDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        /*
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        let dateStr = formatter.string(from: date)
        */
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00 Z"
        let dateStr = formatter.string(from: date)
        let selectedDate = formatter.date(from: dateStr)

        let datesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaDate")
        datesFetch.predicate = NSPredicate(format: "agendaDate == %@", selectedDate! as NSDate)
        
        var fetchedDates: [AgendaDate]
        do {
            fetchedDates = try context.fetch(datesFetch) as! [AgendaDate]
            if !fetchedDates.isEmpty {
                selectedAgendaDate = fetchedDates[0]
                performSegue(withIdentifier: "showEvent", sender: self)
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEvent" {
            let destination = segue.destination as! EventTitleTableViewController
            
            var events = selectedAgendaDate!.hasEvents.allObjects as! [AgendaEvent]
            events.sort { $0.eventTitle < $1.eventTitle }
            
            destination.eventArray = events
        }
    }

    @IBAction func onClear(_ sender: UIButton) {
        resetAllRecords(in: "AgendaEvent")
        resetAllRecords(in: "AgendaDate")
    }
    
    func resetAllRecords(in entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}

