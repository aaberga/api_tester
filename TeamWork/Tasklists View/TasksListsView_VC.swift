//
//  TasksListsView_VC.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 06/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import UIKit



private let kCellIdentifier = "TasksListTile"


protocol TasksListsView {
    
    func receiveTasksListsData(_ data: [TaskListsData])
}


class TasksListsView_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, TasksListsView {

    // MARK: IBOutlets
    
    @IBOutlet weak var taskslistTable: UITableView!
    
    
    // MARK: Properties
    
    var parentProjectID: Int? = nil
    
    
    // MARK: Friend Interface
    
    func receiveTasksListsData(_ data: [TaskListsData]) {
        
        self.tasklistData = data
        self.taskslistTable.reloadData()
    }


    // MARK: VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewFriend = TasklistsFriend(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.viewFriend = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let projectID = self.parentProjectID {
            self.viewFriend?.tasksListsForProject(projectID: projectID)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tasklistData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        
        let dataInfo = self.tasklistData[indexPath.row]
        if let taskListCell = cell as? SimpleTasksListCell {
            
            taskListCell.data = dataInfo
            taskListCell.prepareForDisplay()
        }

        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chosenTasklistData = self.tasklistData[indexPath.row]
//        DLogWith(message: "chosenTasklistData \(chosenTasklistData.name)")
        
        self.selectedProjectID = chosenTasklistData.id
//        DLogWith(message: "Moving to \(String(describing: self.destinationVC))")
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let rightDestination = segue.destination as? TasksView_VC {
            self.destinationVC = rightDestination
        }
    }
    

    
    // MARK: - Private Properties
    
    private var viewFriend: TasklistsFriend? = nil
    private var tasklistData: [TaskListsData] = []
    private var selectedProjectID: Int = -1
    private var destinationVC: TasksView_VC? = nil

}
