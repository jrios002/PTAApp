//
//  AddEventViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/9/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    var event: Event = Event()
    let menuList = ["Home", "Select School", "Log Out"]
    var isUpdatingEvent: Bool = false

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var timeBegin: UITextField!
    @IBOutlet weak var timeEnd: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var descText: UITextView!
    let menuLauncher: MenuLauncher = MenuLauncher()
    
    @IBAction func menuBar(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindFromAddEvent", sender: self)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        event.name = name.text
        event.date = date.text
        event.beginTime = timeBegin.text
        event.endTime = timeEnd.text
        event.location = location.text
        event.description = descText.text
        performSegue(withIdentifier: "segueToAddVolunteers", sender: self)
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUpdatingEvent {
            name.text = event.name
            date.text = event.date
            timeBegin.text = event.beginTime
            timeEnd.text = event.endTime
            location.text = event.location
            descText.text = event.description
        }
        createDatePicker()
        createToolbar()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func createDatePicker(){
        let datePicker = UIDatePicker()
        let beginTimePicker = UIDatePicker()
        let endTimePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        beginTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        date.inputView = datePicker
        timeBegin.inputView = beginTimePicker
        timeEnd.inputView = endTimePicker
        datePicker.addTarget(self, action: #selector(AddEventViewController.datePickerValueChange), for: .valueChanged)
        beginTimePicker.addTarget(self, action: #selector(AddEventViewController.beginTimePickerValueChange), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(AddEventViewController.endTimePickerValueChange), for: .valueChanged)
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddEventViewController.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        date.inputAccessoryView = toolbar
        timeBegin.inputAccessoryView = toolbar
        timeEnd.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func datePickerValueChange(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        date.text = dateFormatter.string(from: sender.date)
    }
    
    func beginTimePickerValueChange(sender: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        timeBegin.text = timeFormatter.string(from: sender.date)
    }
    
    func endTimePickerValueChange(sender: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        timeEnd.text = timeFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToAddVolunteers" {
            NSLog("segueToAddVolunteers")
            let destination = (segue.destination as? AddEventVolunteersViewController)
            destination?.event = event
            destination?.isUpdating = isUpdatingEvent
        }
        
        NSLog("exiting prepareForSegue")
    }
}
