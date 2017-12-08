//
//  ProjectsFriend.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 06/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation
import SwiftyJSON




let kTW_API_Config = "TeamWorkAPI_Lite"
let kProjectsAction = "/projects.json"


class ProjectsFriend {
    
    // MARK: Properties
    
        // ---
    
    // MARK: Private Properties
    
    private var projectsEP = REST_Endpoint()
    private var myView: ProjectsView_VC!

    private var projects: ProjectStore?
    
    // MARK: Methods
    
    init(view: ProjectsView_VC) {
        
        self.projectsEP.apiConfigName = kTW_API_Config
        myView = view
    }
    
    func listProjects() {
        
        let authToken = Authorization().authTokenFor(apiKey: key)
        let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]
        
        self.projectsEP.prepareFor(path: kProjectsAction, apiCallType: "GET")
        self.projectsEP.addHeader(kAuthorizationHeader, required: true)
        self.projectsEP.addHeader(kContentTypeHeader, required: true)
        
        do {
            
            try self.projectsEP.setupCallWith(parameters: nil, headers: headers)
            self.projectsEP.doCallWith(responseHandler: self.receiveProjects)
            
        } catch {
            
            let genericError = NSError(domain: kProjectsAction, code: 999, userInfo: ["Error": "Unknown Error!"])
            self.receiveProjects(result: nil, error:genericError)
        }
    }
    
    func receiveProjects(result: Any?, error: Error?) {
        
        if let error = error {
            
            DLogWith(message: "Error: \(error)")
            return
        }
        
        if let result = result as? [String: Any] {
            
            if let projectsStore = ProjectStoreFactory(data: result) {
                
                self.projects = projectsStore
            }
            
            if let projects = self.projects?.projects {
                
                var projectViewData: [ProjectData] = []
                for currentProject in projects {
                    
                    let newViewModel = ProjectData()
                    newViewModel.id = currentProject.id
                    newViewModel.name = currentProject.name
                    newViewModel.description = currentProject.projectDescription
                    newViewModel.lastChangedOn = currentProject.lastChangedOn

                    projectViewData.append(newViewModel)
                }
                
                self.displayProjects(displayData: projectViewData)

            } else {
                
                self.displayProjects(displayData: [])
            }
        }
    }
    
    func displayProjects(displayData: [ProjectData]) {
        
        DispatchQueue.main.async {
            self.myView.receiveProjectsData(displayData)
        }
    }
}
