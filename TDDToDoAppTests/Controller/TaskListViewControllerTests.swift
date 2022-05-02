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
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: String(describing: TaskListViewController.self)
        )
        
        sut = vc as? TaskListViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
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
    
    func test_TaskListVC_Has_Add_Bar_Button_With_Self_As_Target() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    private func presentingNewTaskViewController() -> NewTaskViewController {
        guard
            let newTaskButton = sut.navigationItem.rightBarButtonItem,
            let action = newTaskButton.action
        else {
            return NewTaskViewController()
        }
        
        //        UIApplication.shared.keyWindow?.rootViewController = sut
        let keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController = sut
        
        sut.performSelector(onMainThread: action,
                            with: newTaskButton,
                            waitUntilDone: true)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        
        return newTaskViewController
    }
    
    func test_Add_New_Task_Presents_NewTaskViewController() {
        let newTaskVC = presentingNewTaskViewController()
        XCTAssertNotNil(newTaskVC.titleTextField)
    }
    
    func test_Shares_Same_TaskManager_With_NewTaskVC() {
        let newTaskViewController = presentingNewTaskViewController()
        
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    func test_When_View_Appeared_TableView_Reloaded() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func test_Tapping_Cell_Sends_Notification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager?.add(task: task)
        
        expectation(
            forNotification: Notification.Name(rawValue: "DidSelectRow"),
            object: nil
        ) { notification -> Bool in
            
            guard
                let taskFromNotification = notification.userInfo?["task"] as? Task
            else { return false}
            
            return task == taskFromNotification
        }
        
        let tableView = sut.tableView
        tableView?.delegate?.tableView?(
            tableView!,
            didSelectRowAt: IndexPath(row: 0, section: 0)
        )
        waitForExpectations(timeout: 1)
    }
    
    func test_Selected_Cell_Notification_Pushes_DetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        let keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task1)
        sut.dataProvider.taskManager?.add(task: task2)
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "DidSelectRow"),
            object: self,
            userInfo: ["task": task1]
        )
        
        guard
            let detailViewController = mockNavigationController.pushedViewController as? DetailViewController
        else {
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task1)
    }
}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
