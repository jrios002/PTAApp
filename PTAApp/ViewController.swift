//
//  ViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    let fbLoginBtn = FBSDKLoginButton()
    let googleBtn = GIDSignInButton()
    var socialUser: Member = Member()
    var socialEmail: String = ""
    var membersList = [String]()
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func guestLoginBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToSchoolSelection", sender: self)
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
        try! FIRAuth.auth()!.signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance()!.signOut()
        scrollView.addSubview(fbLoginBtn)
        scrollView.addSubview(googleBtn)
        fbLoginBtn.frame = CGRect(x: 16, y: 450, width: view.frame.width - 32, height: 50)
        googleBtn.frame = CGRect(x: 16, y: 450 + 66, width: view.frame.width - 32, height: 50)
        fbLoginBtn.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        fbLoginBtn.readPermissions = ["email", "public_profile"]
        
        let newSessionMember: Member = Member()
        currentMember = newSessionMember
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        scrollView.addSubview(fbLoginBtn)
        fbLoginBtn.frame = CGRect(x: 16, y: 450, width: view.frame.width - 32, height: 50)
        googleBtn.frame = CGRect(x: 16, y: 450 + 66, width: view.frame.width - 32, height: 50)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        if segue.identifier == "segueToUserNameInfo" {
            let destination = segue.destination as! RegisterUserViewController
            destination.seguedEmail = socialEmail
            destination.isLoggedIntoSocialMedia = true
        }
        NSLog("exiting prepare for segue")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook Login")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let accessToken = FBSDKAccessToken.current()
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let user = user {
                self.socialEmail = user.email!
                self.fetchMembers()
            }
            
            print("Success logging in with Facebook", user ?? "")
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to login into Google: ", err)
            return
        }
        
        print("Successfully logged into Google")
        
        let idToken = user.authentication.idToken
        let accessToken = user.authentication.accessToken
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to login to Firebase with Google: ", err)
                return
            }
            
            print("Successfully logged into Firebase with Google")
            if let user = user {
                self.socialEmail = user.email!
                self.fetchMembers()
            }
        })
    }
    
    func fetchMembers(){
        var membersRef: FIRDatabaseReference!
        
        membersRef = FIRDatabase.database().reference()
        let newEmail = self.socialEmail.replacingOccurrences(of: ".", with: "Dot")
        membersRef?.child("memberList").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                
            }
            else {                
                let data = snapshot.value as! [String: AnyObject]
                let lazyData = data.keys
                
                self.membersList = Array(lazyData)
            }
        })
        
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            if self.membersList.contains(newEmail) {
                let loginAlert = UIAlertController(title: "SUCCESS!!", message: "You have signed in successfully!! Click OK to proceed", preferredStyle: UIAlertControllerStyle.alert)
                
                loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    print("Exiting from alert")
                    self.performSegue(withIdentifier: "segueToSchoolSelection", sender: self)
                }))
                
                self.present(loginAlert, animated: true, completion: nil)
            }
            else {
                let loginAlert = UIAlertController(title: "Member info needed!", message: "Since this is the first time you have logged into this app, please click OK to enter your membership information.", preferredStyle: UIAlertControllerStyle.alert)
                
                loginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    print("Exiting from alert")
                    self.performSegue(withIdentifier: "segueToUserNameInfo", sender: self)
                }))
                
                self.present(loginAlert, animated: true, completion: nil)
            }
        }
    }
}

