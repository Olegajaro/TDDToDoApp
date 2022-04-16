//
//  Task.swift
//  TDDToDoApp
//
//  Created by Олег Федоров on 16.04.2022.
//

import Foundation

struct Task {
    var title: String
    var description: String?
    private(set) var date: Date?
    
    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
        self.date = Date()
    }
}
