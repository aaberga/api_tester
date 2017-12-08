//
//  TasksListsFriend_Tests.swift
//  TeamWorkTests
//
//  Created by Aldo Bergamini on 07/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import XCTest


@testable import TeamWork




private let targetProjectId = 301444



class TasksListsFriend_Tests: XCTestCase, TasksListsView {
    
    var tlFriend: TasklistsFriend!
    var currentExpectation: XCTestExpectation?

    
    
    override func setUp() {
        super.setUp()

        self.tlFriend = TasklistsFriend(view: self)
    }
    
    override func tearDown() {

        self.tlFriend = nil
        
        super.tearDown()
    }
    
    func test_GetTasklistsForProject() {
        
        let expectation = self.expectation(description: "test_GetTasklistsForProject")
        self.currentExpectation = expectation

        self.tlFriend.tasksListsForProject(projectID: targetProjectId)
        
        
        // *****************
        
        waitForExpectations(timeout: 5) { error in
            
            if let error = error { XCTFail("Failed with timeout error: \(error)") }
        }
    }
    
    
    func receiveTasksListsData(_ data: [TaskListsData]) {
        
//        DLogWith(message: "TaskListsData: \(data)")
        
        XCTAssert(data.count == 9, "Error: received an unexpected number of task lists for selected project \(targetProjectId)")
        
        self.currentExpectation?.fulfill()
    }
}
