//
//  RegisterUserViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/21/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Firebase

class RegisterUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let stateData: [String]! = ["", "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    var schools = [School]()
    var verifyCode: String = ""
    var schoolName = ""
    var seguedEmail: String = ""
    var seguedPassword: String = ""
    var isSelectingState: Bool = true
    var isLoggedIn: Bool = false
    var isLoggedIntoSocialMedia: Bool = false
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var boardMemberText: UITextField!
    @IBOutlet weak var adminCodeText: UITextField!
    @IBOutlet weak var boardMemLabel: UILabel!
    @IBOutlet weak var adminCodeLabel: UILabel!
    @IBOutlet weak var boardMemSwitch: UISwitch!
    @IBOutlet weak var adminSwitch: UISwitch!
    @IBOutlet weak var selectedSchool: UITextField!
    @IBOutlet weak var schoolImage: UIImageView!
    @IBOutlet weak var schoolSelectedLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    @IBAction func cancelBtn(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromRegisterUser", sender: self)
    }
    @IBAction func boardMemberSwitch(_ sender: Any) {
        boardMemLabel.isHidden = !boardMemLabel.isHidden
        boardMemberText.isHidden = !boardMemberText.isHidden
        schoolSelectedLabel.isHidden = !schoolSelectedLabel.isHidden
        selectedSchool.isHidden = !selectedSchool.isHidden
    }
    
    @IBAction func adminCodeSwitch(_ sender: Any) {
        adminCodeText.isHidden = !adminCodeText.isHidden
        adminCodeLabel.isHidden = !adminCodeLabel.isHidden
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if firstName.text != "" {
            let member: Member = Member()
            member.firstName = firstName.text
            member.lastName = lastName.text
            member.address = address.text
            member.city = city.text
            member.state = state.text
            member.phone = phone.text
            member.email = email.text
            member.ptaTitle = boardMemberText.text
            member.adminRights = false
            member.schoolAdmin = schoolName
            
            if adminSwitch.isOn {
                if adminCodeText.text != "" {
                    if adminCodeText.text != verifyCode {
                        let codeAlert = UIAlertController(title: "Invalid Code!!", message: "Please enter the correct Admin Rights Code for the selected school!! \nContact your PTA president or school principal to request admin rights access", preferredStyle: UIAlertControllerStyle.alert)
                        
                        codeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            print("Exiting from alert")
                        }))
                        
                        self.present(codeAlert, animated: true, completion: nil)
                        adminCodeText.text = ""
                    }
                    else {
                        member.adminRights = true
                        if isLoggedIn {
                            let memberMgr: MemberMgr = MemberMgr()
                            memberMgr.update(member)
                            let successAlert = UIAlertController(title: "Success!!", message: "You have successfully updated your account!! Click OK to continue!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "Select School")
                                self.present(vc, animated: true, completion: nil)
                            }))
                            
                            self.present(successAlert, animated: true, completion: nil)
                        }
                        else {
                            let memberMgr: MemberMgr = MemberMgr()
                            memberMgr.create(member)
                            let fireMgr: FirebaseMgr = FirebaseMgr()
                            fireMgr.userLogin(email: seguedEmail, password: seguedPassword)
                            let successAlert = UIAlertController(title: "Congratulations!!", message: "You have successfully registered!! Click OK to continue!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                let vc = self.storyboard!.instantiateViewController(withIdentifier: "Select School")
                                self.present(vc, animated: true, completion: nil)
                            }))
                            
                            self.present(successAlert, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    let codeAlert = UIAlertController(title: "Missing Code!!", message: "Please enter the correct Admin Rights Code for the selected school!! \nContact your PTA president or school principal to request admin rights access", preferredStyle: UIAlertControllerStyle.alert)
                    
                    codeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Exiting from alert")
                    }))
                    
                    self.present(codeAlert, animated: true, completion: nil)
                    adminCodeText.text = ""
                }
            }
            else {
                if isLoggedIn {
                    let memberMgr: MemberMgr = MemberMgr()
                    memberMgr.update(member)
                    let successAlert = UIAlertController(title: "Success!!", message: "You have successfully updated your account!! Click OK to continue!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Select School")
                        self.present(vc, animated: true, completion: nil)
                    }))
                    
                    self.present(successAlert, animated: true, completion: nil)
                }
                else {
                    let memberMgr: MemberMgr = MemberMgr()
                    memberMgr.create(member)
                    let fireMgr: FirebaseMgr = FirebaseMgr()
                    fireMgr.userLogin(email: seguedEmail, password: seguedPassword)
                    let successAlert = UIAlertController(title: "Congratulations!!", message: "You have successfully registered!! Click OK to continue!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    successAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Select School")
                        self.present(vc, animated: true, completion: nil)
                    }))
                    
                    self.present(successAlert, animated: true, completion: nil)
                }
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        if currentMember.firstName != "" {
            isLoggedIn = true
            cancelBtn.isEnabled = true
            guestBtn.isEnabled = true
            guestBtn.title = "Hello " + currentMember.firstName!
            registerBtn.setTitle("Update", for: .normal)
            firstName.text = currentMember.firstName
            lastName.text = currentMember.lastName
            address.text = currentMember.address
            city.text = currentMember.city
            state.text = currentMember.state
            phone.text = currentMember.phone
            email.text = currentMember.email
            if currentMember.ptaTitle != "" {
                boardMemSwitch.isOn = true
                boardMemLabel.isHidden = false
                boardMemberText.text = currentMember.ptaTitle
                schoolSelectedLabel.isHidden = false
                selectedSchool.isHidden = false
            }
            else {
                boardMemSwitch.isOn = false
                boardMemLabel.isHidden = true
                boardMemberText.isHidden = true
            }
            
            adminSwitch.isOn = false
            adminCodeLabel.isHidden = true
            adminCodeText.isHidden = true
            
        }
        else if isLoggedIntoSocialMedia {
            isLoggedIn = true
            cancelBtn.isEnabled = false
            guestBtn.isEnabled = false
            registerBtn.setTitle("Register", for: .normal)
            boardMemSwitch.isOn = false
            adminSwitch.isOn = false
            boardMemLabel.isHidden = true
            adminCodeLabel.isHidden = true
            boardMemberText.isHidden = true
            adminCodeText.isHidden = true
            schoolSelectedLabel.isHidden = true
            selectedSchool.isHidden = true
            email.text = seguedEmail
        }
        else {
            isLoggedIn = false
            cancelBtn.isEnabled = false
            guestBtn.isEnabled = false
            registerBtn.setTitle("Register", for: .normal)
            boardMemSwitch.isOn = false
            adminSwitch.isOn = false
            boardMemLabel.isHidden = true
            adminCodeLabel.isHidden = true
            boardMemberText.isHidden = true
            adminCodeText.isHidden = true
            schoolSelectedLabel.isHidden = true
            selectedSchool.isHidden = true
            email.text = seguedEmail
        }
        
        createToolbar()
        createStatePicker()
        fetchSchools()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func createStatePicker(){
        let statePicker = UIPickerView()
        let schoolPicker = UIPickerView()
        statePicker.delegate = self
        schoolPicker.delegate = self
        state.inputView = statePicker
        selectedSchool.inputView = schoolPicker
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterUserViewController.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        state.inputAccessoryView = toolbar
        selectedSchool.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var returnString: String = ""
        if state.isEditing {
            returnString = stateData[row]
        }
        else if selectedSchool.isEditing {
            returnString = (schools[row].name! + " " + schools[row].zipCode!)
        }
        
        return returnString
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var returnInt = 0
        if state.isEditing {
            returnInt = stateData.count
        }
        else if selectedSchool.isEditing {
            returnInt = schools.count
        }
        
        return returnInt
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if state.isEditing {
            state.text = stateData[row]
        }
        else if selectedSchool.isEditing {
            selectedSchool.text = schools[row].name
            schoolImage.image = schools[row].schoolImage
            schoolName = schools[row].name! + schools[row].zipCode!
            verifyCode = schools[row].adminCode!
        }
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
                    school.zipCode = data["zip"] as! String?
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
                            })
                        }).resume()
                    }
                }
            }
        })
    }
}
