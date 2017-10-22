//
//  VolunteerListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/30/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class VolunteerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var event: Event = Event()
    let menuList = ["Home", "Create Event", "Select School", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBAction func signUpBtn(_ sender: Any) {
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

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.backgroundColor = UIColor.clear
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        eventTitle.text = event.name
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event.volunteers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VolunteerTableViewCell
        
        cell.timeText.text = ((event.volunteersBeginTime?[indexPath.row])! + " - " + (event.volunteersEndTime?[indexPath.row])!)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            event.volunteers?.remove(at: indexPath.row)
            event.volunteersBeginTime?.remove(at: indexPath.row)
            event.volunteersEndTime?.remove(at: indexPath.row)
            let eventMgr: EventMgr = EventMgr()
            let location: Int = Int(event.id!)
            eventMgr.update(event, index: location)
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
            destination?.event = event
            destination?.isUpdating = true
        }
        
        NSLog("exiting prepareForSegue")
    }
}
