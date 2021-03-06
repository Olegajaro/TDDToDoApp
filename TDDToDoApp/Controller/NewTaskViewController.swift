//
//  NewTaskViewController.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 22.04.2022.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    @IBAction func save() {
        let titleString = titleTextField.text
        let locationString = locationTextField.text
        let date = dateFormatter.date(from: dateTextField.text!)
        let addressString = addressTextField.text
        let descriptionString = descriptionTextField.text
        
        geocoder.geocodeAddressString(addressString!) { [unowned self] placemarks, error in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString!,
                                    coordinate: coordinate)
            let task = Task(title: titleString!,
                            description: descriptionString,
                            date: date, location: location)
            
            self.taskManager.add(task: task)
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        
    }
}
