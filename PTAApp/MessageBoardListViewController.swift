//
//  MessageBoardListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class MessageBoardListViewController: UIViewController {
    
    @IBOutlet weak var userNameTxt: UITextField!
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        let firebaseMgr: FirebaseMgr = FirebaseMgr()
        firebaseMgr.anonSignIn()
        self.performSegue(withIdentifier: "segueToMessages", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
}
