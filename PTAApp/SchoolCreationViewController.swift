//
//  SchoolCreationViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/18/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var randomString: String? = ""
    let stateData: [String]! = ["", "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var zipCodeText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBAction func createSchoolBtn(_ sender: UIButton) {
        randomString = getRandomString(length: 10)
        if nameText.text != "" && zipCodeText.text != "" {
            let school: School = School()
            school.name = nameText.text
            school.address = addressText.text
            school.city = cityText.text
            school.state = stateText.text
            school.zipCode = zipCodeText.text
            school.phone = phoneText.text
            school.adminCode = randomString
            if schoolImage.image == #imageLiteral(resourceName: "emptyImage2") {
                school.schoolImage = #imageLiteral(resourceName: "noImage")
            }
            else {
                school.schoolImage = schoolImage.image
            }
            
            let schoolMgr: SchoolMgr = SchoolMgr()
            schoolMgr.create(school)
            
            self.performSegue(withIdentifier: "segueToSchoolCreateVerify", sender: self)
        }
        else {
            let createAlert = UIAlertController(title: "Missing Fields!!", message: "A school Name and Zip Code must be entered to create school!!", preferredStyle: UIAlertControllerStyle.alert)
            
            createAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            present(createAlert, animated: true, completion: nil)
        }
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SchoolCreationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        phoneText.keyboardType = UIKeyboardType.numbersAndPunctuation
        zipCodeText.keyboardType = UIKeyboardType.numbersAndPunctuation
        createStatePicker()
        createToolbar()
        schoolImage.image = #imageLiteral(resourceName: "emptyImage2")
        schoolImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectEventImageView)))
        schoolImage.isUserInteractionEnabled = true
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
    
    func handleSelectEventImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            schoolImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

