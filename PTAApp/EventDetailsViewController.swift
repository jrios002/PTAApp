//
//  EventDetailsViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var event: Event = Event()
    var deletedEvent: Bool = false
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    
    @IBAction func menuBtn(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var whenTxt: UILabel!
    @IBOutlet weak var whereTxt: UILabel!
    @IBOutlet weak var timeTxt: UILabel!
    @IBOutlet weak var descTxt: UITextView!
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    @IBAction func volunteerBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToVolunteerList", sender: self)
    }
    
    @IBAction func editBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToEditEvent", sender: self)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        deletedEvent = true
        performSegue(withIdentifier: "unwindFromEventDetails", sender: self)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        fetchEvent(event: event)
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            if (currentMember.firstName?.isEmpty)! {
                self.guestBtn.title = "Hello Guest"
            }
            else {
                self.guestBtn.title = ("Hello " + currentMember.firstName!)
            }
            self.titleText.text = self.event.name
            self.whenTxt.text = self.event.date!
            self.timeTxt.text = self.event.beginTime! + " - " + self.event.endTime!
            self.whereTxt.text = self.event.location
            self.descTxt.text = self.event.description
            
            if let eventImgUrl = self.event.eventImgUrl {
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
        
        deletedEvent = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToVolunteerList" {
            NSLog("segueToVolunteerList")
            let destination = (segue.destination as? VolunteerListViewController)
            destination?.event = event
        }
        else if segue.identifier == "segueToEditEvent" {
            NSLog("segueToEditEvent")
            let destination = (segue.destination as? AddEventViewController)
            destination?.addEvent = event
            destination?.isUpdatingEvent = true
        }
        else if segue.identifier == "unwindFromEventDetails" {
            let destination = (segue.destination as? SchoolEventListViewController)
            destination?.deletedEvent = deletedEvent
        }
        
        NSLog("exiting prepareForSegue")
    }

    func fetchEvent(event: Event) {
        let eventMgr: EventMgr = EventMgr()
        self.event = eventMgr.getEvent(event.name!, school: selectedSchool)
    }
}
