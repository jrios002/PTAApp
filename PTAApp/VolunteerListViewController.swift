//
//  VolunteerListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/30/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class VolunteerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var event: Event = Event()
    var oldEvent: Event = Event()
    var volunteers = [String]()
    private var currentTextField: UITextField?
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        let eventMgr: EventMgr = EventMgr()
        eventMgr.update(event, oldEvent, school: selectedSchool)
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            self.performSegue(withIdentifier: "unwindFromVolunteerList", sender: self)
        }
    }
    
    @IBAction func editSpotsBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToEditVolunteerSlots", sender: self)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    @IBAction func deleteBtn(_ sender: Any) {
        myTableView.setEditing(true, animated: true)
    }

    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        oldEvent = event
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VolunteerListViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if (currentMember.firstName?.isEmpty)! {
            guestBtn.title = "Hello Guest"
        }
        else {
            guestBtn.title = ("Hello " + currentMember.firstName!)
        }
        myTableView.backgroundColor = UIColor.clear
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        eventTitle.text = event.name
        myTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event.volunteers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VolunteerTableViewCell
        cell.nameTxt.text = event.volunteers?[indexPath.row]
        cell.timeText.text = ((event.volunteersBeginTime?[indexPath.row])! + " - " + (event.volunteersEndTime?[indexPath.row])!)
        cell.backgroundColor = UIColor.clear
        cell.nameTxt.addTarget(self, action: #selector(textChange(textField:)), for: UIControlEvents.allEvents)
        cell.selectBtn.addTarget(self, action: #selector(selectBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            event.volunteers?.remove(at: indexPath.row)
            event.volunteersBeginTime?.remove(at: indexPath.row)
            event.volunteersEndTime?.remove(at: indexPath.row)
            let eventMgr: EventMgr = EventMgr()
            eventMgr.update(event, oldEvent, school: selectedSchool)
            myTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            myTableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToEditVolunteerSlots" {
            NSLog("segueToEditVolunteerSlots")
            let destination = (segue.destination as? AddEventVolunteersViewController)
            destination?.updateEvent = event
            destination?.isUpdating = true
            destination?.isUpdatingVolunteers = true
        }
        
        NSLog("exiting prepareForSegue")
    }
    
    func textChange(textField: UITextField) {
        let cellIndexPath = myTableView.indexPath(for: textField.superview!.superview! as! UITableViewCell)
        
        let cell = myTableView.cellForRow(at: cellIndexPath!) as! VolunteerTableViewCell
        let index: Int = (cellIndexPath?.row)!
        event.volunteers?[index] = cell.nameTxt.text!
    }
    
    func selectBtnClicked(sender: Any) {
        let cellIndexPath = myTableView.indexPath(for: (sender as AnyObject).superview!?.superview! as! UITableViewCell)
        
        let cell = myTableView.cellForRow(at: cellIndexPath!) as! VolunteerTableViewCell
        let index: Int = (cellIndexPath?.row)!
        event.volunteers?[index] = cell.nameTxt.text!
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
