//
//  MessagesViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/30/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    let menuList = ["Home", "Create Event", "Select School", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    
    var chatRef: FIRDatabaseReference!
    var msse652: FIRDatabaseHandle!
    var messages = [String]()
    var userName: String = ""
    
    @IBOutlet weak var chatTxt: UITextField!
    @IBAction func menuBar(_ sender: Any) {
        NSLog("entering menu button")
        menuLauncher.showMenu(menuList: menuList)
    }
    @IBAction func sendBtn(_ sender: Any) {
        let message = chatTxt.text
        if message != "" {
            chatRef.child("MSSE 692").childByAutoId().setValue(userName + " posted: " + message!)
            chatTxt.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        loadTable()
        self.chatTxt.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func loadTable() {
        NSLog("Entering loadTable")
        chatRef = FIRDatabase.database().reference(withPath: "chat")
        msse652 = chatRef.child("MSSE 692").observe(.value, with: { snapshot in
            self.messages = [String]()
            for item in snapshot.children {
                let child = item as! FIRDataSnapshot
                print("CHILD: \(child)")
                let value = child.value as! NSString
                let message = value as String
                self.messages.append(message)
            }
            self.tableView.reloadData()
        })
        NSLog("EXITING loadTable")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let message = chatTxt.text
        if message != "" {
            chatRef.child("MSSE 692").childByAutoId().setValue(userName + " posted: " + message!)
            chatTxt.text = ""
        }
        return true
    }
}
