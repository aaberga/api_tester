//
//  ProjectsView_VC.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 06/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import UIKit



private let kCellIdentifier = "ProjectTile"


protocol ProjectsView {
    
    func receiveProjectsData(_ data: [ProjectData])
}


class ProjectsView_VC: UITableViewController, ProjectsView {

    // MARK: IBOutlets

    @IBOutlet var projectsTableView: UITableView!
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewFriend = ProjectsFriend(view:self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.viewFriend = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.viewFriend?.listProjects()
        
    }

    // MARK: Friend Interface
    
    func receiveProjectsData(_ data: [ProjectData]) {
        
        self.projectData = data
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)

        let dataInfo = self.projectData[indexPath.row]
        if let projectCell = cell as? SimpleProjectCell {
            
            projectCell.data = dataInfo
            projectCell.prepareForDisplay()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chosenProjectData = self.projectData[indexPath.row]
        
        self.selectedProjectID = chosenProjectData.id
        self.destinationVC?.parentProjectID = self.selectedProjectID
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let rightDestination = segue.destination as? TasksListsView_VC {
            self.destinationVC = rightDestination
        }
    }

    
    // MARK: - Private Properties

    private var viewFriend: ProjectsFriend? = nil
    private var projectData: [ProjectData] = []
    private var selectedProjectID: Int = -1
    private var destinationVC: TasksListsView_VC? = nil
}
