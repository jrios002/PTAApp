//
//  SchoolCreationViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/18/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var randomString: String? = ""
    let stateData: [String]! = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBAction func addImageBtn(_ sender: UIButton) {
    }
    @IBAction func createSchoolBtn(_ sender: UIButton) {
        randomString = getRandomString(length: 10)
        
        let school: School = School()
        school.name = nameText.text
        school.address = addressText.text
        school.city = cityText.text
        school.state = stateText.text
        school.phone = phoneText.text
        school.adminCode = randomString
        
        let schoolMgr: SchoolMgr = SchoolMgr()
        schoolMgr.create(school)
        
        self.performSegue(withIdentifier: "segueToSchoolCreateVerify", sender: self)
    }
    @IBOutlet weak var schoolImage: UIImageView!
    @IBAction func backBtn(_ sender: Any) {
        NSLog("entering back button")
        self.performSegue(withIdentifier: "unwindFromSchoolCreation", sender: self)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        createStatePicker()
        createToolbar()
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
    
    func createStatePicker(){
        let statePicker = UIPickerView()
        statePicker.delegate = self
        stateText.inputView = statePicker
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SchoolCreationViewController.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        stateText.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepare for segue")
        let destination = (segue.destination as? SchoolCreateVerifyViewController)
        if segue.identifier == "segueToSchoolCreateVerify" {
            destination?.codeText = randomString
        }
        NSLog("exiting prepare for segue")
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
        stateText.text = stateData[row]
    }
    
    func getRandomString(length: Int) -> String {
        let letters: NSString = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        let len = UInt32(letters.length)
        var randString = ""
        for _ in 0..<length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randString
    }

}

