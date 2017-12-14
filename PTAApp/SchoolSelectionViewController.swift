//
//  SchoolSelectionViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/25/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Firebase

var selectedSchool: School = School()
var currentMember: Member = Member()

class SchoolSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var school: School = School()
    var schoolFilter: School = School()
    var schools = [School]()
    var filteredSchool = [School]()
    var isSearching: Bool = false
    var message: String = ""
    let menuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    let menuList = ["Home", "Create School", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    var guestName: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func MenuButton(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = UIColor.clear
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        currentMember = fetchUserInfo()
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            if (currentMember.firstName?.isEmpty)! {
                self.userName.title = "Hello Guest"
            }
            else {
                self.userName.title = ("Hello " + currentMember.firstName!)
            }
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
        }
        fetchSchools()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        
        if (menuShowing){
            menuLauncher.showMenu(menuList: menuList)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredSchool.count
        }
        else {
            return schools.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchoolListTableViewCell
        
        if isSearching {
            self.school = self.filteredSchool[indexPath.row]
        }
        else {
            self.school = self.schools[indexPath.row]
        }
        cell.backgroundColor = UIColor.clear
        cell.schoolName.text = school.name
        cell.schoolImage.image = school.schoolImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            self.school = self.filteredSchool[indexPath.row]
        }
        else {
            self.school = self.schools[indexPath.row]
        }
        
        selectedSchool = self.school
        performSegue(withIdentifier: "segueToEventList", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            
            view.endEditing(true)
            
            tableView.reloadData()
        }
        else {
            isSearching = true
            
            filteredSchool = schools.filter({ (schoolFound) -> Bool in
                (schoolFound.name?.contains(searchBar.text!))!
            })
            
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        if segue.identifier == "segueToEventList" {
            
        }
        
        NSLog("exiting prepare for segue")
    }
    
    func fetchSchools(){
        var schoolRef: FIRDatabaseReference!

        schoolRef = FIRDatabase.database().reference()
        schoolRef?.child("schoolList").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value is NSNull {
                let tableLoadAlert = UIAlertController(title: "No Schools to display.", message: "No Schools retreived from database!!", preferredStyle: UIAlertControllerStyle.alert)
                
                tableLoadAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Exiting from alert")
                }))
                
                self.present(tableLoadAlert, animated: true, completion: nil)
            }
            else {
                for child in snapshot.children {
                    let school: School = School()
                    let snap = child as! FIRDataSnapshot
                    
                    let data = snap.value as! [String: AnyObject]
                    
                    school.name = data["name"] as! String?
                    school.address = data["address"] as! String?
                    school.city = data["city"] as! String?
                    school.state = data["state"] as! String?
                    school.zipCode = data["zip"] as! String?
                    school.phone = data["phone"] as! String?
                    school.adminCode = data["adminCode"] as! String?
                    school.schoolImgUrl = data["schoolImgUrl"] as! String?
                    
                    if let schoolImgUrl = school.schoolImgUrl {
                        let url = URL(string: schoolImgUrl)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            DispatchQueue.main.async(execute: { 
                                school.schoolImage = UIImage(data: data!)
                                self.schools.append(school)
                                self.tableView.reloadData()
                            })
                        }).resume()
                    }
                }
            }
        })
    }
    
    func fetchUserInfo() -> Member {
        let user = FIRAuth.auth()?.currentUser
        var memberUser: Member = Member()
        if let user = user {
            let email =  user.email
            let memMgr: MemberMgr = MemberMgr()
            memberUser = memMgr.getMember(email!)
        }
        
        return memberUser
    }
}
