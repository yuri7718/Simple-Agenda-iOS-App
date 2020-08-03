//
//  AddNewEventModal.swift
//  MyAgenda
//
//  Created by Qiang Xu on 2020-07-05.
//  Copyright © 2020 Qiang Xu. All rights reserved.
//

import UIKit
import CoreData

class AddNewEventModal: UIViewController, UITextViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet var date: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var eventTitle: UITextView!
    @IBOutlet var eventDescription: UITextView!
    
    let customColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    
    let titlePlaceholder = "Event Title"
    let descriptionPlaceholder = "Event Description"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDatePicker()
        initTextViews()
    }
    
    // MARK: Initialize date picker
    func initDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddNewEventModal.dateChanged(datePicker:)), for: .valueChanged)
    }
    
    // MARK: Initialize text views
    func initTextViews() {
        let width: CGFloat = 1
        let radius: CGFloat = 8
        
        eventDescription.layer.borderWidth = width
        eventDescription.layer.cornerRadius = radius
        eventDescription.layer.borderColor = customColor.cgColor
        eventDescription.text = descriptionPlaceholder
        eventDescription.textColor = customColor
        eventDescription.delegate = self
        eventDescription.autocorrectionType = .no
        
        eventTitle.layer.borderWidth = width
        eventTitle.layer.cornerRadius = radius
        eventTitle.layer.borderColor = customColor.cgColor
        eventTitle.text = titlePlaceholder
        eventTitle.textColor = customColor
        eventTitle.delegate = self
        eventTitle.autocorrectionType = .no
    }
    
    // MARK: Set date label according to date picker
    @objc func dateChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        date.text = formatter.string(from: datePicker.date)
    }
    
    // MARK: Clear text view when user begins editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == customColor {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.layer.borderColor = customColor.cgColor
       }
    }
    
    // MARK: Set placeholder when text view is empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if eventTitle.text.isEmpty {
            eventTitle.text = titlePlaceholder
            eventTitle.textColor = customColor
        } else if eventDescription.text.isEmpty {
            eventDescription.text = descriptionPlaceholder
            eventDescription.textColor = customColor
        }
    }
    
    // MARK: Action when Add button is clicked
    @IBAction func onAdd(_ sender: UIButton) {
        
        var emptyTitle = false
        var emptyDescription = false
        if eventTitle.textColor == customColor || eventTitle.text.isEmpty {
            eventTitle.layer.borderColor = UIColor.red.cgColor
            emptyTitle = true
        }
        if eventDescription.textColor == customColor || eventDescription.text.isEmpty {
            eventDescription.layer.borderColor = UIColor.red.cgColor
            emptyDescription = true
        }
        if emptyTitle || emptyDescription { return }
        
        addEvent()
        self.dismiss(animated: true, completion: nil)
    }
    
    func addEvent() {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00 Z"
        let dateStr = formatter.string(from: datePicker.date)
        let date = formatter.date(from: dateStr)
        
        let datesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AgendaDate")
        datesFetch.predicate = NSPredicate(format: "agendaDate == %@", date! as NSDate)
        
        var fetchedDates: [AgendaDate]
        var fetchedDate: AgendaDate
        do {
            fetchedDates = try context.fetch(datesFetch) as! [AgendaDate]
            if fetchedDates.count == 0 {
                fetchedDate = AgendaDate(context: context)
                fetchedDate.agendaDate = date!
            } else {
                fetchedDate = fetchedDates[0]
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        let newEvent = AgendaEvent(context: context)
        newEvent.eventTitle = eventTitle.text
        newEvent.eventDescription = eventDescription.text
        newEvent.scheduledOn = fetchedDate
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: Clear description
    @IBAction func onClear(_ sender: UIButton) {
        if eventDescription.textColor != customColor {
            eventDescription.text = nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


