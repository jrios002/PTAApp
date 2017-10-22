//
//  RegisterUserViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/21/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let stateData: [String]! = ["", "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var boardMemberText: UITextField!
    @IBOutlet weak var adminCodeText: UITextField!
    @IBOutlet weak var boardMemLabel: UILabel!
    @IBOutlet weak var adminCodeLabel: UILabel!
    
    var seguedEmail: String = ""
    
    @IBOutlet weak var boardMemSwitch: UISwitch!
    @IBOutlet weak var adminSwitch: UISwitch!
    @IBAction func boardMemberSwitch(_ sender: Any) {
        boardMemLabel.isHidden = !boardMemLabel.isHidden
        boardMemberText.isHidden = !boardMemberText.isHidden
    }
    @IBAction func adminCodeSwitch(_ sender: Any) {
        adminCodeText.isHidden = !adminCodeText.isHidden
        adminCodeLabel.isHidden = !adminCodeLabel.isHidden
    }
    @IBAction func registerBtn(_ sender: Any) {
        if name.text != "" {
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
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Select School")
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let registerAlert = UIAlertController(title: "Missing Name!!", message: "The Name field cannot be empty!! Please enter a name to register!!", preferredStyle: UIAlertControllerStyle.alert)
            
            registerAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            self.present(registerAlert, animated: true, completion: nil)
        }
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        boardMemSwitch.isOn = false
        adminSwitch.isOn = false
        boardMemLabel.isHidden = true
        adminCodeLabel.isHidden = true
        boardMemberText.isHidden = true
        adminCodeText.isHidden = true
        createStatePicker()
        createToolbar()
        email.text = seguedEmail
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func createStatePicker(){
        let statePicker = UIPickerView()
        statePicker.delegate = self
        state.inputView = statePicker
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterUserViewController.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        state.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state.text = stateData[row]
    }

}
