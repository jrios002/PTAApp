//
//  SchoolSelectionViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/25/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var school: School = School()
    var schools = [School]()
    let menuLauncher = MenuLauncher()
    let menuList = ["Home", "Create School", "Log Out"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedSchoolText: UITextField!
    @IBAction func selectSchoolBtn(_ sender: Any) {
        if selectedSchoolText.text != "" {
            performSegue(withIdentifier: "segueToEventList", sender: self)
        }
        else {
            let selectAlert = UIAlertController(title: "School selection error!", message: "Please Select a school to continue.", preferredStyle: UIAlertControllerStyle.alert)
            
            selectAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            present(selectAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func MenuButton(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        
        if (menuShowing){
            menuLauncher.showMenu(menuList: menuList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = UIColor.clear
        let schoolMgr: SchoolMgr = SchoolMgr()
        schools = schoolMgr.retrieveAll()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        self.school = self.schools[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = school.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.school = self.schools[indexPath.row]
        selectedSchoolText.text = school.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        let destination = (segue.destination as? SchoolEventListViewController)
        if segue.identifier == "segueToEventList" {
            destination?.school = school
        }
        NSLog("exiting prepare for segue")
    }
}
