//
//  AddItemForSaleViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/14/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class AddItemForSaleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let menuList = ["Home", "Create Event", "Select School", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    var currentString = ""
    var itemForSale: ItemForSale = ItemForSale()
    var isUpdating: Bool = false
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var uploadItemBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromAddItemForSale", sender: self)
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        if (cost.text?.isEmpty)! {
            let updateAlert = UIAlertController(title: "Missing Field!!", message: "You must enter a value for the cost of the item to proceed.", preferredStyle: UIAlertControllerStyle.alert)
            
            updateAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            self.dismissKeyboard()
            self.present(updateAlert, animated: true, completion: nil)
        }
        else {
            let itemMgr: ItemForSaleMgr = ItemForSaleMgr()
            if isUpdating {
                itemMgr.delete(itemForSale, school: selectedSchool)
            }
            itemForSale.name = name.text
            itemForSale.description = itemDesc.text
            var costString = cost.text
            costString = costString?.replacingOccurrences(of: "$", with: "")
            costString = costString?.replacingOccurrences(of: ".", with: "")
            costString = costString?.replacingOccurrences(of: ",", with: "")
            var costFloat = Float(costString!)
            costFloat = (costFloat!/100.0)
            itemForSale.cost = costFloat
            if itemImage.image == #imageLiteral(resourceName: "emptyImage2") {
                itemForSale.itemImage = #imageLiteral(resourceName: "noImage")
            }
            else {
                itemForSale.itemImage = itemImage.image
            }
            
            itemMgr.create(itemForSale, school: selectedSchool)
            
            let activityInd: CustomActivityIndicator = CustomActivityIndicator()
            activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.isUpdating = false
                self.performSegue(withIdentifier: "unwindFromAddItemForSale", sender: self)
            }
        }
    }
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        cost.keyboardType = UIKeyboardType.numberPad
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddItemForSaleViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if isUpdating {
            titleLabel.text = "Update Item For Sale"
            uploadItemBtn.setTitle("Update Item", for: .normal)
            name.text = itemForSale.name
            itemDesc.text = itemForSale.description
            if itemForSale.itemImage == #imageLiteral(resourceName: "noImage") {
                itemImage.image = #imageLiteral(resourceName: "emptyImage2")
            }
            else {
                itemImage.image = itemForSale.itemImage
            }
        }
        else {
            titleLabel.text = "Add Item For Sale"
            uploadItemBtn.setTitle("Upload Item", for: .normal)
            itemImage.image = #imageLiteral(resourceName: "emptyImage2")
        }
        itemImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectEventImageView)))
        itemImage.isUserInteractionEnabled = true
        self.cost.delegate = self
        cost.addTarget(self, action: #selector(costTextFieldDidChange), for: .editingChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
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
            itemImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func costTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
