//
//  AddVolunteerTableViewCell.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/9/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class AddVolunteerTableViewCell: UITableViewCell {

    @IBOutlet weak var volName: UITextField!
    @IBOutlet weak var volTimeBegin: UITextField!
    @IBOutlet weak var volTimeEnd: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        createDatePicker()
        createToolbar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createDatePicker(){
        let beginTimePicker = UIDatePicker()
        let endTimePicker = UIDatePicker()
        beginTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        volTimeBegin.inputView = beginTimePicker
        volTimeEnd.inputView = endTimePicker
        beginTimePicker.addTarget(self, action: #selector(AddVolunteerTableViewCell.beginTimePickerValueChange), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(AddVolunteerTableViewCell.endTimePickerValueChange), for: .valueChanged)
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddVolunteerTableViewCell.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        volTimeBegin.inputAccessoryView = toolbar
        volTimeEnd.inputAccessoryView = toolbar
    }
    
    func beginTimePickerValueChange(sender: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        volTimeBegin.text = timeFormatter.string(from: sender.date)
    }
    
    func endTimePickerValueChange(sender: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        volTimeEnd.text = timeFormatter.string(from: sender.date)
    }
    
    func dismissKeyboard() {
        superview?.endEditing(true)
    }
}
