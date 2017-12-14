//
//  UserNamePasswordCreateViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/21/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserNamePasswordCreateViewController: UIViewController {
    
    var isUpdating: Bool = false
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordVerifyText: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBAction func backBtn(_ sender: Any) {
        NSLog("entering back button")
        self.performSegue(withIdentifier: "unwindFromUserNameCreate", sender: self)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        var message: String = ""
        if usernameText.text == "" || passwordText.text == "" || passwordVerifyText.text == "" {
            let noNameAlert = UIAlertController(title: "ERROR!!", message: "No text field can be left blank.", preferredStyle: UIAlertControllerStyle.alert)
            
            noNameAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            dismissKeyboard()
            
            self.present(noNameAlert, animated: true, completion: nil)
        }
        
        if passwordText.text == passwordVerifyText.text {
            if usernameText.text != "" && passwordText.text != ""
            {
                let firebaseMgr: FirebaseMgr = FirebaseMgr()
                
                if isUpdating {
                    let user = FIRAuth.auth()?.currentUser
                    if let user = user {
                        user.updateEmail(usernameText.text!, completion: { (error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("SUCCESS updating email")
                            }
                        })
                        user.updatePassword(passwordText.text!, completion: { (error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("SUCCESS updating password")
                            }
                        })
                    }
                    let memberMgr: MemberMgr = MemberMgr()
                    memberMgr.delete(currentMember)
                    let activityInd: CustomActivityIndicator = CustomActivityIndicator()
                    activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
                    
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        message = firebaseMgr.getMessage()
                        print("\(message)")
                        if message == "SUCCESS" {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                            currentMember.email = self.usernameText.text
                            memberMgr.create(currentMember)
                            let updateAlert = UIAlertController(title: "SUCCESS!!", message: "Log in credentials successfully updated!!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            updateAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                print("Exiting from alert")
                                self.performSegue(withIdentifier: "unwindFromUserNameCreate", sender: self)
                            }))
                            
                            self.dismissKeyboard()
                            self.present(updateAlert, animated: true, completion: nil)
                        }
                        else {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                            let updateAlert = UIAlertController(title: "ERROR!!", message: "Unable to update your credentials!!/nPlease try again later!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            updateAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                print("Exiting from alert")
                                self.performSegue(withIdentifier: "unwindFromUserNameCreate", sender: self)
                            }))
                            
                            self.dismissKeyboard()
                            self.present(updateAlert, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    firebaseMgr.emailSignUp(email: usernameText.text!, password: passwordText.text!)
                    let activityInd: CustomActivityIndicator = CustomActivityIndicator()
                    activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
                    
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        message = firebaseMgr.getMessage()
                        print("\(message)")
                        if message == "SUCCESS" {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                            self.performSegue(withIdentifier: "segueToRegisterUser", sender: self)
                        } else {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                            let loginAlert = UIAlertController(title: "Sign Up Failed!!", message: "Please Verify that a valid email address is entered AND Password is at least 6 characters long!!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                print("Exiting from alert")
                            }))
                            
                            self.dismissKeyboard()
                            self.present(loginAlert, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            let loginAlert = UIAlertController(title: "Passwords Do Not Match!!", message: "Please Verify that passwords were entered correctly and try again!", preferredStyle: UIAlertControllerStyle.alert)
            
            loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            self.dismissKeyboard()
            present(loginAlert, animated: true, completion: nil)
            
            passwordText.text = ""
            passwordVerifyText.text = ""
        }
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserNamePasswordCreateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if currentMember.firstName != "" {
            isUpdating = true
            nextBtn.setTitle("Update", for: .normal)
        }
        else {
            isUpdating = false
            nextBtn.setTitle("Next", for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        let destination = (segue.destination as? RegisterUserViewController)
        if segue.identifier == "segueToRegisterUser" {
            destination?.seguedEmail = usernameText.text!
            destination?.seguedPassword = passwordVerifyText.text!
        }
        NSLog("exiting prepare for segue")
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
