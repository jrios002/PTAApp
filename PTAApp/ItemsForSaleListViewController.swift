//
//  ItemsForSaleListViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ItemsForSaleListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var itemsForSale = [ItemForSale]()
    var item: ItemForSale = ItemForSale()
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBAction func menuBtn(_ sender: Any) {
        menuLauncher.showMenu(menuList: menuList)
    }
    
    @IBAction func guestBtn(_ sender: Any) {
        userMenu.showMenu(menuList: userList)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        NSLog("unwindSegue")
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        if (currentMember.firstName?.isEmpty)! {
            guestBtn.title = "Hello Guest"
        }
        else {
            guestBtn.title = ("Hello " + currentMember.firstName!)
        }
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            self.itemsCollectionView.backgroundColor = UIColor.clear
            self.view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: self.gradientLayer)
            self.fetchItems()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsForSale.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemsCollectionViewCell
        
        cell.itemImage.image = itemsForSale[indexPath.row].itemImage
        cell.itemName.text = itemsForSale[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.item = itemsForSale[indexPath.row]
        performSegue(withIdentifier: "segueToItemDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("entering prepareForSegue")
        
        if segue.identifier == "segueToItemDetails" {
            NSLog("segueToItemDetails")
            let destination = (segue.destination as? ItemDetailsViewController)
            destination?.item = item
        }
        
        NSLog("exiting prepareForSegue")
    }
    
    func fetchItems(){
        self.itemsForSale.removeAll()
        var itemRef: FIRDatabaseReference!
        let schoolNameChild: String = (selectedSchool.name?.lowercased())!
        
        itemRef = FIRDatabase.database().reference().child("schoolList").child(schoolNameChild + selectedSchool.zipCode!).child("ItemsList")
        itemRef?.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value is NSNull {
                let tableLoadAlert = UIAlertController(title: "No Events to display", message: "No Events retreived from database!!", preferredStyle: UIAlertControllerStyle.alert)
                
                tableLoadAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Exiting from alert")
                }))
                
                self.present(tableLoadAlert, animated: true, completion: nil)
            }
            else {
                for child in snapshot.children {
                    let item: ItemForSale = ItemForSale()
                    let snap = child as! FIRDataSnapshot
                    
                    let data = snap.value as! [String: AnyObject]
                    
                    item.name = data["name"] as! String?
                    item.cost = data["cost"] as! Float?
                    item.description = data["description"] as! String?
                    item.itemImageUrl = data["itemImgUrl"] as! String?
                    
                    if let itemImgUrl = item.itemImageUrl {
                        let url = URL(string: itemImgUrl)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            DispatchQueue.main.async(execute: {
                                item.itemImage = UIImage(data: data!)
                                self.itemsForSale.append(item)
                                self.itemsCollectionView.reloadData()
                            })
                        }).resume()
                    }
                }
            }
        })
    }
}
