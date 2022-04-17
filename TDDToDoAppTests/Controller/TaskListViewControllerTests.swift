//
//  TaskListViewControllerTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 17.04.2022.
//

import XCTest
@testable import TDDToDoApp

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: String(describing: TaskListViewController.self)
        )
        
        sut = vc as? TaskListViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_When_View_Is_Loaded_TavleView_Is_Not_Nil() {
        
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_When_View_Is_Loaded_Data_Provider_Is_Not_Nil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func test_When_View_Is_Loaded_TableView_Delegate_Is_Set() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func test_When_View_Is_Loaded_TableView_DataSource_Is_Set() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func test_When_View_Is_Loaded_TableView_Delegate_Equals_TableView_DataSource() {
        XCTAssertEqual(
            sut.tableView.delegate as? DataProvider,
            sut.tableView.dataSource as? DataProvider
        )
    }
}
