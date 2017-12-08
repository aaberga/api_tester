//
//  ProjectModels.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 06/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation
import SwiftyJSON


func ProjectStoreFactory(data: [String: Any]) -> ProjectStore? {
    
    do {
        
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        var json: JSON? = JSON(data: jsonData)
        let restConfig = ProjectStore(json: &json)
        
        return restConfig
        
    } catch {
        
        DLogWith(message: "Error: \(error.localizedDescription)")
    }
    
    return nil
}

class ProjectStore: JSONStore {
    
    var projects: [Project] {
        
        get {
            
            if let projects = self.projectItems {
                
                return projects
                
            } else {
                
                var projects: [Project] = []
                
                if let projectData = self.readJSON(atPath: "projects") {
                    
                    var itemNo = 0
                    for _ in projectData {
                        
                        let currentProjectPath = String(format: "projects.%ld", itemNo)
                        let currentProject = Project(jsonObject: self, withPath: currentProjectPath)
                        projects.append(currentProject)
                        itemNo = itemNo+1
                    }
                }
                
//                DLogWith(message: "Projects: \(projects)")
                
                self.projectItems = projects
                return projects
            }
        }
    }
    
    // MARK: Private Properties
    
    var projectItems: [Project]?
}


class Project: JSONElement {
    
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
    
    var createdOn: String {
        
        get {
            if let property = self.stringProperty(key: "created-on") {
                return property
            } else {
                return ""
            }
        }
    }
    
    var lastChangedOn: String {
        
        get {
            if let property = self.stringProperty(key: "last-changed-on") {
                return property
            } else {
                return ""
            }
        }
    }

    var logoURL: String {
        
        get {
            if let property = self.stringProperty(key: "logo") {
                return property
            } else {
                return ""
            }
        }
    }

    var projectDescription: String {
        
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

    var startDate: String {
        
        get {
            if let property = self.stringProperty(key: "startDate") {
                return property
            } else {
                return ""
            }
        }
    }

    var endDate: String {
        
        get {
            if let property = self.stringProperty(key: "endDate") {
                return property
            } else {
                return ""
            }
        }
    }
}
