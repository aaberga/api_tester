//
//  SimpleTasksListCell.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 08/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import UIKit

class SimpleTasksListCell: UITableViewCell {

    // MARK: Properties
    
    var data: TaskListsData?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tasklistName: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var taskListDescription: UILabel!
    @IBOutlet weak var taskListStatus: UILabel!
    
    // MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.data = nil
    }
    
    func prepareForDisplay() {
        
        self.tasklistName.text = self.data?.name
        self.projectName.text = self.data?.project
        self.taskListDescription.text = self.data?.description
        self.taskListStatus.text = self.data?.status
    }
}
