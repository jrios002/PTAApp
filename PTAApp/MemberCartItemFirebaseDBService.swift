//
//  MemberCartItemFirebaseDBService.swift
//  PTAApp
//
//  Created by Jacob Rios on 12/7/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import Firebase

class MemberCartItemFirebaseDBService: MemberCartItemFirebaseSvc {
    var memberCartItems = [ItemForSale]()
    var memberCartRef: FIRDatabaseReference!
    
    init(){
        
    }
    
    func create(_ classType: ItemForSale, member: Member, quantity: Int, cost: Float) {
        memberCartRef = FIRDatabase.database().reference()
        
        let memberEmail: String = member.email!.replacingOccurrences(of: ".", with: "Dot")
        
        memberCartRef.child("memberList").child(memberEmail).child("cartItems").child(classType.name!).child("name").setValue(classType.name)
        memberCartRef.child("memberList").child(memberEmail).child("cartItems").child(classType.name!).child("quantity").setValue(quantity)
        memberCartRef.child("memberList").child(memberEmail).child("cartItems").child(classType.name!).child("cost").setValue(cost)
        memberCartRef.child("memberList").child(memberEmail).child("cartItems").child(classType.name!).child("itemImgUrl").setValue(classType.itemImageUrl)
    }
    
    func retrieveAll() -> [ItemForSale] {
        
        return memberCartItems
    }
    
    func update(_ classType: ItemForSale, _ oldClasstype: ItemForSale, member: Member, quantity: Int, cost: Float) {
        delete(oldClasstype, member: member)
        create(classType, member: member, quantity: quantity, cost: cost)
    }
    
    func delete(_ classType: ItemForSale, member: Member) {
        let memberEmail: String = member.email!.replacingOccurrences(of: ".", with: "Dot")
        memberCartRef = FIRDatabase.database().reference()
        let ref = memberCartRef.child("memberList").child(memberEmail).child("cartItems").child(classType.name!)
        ref.removeValue { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
            message = "SUCCESS"
        }
    }
    
    func getCount() -> Int {
        return memberCartItems.count
    }
    
    func getCartItem(_ name: String, member: Member) -> MemberCartItem {
        let cartItem: MemberCartItem = MemberCartItem()
        let memberEmail: String = member.email!.replacingOccurrences(of: ".", with: "Dot")
        memberCartRef = FIRDatabase.database().reference()
        let ref = memberCartRef.child("memberList").child(memberEmail).child("cartItems").child(name)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! [String: AnyObject]
            
            cartItem.name = data["name"] as! String?
            cartItem.cost = data["cost"] as! Float?
            cartItem.cartImageUrl = data["itemImgUrl"] as! String?
            cartItem.quantity = data["quantity"] as! Int?
            
            print("ITEM SUCCESS")
        })
        
        return cartItem
    }
    
    func retrieveMessage() -> String {
        print("\(itemForSaleMessage)")
        return itemForSaleMessage
    }
}
