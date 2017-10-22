//
//  ViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func guestLoginBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToSchoolSelection", sender: self)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        var message: String = ""
        
        if usernameText.text != "" && passwordText.text != ""
        {
            let firebaseMgr: FirebaseMgr = FirebaseMgr()
            firebaseMgr.userLogin(email: self.usernameText.text!, password: self.passwordText.text!)
            let activityInd: CustomActivityIndicator = CustomActivityIndicator()
            activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                message = firebaseMgr.getMessage()
                print("\(message)")
                if message == "SUCCESS" {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                    self.performSegue(withIdentifier: "segueToSchoolSelection", sender: self)
                }
                else {
                    activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    let loginAlert = UIAlertController(title: "Sign In Failed!!", message: "Please Verify a valid email address and password has been entered!! Click Sign Up Here to create a login.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Exiting from alert")
                    }))
                    
                    self.present(loginAlert, animated: true, completion: nil)
                }
            }
        }
        else {
            let loginAlert = UIAlertController(title: "Missing Fields!!", message: "Please enter an email address and password!! Click Sign Up Here to create a login.", preferredStyle: UIAlertControllerStyle.alert)
            
            loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            present(loginAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToUserNameCreate", sender: self)
    }
    
    @IBAction func createSchoolBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueToSchoolCreation", sender: self)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        if segue.identifier == "segueToSchoolCreation" {
        }
        NSLog("exiting prepare for segue")
    }
    
    func applicationDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
    }
}

