//
//  TaskListsFriend.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 07/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation



let kTasksListsAction = "/projects/{projectID}/tasklists.json"
let kProjectID = "projectID"


class TasklistsFriend {
    
    // MARK: Properties
    
    // ---
    
    // MARK: Private Properties
    
    private var tasksListsEP = REST_Endpoint()
    private var myView: TasksListsView?
    
    private var taskslists: TaskListStore?
    private var targetProjectID: Int?
    
    // MARK: Methods
    
    init(view: TasksListsView?) {
        
        self.tasksListsEP.apiConfigName = kTW_API_Config
        myView = view
    }
    
    func setTaskslistsView(view: TasksListsView) {
        
        self.myView = view
    }
    
    func setTargetProkjectID(id: Int) {
        
        self.targetProjectID = id
    }

    func tasksListsForProject(projectID: Int) {
        
        let authToken = Authorization().authTokenFor(apiKey: key)
        let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]
        
        self.tasksListsEP.prepareFor(path: kTasksListsAction, apiCallType: "GET")
        self.tasksListsEP.addHeader(kAuthorizationHeader, required: true)
        self.tasksListsEP.addHeader(kContentTypeHeader, required: true)
        self.targetProjectID = projectID

        let parameters = [kProjectID: projectID]
        
        do {
            
            try self.tasksListsEP.setupCallWith(parameters: parameters, headers: headers)
            self.tasksListsEP.doCallWith(responseHandler: self.receiveTasksLists)
            
        } catch {
            
            let genericError = NSError(domain: kProjectsAction, code: 999, userInfo: ["Error": "Unknown Error!"])
            self.receiveTasksLists(result: nil, error:genericError)
        }
    }
    
    func receiveTasksLists(result: Any?, error: Error?) {
        
        if let error = error {
            
            DLogWith(message: "Error: \(error)")
            return
        }
        
        if let result = result as? [String: Any] {
            
//            DLogWith(message: "TLData: \(result)")
            
            if let tasklistsStore = TaskListFactory(data: result) {
                
                self.taskslists = tasklistsStore
            }
            
            if let taskslists = self.taskslists?.taskslists {
                
                var taskslistsViewData: [TaskListsData] = []
                for currentTaskList in taskslists {
                    
                    let newViewModel = TaskListsData()

                    newViewModel.id = currentTaskList.id
                    newViewModel.name = currentTaskList.name
                    newViewModel.description = currentTaskList.listDescription
                    newViewModel.project = currentTaskList.project
                    newViewModel.status = currentTaskList.status

                    taskslistsViewData.append(newViewModel)
                }
                
                self.displayTasklists(displayData: taskslistsViewData)
                
            } else {
                
                self.displayTasklists(displayData: [])
            }
        }
    }
    
    func displayTasklists(displayData: [TaskListsData]) {
        
        DispatchQueue.main.async {
            self.myView?.receiveTasksListsData(displayData)
        }
    }

}
