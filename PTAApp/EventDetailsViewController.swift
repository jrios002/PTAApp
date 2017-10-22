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
    var location: Int = 0
    let menuList = ["Home", "Create Event", "Select School", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    
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
    @IBAction func volunteerBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToVolunteerList", sender: self)
    }
    
    @IBAction func editBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToEditEvent", sender: self)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let eventMgr: EventMgr = EventMgr()
        eventMgr.delete(event)
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
        let eventMgr: EventMgr = EventMgr()
        var events = [Event]()
        location = Int(event.id!) - 1
        events = eventMgr.retrieveAll()
        event = events[location]
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        titleText.text = event.name
        whenTxt.text = event.date!
        timeTxt.text = event.beginTime! + " - " + event.endTime!
        whereTxt.text = event.location
        descTxt.text = event.description
        eventImage.image = #imageLiteral(resourceName: "EventExample")
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
            destination?.event = event
            destination?.isUpdatingEvent = true
        }
        
        NSLog("exiting prepareForSegue")
    }

}
