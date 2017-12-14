//
//  ItemDetailsViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/19/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    var item: ItemForSale = ItemForSale()
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDesc: UITextView!
    @IBOutlet weak var itemCost: UILabel!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBAction func menuBtn(_ sender: Any) {
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func guestBtn(_ sender: Any) {
        menuLauncher.showMenu(menuList: userList)
    }
    
    @IBAction func addToCartBtn(_ sender: Any) {
        if quantity.text == "" {
            let quantityAlert = UIAlertController(title: "Missing Quantity!!", message: "Please enter the amount of this item you wish to purchase in the Quantity Box!!", preferredStyle: UIAlertControllerStyle.alert)
            
            quantityAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Exiting from alert")
            }))
            
            present(quantityAlert, animated: true, completion: nil)
        }
        else {
            if (currentMember.firstName?.isEmpty)! {
                let memberAlert = UIAlertController(title: "Not Logged In!!", message: "You must be logged in to add to a cart!!", preferredStyle: UIAlertControllerStyle.alert)
                
                memberAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Exiting from alert")
                }))
                
                present(memberAlert, animated: true, completion: nil)
            }
            else {
                let quantityNumber: Float = Float(quantity.text!)!
                let price = quantityNumber * item.cost!
                let cartMgr: MemberCartMgr = MemberCartMgr()
                cartMgr.create(item, member: currentMember, quantity: Int(quantity.text!)!, cost: price)
                
                let activityInd: CustomActivityIndicator = CustomActivityIndicator()
                activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    UIApplication.shared.endIgnoringInteractionEvents()
                    activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                    
                    let addedAlert = UIAlertController(title: "SUCCESS!!!", message: "Item successfully added to cart!!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    addedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Exiting from alert")
                        self.performSegue(withIdentifier: "unwindFromItemDetails", sender: self)
                    }))
                    
                    self.present(addedAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func editItem(_ sender: Any) {
        performSegue(withIdentifier: "segueToEditItem", sender: self)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let itemMgr: ItemForSaleMgr = ItemForSaleMgr()
        itemMgr.delete(item, school: selectedSchool)
        
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            
            self.performSegue(withIdentifier: "unwindFromItemDetails", sender: self)
        }
    }
    
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: self.gradientLayer)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ItemDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        quantity.keyboardType = UIKeyboardType.numberPad
        fetchItem(item: item)
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            if (currentMember.firstName?.isEmpty)! {
                self.guestBtn.title = "Hello Guest"
            }
            else {
                self.guestBtn.title = ("Hello " + currentMember.firstName!)
            }
            
            self.itemName.text = self.item.name
            self.itemImage.image = self.item.itemImage
            self.itemDesc.text = self.item.description
            let costString = NSString(format: "%.2f", self.item.cost!)
            self.itemCost.text = "$" + (costString as String)
            
            if let itemImgUrl = self.item.itemImageUrl {
                let url = URL(string: itemImgUrl)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.itemImage.image = UIImage(data: data!)
                        self.item.itemImage = self.itemImage.image
                    })
                }).resume()
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToEditItem" {
            NSLog("segueToEditItem")
            let destination = (segue.destination as? AddItemForSaleViewController)
            destination?.isUpdating = true
            destination?.itemForSale = item
        }
        
        NSLog("exiting prepareForSegue")
    }
    
    func fetchItem(item: ItemForSale) {
        let itemMgr: ItemForSaleMgr = ItemForSaleMgr()
        self.item = itemMgr.getItemForSale(item.name!, school: selectedSchool)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
