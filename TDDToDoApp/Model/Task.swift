//
//  Task.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 16.04.2022.
//

import Foundation

struct Task {
    let title: String
    let description: String?
    let location: Location?
    let date: Date
    
    init(title: String, description: String? = nil, location: Location? = nil, date: Date? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.date = date ?? Date()
    }
}

extension Task: Equatable {
    static func ==(lhs: Task, rhs: Task) -> Bool {
        if
            lhs.title == rhs.title,
            lhs.description == rhs.description,
            lhs.location == rhs.location {
            return true
        }
        
        return false
    }
}
