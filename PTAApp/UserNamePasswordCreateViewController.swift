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
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordVerifyText: UITextField!
    @IBAction func backBtn(_ sender: Any) {
        NSLog("entering back button")
        self.performSegue(withIdentifier: "unwindFromUserNameCreate", sender: self)
    }
    @IBAction func facebookLoginBtn(_ sender: Any) {
    }
    @IBAction func googleLoginBtn(_ sender: Any) {
    }
    @IBAction func nextBtn(_ sender: Any) {
        var message: String = ""
        
        if passwordText.text == passwordVerifyText.text {
            if usernameText.text != "" && passwordText.text != ""
            {
                let firebaseMgr: FirebaseMgr = FirebaseMgr()
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
                        
                        self.present(loginAlert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let loginAlert = UIAlertController(title: "Password Do Not Match!!", message: "Please Verify that password were entered correctly and try again!", preferredStyle: UIAlertControllerStyle.alert)
            
            loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            present(loginAlert, animated: true, completion: nil)
            
            passwordText.text = ""
            passwordVerifyText.text = ""
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        let destination = (segue.destination as? RegisterUserViewController)
        if segue.identifier == "segueToRegisterUser" {
            destination?.seguedEmail = usernameText.text!
        }
        NSLog("exiting prepare for segue")
    }

}
