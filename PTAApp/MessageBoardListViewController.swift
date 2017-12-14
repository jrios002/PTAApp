//
//  MessageBoardListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageBoardListViewController: UIViewController {
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    
    @IBAction func menuBar(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    @IBOutlet weak var userNameTxt: UITextField!
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageBoardListViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if (currentMember.firstName?.isEmpty)! {
            guestBtn.title = "Hello Guest"
        }
        else {
            guestBtn.title = ("Hello " + currentMember.firstName!)
        }
        
        let user = FIRAuth.auth()?.currentUser
        if user != nil {
            userNameTxt.text = currentMember.firstName
            performSegue(withIdentifier: "segueToMessages", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        let firebaseMgr: FirebaseMgr = FirebaseMgr()
        firebaseMgr.anonSignIn()
        self.performSegue(withIdentifier: "segueToMessages", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToMessages" {
            NSLog("segueToMessages")
            let destination = (segue.destination as? MessagesViewController)
            destination?.userName = userNameTxt.text!
        }
        
        NSLog("exiting prepareForSegue")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
