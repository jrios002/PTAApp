//
//  SchoolEventListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolEventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let menuList = ["Home", "Create Event", "Select School", "Log Out"]
    var event: Event = Event()
    var school: School = School()
    var events = [Event]()
    let menuLauncher: MenuLauncher = MenuLauncher()
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    @IBAction func menuBtn(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBAction func guestBtnAction(_ sender: Any) {
    }
    @IBAction func deleteEventsBtn(_ sender: Any) {
        myTableView.setEditing(true, animated: true)
    }
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        if menuShowing {
            menuLauncher.showMenu(menuList: menuList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.backgroundColor = UIColor.clear
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        schoolName.text = school.name
        
        let eventMgr: EventMgr = EventMgr()
        events = eventMgr.retrieveAll()
        print("count: \(events.count)")
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let event: Event = events[indexPath.row]
        cell.textLabel?.text = event.name
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.event = events[indexPath.row]
        performSegue(withIdentifier: "segueToEventDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let eventMgr: EventMgr = EventMgr()
            eventMgr.delete(events[indexPath.row])
            events = eventMgr.retrieveAll()
            myTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            myTableView.setEditing(false, animated: true)
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
}
