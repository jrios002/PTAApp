//
//  CartViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/20/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Firebase

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let menuList = ["Home", "Create Event", "Select School", "Add Item For Sale", "Edit User Info", "Edit Email Password", "Log Out"]
    let userList = ["Edit User Info", "Edit Email Password", "Log Out"]
    let menuLauncher: MenuLauncher = MenuLauncher()
    let userMenu = MenuLauncher()
    var cartItems = [MemberCartItem]()
    var total: Float = 0

    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var numberInCartLabel: UILabel!
    @IBOutlet weak var guestCartLabel: UILabel!
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    @IBOutlet weak var itemsInCartTableView: UITableView!
    @IBAction func checkOutBtn(_ sender: Any) {
    }
    @IBAction func guestBtn(_ sender: Any) {
        menuLauncher.showMenu(menuList: userList)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        menuLauncher.showMenu(menuList: menuList)
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        itemsInCartTableView.backgroundColor = UIColor.clear
        numberInCartLabel.isHidden = true
        if (currentMember.firstName?.isEmpty)! {
            guestBtn.title = "Hello Guest"
        }
        else {
            guestBtn.title = ("Hello " + currentMember.firstName!)
            guestCartLabel.text = (currentMember.firstName! + "'s Cart")
        }
        
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            self.fetchCartItems()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartItemsTableViewCell
        cell.backgroundColor = UIColor.clear
        let item: MemberCartItem = cartItems[indexPath.row]
        cell.itemName.text = item.name
        cell.itemQuantity.text = "x " + String(describing: item.quantity!)
        cell.itemImg.image = item.itemImage
        let costString = NSString(format: "%.2f", item.cost!)
        cell.costLabel.text = ("$" + (costString as String))
        return cell
    }
    
    func fetchCartItems(){
        self.cartItems.removeAll()
        self.total = 0
        var cartRef: FIRDatabaseReference!
        let memberEmail: String = currentMember.email!.replacingOccurrences(of: ".", with: "Dot")
        cartRef = FIRDatabase.database().reference()
        cartRef?.child("memberList").child(memberEmail).child("cartItems").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                self.numberInCartLabel.isHidden = false
            }
            else {
                for child in snapshot.children {
                    let cartItem: MemberCartItem = MemberCartItem()
                    let snap = child as! FIRDataSnapshot
                    
                    let data = snap.value as! [String: AnyObject]
                    
                    cartItem.name = data["name"] as! String?
                    cartItem.quantity = data["quantity"] as! Int?
                    cartItem.cost = data["cost"] as! Float?
                    cartItem.cartImageUrl = data["itemImgUrl"] as! String?
                    
                    if let cartImgUrl = cartItem.cartImageUrl {
                        let url = URL(string: cartImgUrl)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            DispatchQueue.main.async(execute: { 
                                cartItem.itemImage = UIImage(data: data!)
                                self.cartItems.append(cartItem)
                                self.total = self.total + cartItem.cost!
                                self.itemsInCartTableView.reloadData()
                                let totalString = NSString(format: "%.2f", self.total)
                                self.totalCost.text = ("$" + (totalString as String))
                            })
                        }).resume()
                    }
                }
            }
        })
    }
}
