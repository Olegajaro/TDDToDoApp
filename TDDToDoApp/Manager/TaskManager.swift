//
//  TaskManager.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 17.04.2022.
//

import Foundation

class TaskManager {
    var tasksCount: Int {
        return tasks.count
    }
    var doneTasksCount: Int {
        return doneTasks.count
    }
    
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []
    
    func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
    
    func checkTask(atIndex index: Int) {
        let task = tasks.remove(at: index)
        doneTasks.append(task)
    }
    
    func uncheckTask(atIndex index: Int) {
        let task = doneTasks.remove(at: index)
        tasks.append(task)
    }
    
    func doneTask(at index: Int) -> Task {
        return doneTasks[index]
    }
    
    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
}
