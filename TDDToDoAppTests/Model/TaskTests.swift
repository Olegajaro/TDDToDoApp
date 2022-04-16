//
//  TaskTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 16.04.2022.
//

import XCTest
@testable import TDDToDoApp

class TaskTests: XCTestCase {

    func test_Init_Task_With_Title() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
    
    func test_Init_Task_With_Title_And_Description() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    
    func test_When_Given_Title_Sets_Title() {
        let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    
    func test_When_Given_Description_Sets_Description() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertEqual(task.description, "Bar")
    }
    
    func test_Task_Inits_WithDate() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task.date)
    }
}
