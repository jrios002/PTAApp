//
//  AddEventVolunteersViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/9/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class AddEventVolunteersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var event: Event = Event()
    var isUpdating: Bool = false
    var volunteers = [String]()
    var volunteersBeginTime = [String]()
    var volunteersEndTime = [String]()
    var rowBeingEdited: Int = 0
    let menuList = ["Home", "Select School", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    private var currentTextField: UITextField?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func menuBar(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func addSpotBtn(_ sender: Any) {
        volunteers.append("")
        volunteersBeginTime.append("")
        volunteersEndTime.append("")
        tableView.reloadData()
    }
    
    @IBOutlet weak var addEventBtn: UIButton!
    @IBAction func addEventBtn(_ sender: Any) {
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        
        if volunteersBeginTime.contains("") || volunteersEndTime.contains("") {
            let loginAlert = UIAlertController(title: "Unable to add event!!", message: "Please Verify that a begin and end time have been entered!", preferredStyle: UIAlertControllerStyle.alert)
            
            loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            self.present(loginAlert, animated: true, completion: nil)
        }
        else {
            event.volunteers = volunteers
            event.volunteersBeginTime = volunteersBeginTime
            event.volunteersEndTime = volunteersEndTime
            
            let eventMgr: EventMgr = EventMgr()
            if isUpdating {
                let location: Int = Int(event.id!)
                eventMgr.update(event, index: location)
            }
            else {
                eventMgr.create(event)
            }
            
            self.performSegue(withIdentifier: "unwindFromAddEvent", sender: self)
        }
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUpdating {
            addEventBtn.setTitle("Update Event", for: .normal)
            volunteers = event.volunteers!
            volunteersBeginTime = event.volunteersBeginTime!
            volunteersEndTime = event.volunteersEndTime!
        }
        else {
            addEventBtn.setTitle("Add Event", for: .normal)
        }
        tableView.backgroundColor = UIColor.clear
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volunteers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddVolunteerTableViewCell
        cell.backgroundColor = UIColor.clear
        if isUpdating {
            cell.volName.text = volunteers[indexPath.row]
            cell.volTimeBegin.text = volunteersBeginTime[indexPath.row]
            cell.volTimeEnd.text = volunteersEndTime[indexPath.row]
            cell.volName.tag = 1
            cell.volTimeBegin.tag = 2
            cell.volTimeEnd.tag = 3
            cell.volName.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.editingChanged)
            cell.volTimeBegin.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.allEditingEvents)
            cell.volTimeEnd.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.allEditingEvents)
        }
        else {
            cell.volName.tag = 1
            cell.volTimeBegin.tag = 2
            cell.volTimeEnd.tag = 3
            cell.volName.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.editingChanged)
            cell.volTimeBegin.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.allEditingEvents)
            cell.volTimeEnd.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.allEditingEvents)
        }
        
        return cell
    }
    
    func textChange(textField: UITextField) {
        let cellIndexPath = tableView.indexPath(for: textField.superview!.superview! as! UITableViewCell)
        
        let cell = tableView.cellForRow(at: cellIndexPath!) as! AddVolunteerTableViewCell
        let index: Int = (cellIndexPath?.row)!
        switch textField.tag {
        case 1:
            volunteers[index] = cell.volName.text!
        case 2:
            volunteersBeginTime[index] = cell.volTimeBegin.text!
            
        case 3:
            volunteersEndTime[index] = cell.volTimeEnd.text!
        default:
            print("Error in stored cell text values!")
        }
    }
}
