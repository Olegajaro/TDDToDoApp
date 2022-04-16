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
    private(set) var date: Date?
    
    init(title: String, description: String? = nil, location: Location? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.date = Date()
    }
}
