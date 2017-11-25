//
//  SchoolListTableViewCell.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/30/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var schoolImage: UIImageView!
    @IBOutlet weak var schoolName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
