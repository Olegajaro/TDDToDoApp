//
//  DataProviderTests.swift
//  TDDToDoAppTests
//
//  Created by Олег Федоров on 18.04.2022.
//

import XCTest
@testable import TDDToDoApp

class DataProviderTests: XCTestCase {

    var sut: DataProvider!
    var tableView: UITableView!
    
    var controller: TaskListViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(
            withIdentifier: String(describing: TaskListViewController.self)
        ) as? TaskListViewController
        
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        sut = nil
        tableView = nil
        controller = nil
        
        try super.tearDownWithError()
    }
    
    func test_Number_Of_Sections_Is_Two() {
        let numberOfSection = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSection, 2)
    }
    
    func test_Number_Of_Rows_In_Section_Zero_Is_Tasks_Count() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_Number_Of_Rows_In_Section_One_Is_Done_Tasks_Count() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.checkTask(atIndex: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(atIndex: 0)
                
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func test_Cell_For_Row_At_Index_Path_Returns_Task_Cell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    func test_Cell_For_Row_At_IndexPath_Dequeues_Cell_From_Table_View() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    
    func test_Cell_For_Row_In_Section_Zero_Calls_Configure() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(
            row: 0, section: 0
        )) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    func test_Cell_For_Row_In_Section_One_Calls_Configure() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        let task = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(atIndex: 0)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(
            at: IndexPath(row: 0, section: 1)
        ) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    func test_Delete_Button_Title_Section_Zero_Shows_Done() {
        let buttonTitle = tableView.delegate?.tableView?(
            tableView,
            titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0,
                                                                section: 0))
        
        XCTAssertEqual(buttonTitle, "Done")
    }
    
    func test_Delete_Button_Title_Section_One_Shows_Undone() {
        let buttonTitle = tableView.delegate?.tableView?(
            tableView,
            titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0,
                                                                section: 1))
        
        XCTAssertEqual(buttonTitle, "Undone")
    }
    
    func test_Checking_Task_Checks_In_Task_Manager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        tableView.dataSource?.tableView?(
            tableView,
            commit: .delete,
            forRowAt: IndexPath(row: 0, section: 0)
        )
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    
    func test_Unchecking_Task_Unchecks_In_Task_Manager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(atIndex: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(
            tableView,
            commit: .delete,
            forRowAt: IndexPath(row: 0, section: 1)
        )
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
}

extension DataProviderTests {
    class MockTableView: UITableView {
        var cellIsDequeued = false
        
        static func mockTableView(
            withDataSource dataSource: UITableViewDataSource
        ) -> MockTableView {
            let mockTableView = MockTableView(
                frame: CGRect(x: 0, y: 0, width: 375, height: 658),
                style: .plain
            )
            mockTableView.dataSource = dataSource
            mockTableView.register(
                MockTaskCell.self,
                forCellReuseIdentifier: String(describing: TaskCell.self)
            )

            return mockTableView
        }
        
        override func dequeueReusableCell(
            withIdentifier identifier: String,
            for indexPath: IndexPath
        ) -> UITableViewCell {
            cellIsDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath)
        }
    }
    
    class MockTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            self.task = task
        }
    }
}
