//
//  TaskListModels.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 07/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation
import SwiftyJSON


func TaskListFactory(data: [String: Any]) -> TaskListStore? {
    
    do {
        
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        var json: JSON? = JSON(data: jsonData)
        let restConfig = TaskListStore(json: &json)
        
        return restConfig
        
    } catch {
        
        DLogWith(message: "Error: \(error.localizedDescription)")
    }
    
    return nil
}

class TaskListStore: JSONStore {
    
    var taskslists: [TaskList] {

        get {
            if let projects = self.taskListItems {

                return projects

            } else {

                var projects: [TaskList] = []

                if let projectData = self.readJSON(atPath: "tasklists") {

                    var itemNo = 0
                    for _ in projectData {

                        let currentProjectPath = String(format: "tasklists.%ld", itemNo)
                        let currentProject = TaskList(jsonObject: self, withPath: currentProjectPath)
                        projects.append(currentProject)
                        itemNo = itemNo+1
                    }
                }

                //                DLogWith(message: "TasksLists: \(projects)")

                self.taskListItems = projects
                return projects
            }
        }
    }

    // MARK: Private Properties

    var taskListItems: [TaskList]?
}


class TaskList: JSONElement {

    var id: Int {

        get {
            if let property = self.integerProperty(key: "id") {
                return property
            } else {
                return -1
            }
        }
    }

    var name: String {

        get {
            if let property = self.stringProperty(key: "name") {
                return property
            } else {
                return ""
            }
        }
    }
    
    var listDescription: String {
        
        get {
            if let property = self.stringProperty(key: "description") {
                return property
            } else {
                return ""
            }
        }
    }
 
    var status: String {
        
        get {
            if let property = self.stringProperty(key: "status") {
                return property
            } else {
                return ""
            }
        }
    }

    var project: String {
        
        get {
            if let property = self.stringProperty(key: "project") {
                return property
            } else {
                return ""
            }
        }
    }

    var uncompletedCount: Int {
        
        get {
            if let property = self.integerProperty(key: "uncompleted-count") {
                return property
            } else {
                return -1
            }
        }
    }
}

