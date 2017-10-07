//
//  SchoolEventListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

var list = ["Event1", "Event2", "Event3"]
var listTime = ["6:00-6:30", "6:30-7:00", "7:00-7:30"]
var myIndex = 0
var events = [Event]()

class SchoolEventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func menuBtn(_ sender: Any) {
        NSLog("entering menu button")
        self.performSegue(withIdentifier: "unwindFromEventsList", sender: self)
    }
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        let schoolMgr: SchoolMgr = SchoolMgr()
        let schools = schoolMgr.retrieveAll()
        let school: School = schools[myIndex]
        schoolName.text = school.name
        let event: Event = Event()
        event.name = "Event 1"
        event.date = "November 1st"
        event.time = "6:30-8:30"
        event.location = "Library"
        event.description = "Test Description"
        event.volunteer = "Test Volunteers"
        
        let event2: Event = Event()
        event2.name = "Event 2"
        event2.date = "November 2nd"
        event2.time = "7:00-8:00"
        event2.location = "Music Hall"
        event2.description = "Test Description2"
        event2.volunteer = "Test Volunteers2"
        
        let event3: Event = Event()
        event3.name = "Event 3"
        event3.date = "November 3rd"
        event3.time = "6:30-9:30"
        event3.location = "School Park"
        event3.description = "Test Description"
        event3.volunteer = "Test Volunteers"
        
        
        
        let eventMgr: EventMgr = EventMgr()
        eventMgr.create(event)
        eventMgr.create(event2)
        eventMgr.create(event3)
        
        events = eventMgr.retrieveAll()
        print("count: \(events.count)")
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let event: Event = events[indexPath.row]
        cell.textLabel?.text = event.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segueToEventDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToEventDetails" {
            NSLog("segueToEventDetails")
            let destination = (segue.destination as? EventDetailsViewController)
            destination?.event = events[myIndex]
        }
        
        NSLog("exiting prepareForSegue")
    }
}
