//
//  DataProvider.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 17.04.2022.
//

import UIKit

enum Section: Int {
    case todo
    case done
}

class DataProvider: NSObject {
    var taskManager: TaskManager?
}

extension DataProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard
            let section = Section(rawValue: section),
            let taskManager = taskManager
        else { return 0 }
        
        switch section {
        case .todo: return taskManager.tasksCount
        case .done: return taskManager.doneTasksCount
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TaskCell.self),
            for: indexPath
        ) as! TaskCell
        
        return cell
    }
}

extension DataProvider: UITableViewDelegate {
    
}

