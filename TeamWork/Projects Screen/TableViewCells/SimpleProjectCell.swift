//
//  SimpleProjectCell.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 06/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import UIKit

class SimpleProjectCell: UITableViewCell {

    // MARK: Properties

    var data: ProjectData?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var projectIcon: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    
    // MARK: Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.data = nil
    }

    func prepareForDisplay() {

        if let image = self.data?.icon {
            self.projectIcon.image = image
        }
        self.projectName.text = self.data?.name
    }
}
