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
        
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDetail(withNotification: )),
            name: NSNotification.Name(rawValue: "DidSelectRow"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(
            withIdentifier: String(describing: NewTaskViewController.self)
        ) as? NewTaskViewController {
            viewController.taskManager = dataProvider.taskManager
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    @objc func showDetail(withNotification notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let task = userInfo["task"] as? Task,
            let detailVC = storyboard?.instantiateViewController(
                withIdentifier: String(describing: DetailViewController.self)
            ) as? DetailViewController
        else { fatalError() }
    
        detailVC.task = task
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

