//
//  ViewController.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 16.04.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(
            withIdentifier: String(describing: NewTaskViewController.self)
        ) as? NewTaskViewController {
            present(viewController, animated: true)
        }
    }
    
}

