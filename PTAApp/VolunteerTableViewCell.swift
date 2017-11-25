//
//  VolunteerTableViewCell.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/30/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class VolunteerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBAction func selectBtn(_ sender: Any) {
        nameTxt.text = currentMember.firstName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if currentMember.firstName == "" {
            selectBtn.isHidden = true
            nameTxt.placeholder = "Type name here..."
        }
        else {
            selectBtn.isHidden = false
            nameTxt.placeholder = "Click Select to choose"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
