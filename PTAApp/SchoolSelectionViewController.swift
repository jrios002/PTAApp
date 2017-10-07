//
//  SchoolSelectionViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/25/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var schools = [School]()
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
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginScreenViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        let schoolMgr: SchoolMgr = SchoolMgr()
        schools = schoolMgr.retrieveAll()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
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
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let school: School = self.schools[indexPath.row]
        cell.textLabel?.text = school.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        let school: School = self.schools[indexPath.row]
        selectedSchoolText.text = school.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        NSLog("exiting prepare for segue")
    }

}
