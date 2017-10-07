//
//  RegisterUserViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/21/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var boardMemberText: UITextField!
    @IBOutlet weak var adminCodeText: UITextField!
    
    var seguedEmail: String = ""
    
    @IBAction func boardMemberSwitch(_ sender: Any) {
    }
    @IBAction func adminCodeSwitch(_ sender: Any) {
    }
    @IBAction func backBtn(_ sender: Any) {
        NSLog("entering back button")
        self.performSegue(withIdentifier: "unwindFromRegisterUser", sender: self)
    }
    @IBAction func registerBtn(_ sender: Any) {
        let member: Member = Member()
        member.name = name.text
        member.address = address.text
        member.city = city.text
        member.state = state.text
        member.phone = phone.text
        member.email = email.text
        member.adminRights = true
        member.ptaTitle = boardMemberText.text
        
        let memberMgr: MemberMgr = MemberMgr()
        memberMgr.create(member)
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SchoolSelectionViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = seguedEmail
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
