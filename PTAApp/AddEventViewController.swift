//
//  AddEventViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/9/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var addEvent: Event = Event()
    let menuList = ["Home", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    var isUpdatingEvent: Bool = false

    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var timeBegin: UITextField!
    @IBOutlet weak var timeEnd: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    
    @IBAction func menuBar(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindFromAddEvent", sender: self)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if isUpdatingEvent {
            let eventMgr: EventMgr = EventMgr()
            eventMgr.delete(addEvent, school: selectedSchool)
        }
        addEvent.name = name.text
        addEvent.date = date.text
        addEvent.beginTime = timeBegin.text
        addEvent.endTime = timeEnd.text
        addEvent.location = location.text
        addEvent.description = descText.text
        if eventImage.image == #imageLiteral(resourceName: "emptyImage2") {
            addEvent.eventImage = #imageLiteral(resourceName: "noImage")
        }
        else {
            addEvent.eventImage = eventImage.image
        }
        
        performSegue(withIdentifier: "segueToAddVolunteers", sender: self)
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        eventImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectEventImageView)))
        eventImage.isUserInteractionEnabled = true
        if (currentMember.firstName?.isEmpty)! {
            guestBtn.title = "Hello Guest"
        }
        else {
            guestBtn.title = ("Hello " + currentMember.firstName!)
        }
        if isUpdatingEvent {
            titleLabel.text = "Update Event"
            name.text = addEvent.name
            date.text = addEvent.date
            timeBegin.text = addEvent.beginTime
            timeEnd.text = addEvent.endTime
            location.text = addEvent.location
            descText.text = addEvent.description
            if let eventImgUrl = addEvent.eventImgUrl {
                let url = URL(string: eventImgUrl)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.eventImage.image = UIImage(data: data!)
                    })
                }).resume()
            }
        }
        else {
            titleLabel.text = "Add Event"
            eventImage.image = #imageLiteral(resourceName: "emptyImage2")
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
    
    func handleSelectEventImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            eventImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToAddVolunteers" {
            NSLog("segueToAddVolunteers")
            let destination = (segue.destination as? AddEventVolunteersViewController)
            destination?.updateEvent = addEvent
            destination?.isUpdating = isUpdatingEvent
        }
        
        NSLog("exiting prepareForSegue")
    }
}
