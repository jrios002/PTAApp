//
//  SchoolEventListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SchoolEventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    var event: Event = Event()
    var events = [Event]()
    var tableIndexPath: IndexPath?
    var deletedEvent: Bool = false
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    
    @IBAction func guestBtnAction(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    
    @IBAction func deleteEventsBtn(_ sender: Any) {
        eventTableView.setEditing(true, animated: true)
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        if (currentMember.firstName?.isEmpty)! {
            guestBtn.title = "Hello Guest"
        }
        else {
            guestBtn.title = ("Hello " + currentMember.firstName!)
        }
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            self.eventTableView.backgroundColor = UIColor.clear
            self.view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: self.gradientLayer)
            self.schoolName.text = selectedSchool.name
            if self.deletedEvent {
                let eventMgr: EventMgr = EventMgr()
                eventMgr.delete(self.events[(self.tableIndexPath?.row)!], school: selectedSchool)
                self.events.remove(at: (self.tableIndexPath?.row)!)
                self.eventTableView.deleteRows(at: [self.tableIndexPath!], with: UITableViewRowAnimation.fade)
            }
            self.deletedEvent = false
            self.fetchEvents()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        if menuShowing {
            menuLauncher.showMenu(menuList: menuList)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventListTableViewCell
        let event: Event = events[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.eventName.text = event.name
        cell.eventImage.image = event.eventImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.event = events[indexPath.row]
        self.tableIndexPath = indexPath
        performSegue(withIdentifier: "segueToEventDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let eventMgr: EventMgr = EventMgr()
            eventMgr.delete(events[indexPath.row], school: selectedSchool)
            events.remove(at: indexPath.row)
            eventTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            eventTableView.setEditing(false, animated: true)
            self.fetchEvents()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToEventDetails" {
            NSLog("segueToEventDetails")
            let destination = (segue.destination as? EventDetailsViewController)
            destination?.event = event
        }
        
        NSLog("exiting prepareForSegue")
    }
    
    func fetchEvents(){
        self.events.removeAll()
        var eventRef: FIRDatabaseReference!
        let schoolNameChild: String = (selectedSchool.name?.lowercased())!
        
        eventRef = FIRDatabase.database().reference().child("schoolList").child(schoolNameChild + selectedSchool.zipCode!).child("EventsList")
        eventRef?.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value is NSNull {
                let tableLoadAlert = UIAlertController(title: "No Events to display", message: "No Events retreived from database!!", preferredStyle: UIAlertControllerStyle.alert)
                
                tableLoadAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Exiting from alert")
                }))
                
                self.present(tableLoadAlert, animated: true, completion: nil)
            }
            else {
                for child in snapshot.children {
                    let event: Event = Event()
                    let snap = child as! FIRDataSnapshot
                    
                    let data = snap.value as! [String: AnyObject]
                    
                    event.name = data["name"] as! String?
                    event.date = data["date"] as! String?
                    event.beginTime = data["beginTime"] as! String?
                    event.endTime = data["endTime"] as! String?
                    event.location = data["location"] as! String?
                    event.description = data["description"] as! String?
                    
                    let volunteers: String = data["volunteers"]! as! String
                    let volunteersBeginTime: String = data["volunteersBeginTime"]! as! String
                    let volunteersEndTime: String = data["volunteersEndTime"]! as! String
                    event.volunteers = volunteers.components(separatedBy: ",")
                    event.volunteersBeginTime = volunteersBeginTime.components(separatedBy: ",")
                    event.volunteersEndTime = volunteersEndTime.components(separatedBy: ",")
                    event.eventImgUrl = data["eventImgUrl"] as! String?
                    
                    if let eventImgUrl = event.eventImgUrl {
                        let url = URL(string: eventImgUrl)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            DispatchQueue.main.async(execute: { 
                                event.eventImage = UIImage(data: data!)
                                self.events.append(event)
                                self.eventTableView.reloadData()
                            })
                        }).resume()
                    }
                }
            }
        })
    }
}
