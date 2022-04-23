//
//  NewTaskViewController.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 22.04.2022.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    func save() {
        let titleString = titleTextField.text
        let locationString = locationTextField.text
        let date = dateFormatter.date(from: dateTextField.text!)
        let addressString = addressTextField.text
        let descriptionString = descriptionTextField.text
        
        geocoder.geocodeAddressString(addressString!) { [unowned self] placemarks, error in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString!, coordinate: coordinate)
            let task = Task(title: titleString!,
                            description: descriptionString,
                            location: location,
                            date: date)
            
            self.taskManager.add(task: task)
        }
    }
}
