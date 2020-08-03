//
//  EventDescriptionViewController.swift
//  MyAgenda
//
//  Created by Qiang Xu on 2020-07-07.
//  Copyright © 2020 Qiang Xu. All rights reserved.
//

import UIKit
//import CoreData

class EventDescriptionViewController: UIViewController {

    var tmpEvent: AgendaEvent?
    
    @IBOutlet var eventTitle: UITextView!
    @IBOutlet var eventDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let radius: CGFloat = 8
        
        eventTitle.layer.cornerRadius = radius
        eventDescription.layer.cornerRadius = radius
        
        eventTitle.text = tmpEvent?.eventTitle
        eventDescription.text = tmpEvent?.eventDescription
    }

    @IBAction func longPress(_ sender: Any) {
        let alert = UIAlertController(title: "Modify Event Description", message: "Type new description\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.autoresizesSubviews = true

        let textView = UITextView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadConstraint = NSLayoutConstraint(item: alert.view!, attribute: .leading, relatedBy: .equal, toItem: textView, attribute: .leading, multiplier: 1.0, constant: -8.0)
        let trailConstraint = NSLayoutConstraint(item: alert.view!, attribute: .trailing, relatedBy: .equal, toItem: textView, attribute: .trailing, multiplier: 1.0, constant: 8.0)

        let topConstraint = NSLayoutConstraint(item: alert.view!, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .top, multiplier: 1.0, constant: -64.0)
        let bottomConstraint = NSLayoutConstraint(item: alert.view!, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1.0, constant: 64.0)
        
        alert.view.addSubview(textView)
        NSLayoutConstraint.activate([leadConstraint, trailConstraint, topConstraint, bottomConstraint])
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.updateDescription(description: textView.text)
            self.eventDescription.text = textView.text
        }
        alert.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func updateDescription(description: String) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tmpEvent?.setValue(description, forKey: "eventDescription")
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
