//
//  ItemForSaleFirebaseDBService.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/13/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import Firebase

var itemForSaleMessage = ""

class ItemForSaleFirebaseDBService: IItemsForSaleFirebaseSvc {
    var itemsForSale = [ItemForSale]()
    var itemForSaleRef: FIRDatabaseReference!
    var itemForSaleStorageRef: FIRStorageReference!
    
    init(){
        
    }
    
    func create(_ classType: ItemForSale, school: School) {
        itemForSaleRef = FIRDatabase.database().reference()
        
        let schoolNameChild: String = (school.name?.lowercased())!
        let imageName = NSUUID().uuidString
        
        itemForSaleStorageRef = FIRStorage.storage().reference(withPath: "images/itemImages/" + imageName + ".png")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/png"
        
        itemForSaleRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("ItemsList").child(classType.name!).child("name").setValue(classType.name)
        itemForSaleRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("ItemsList").child(classType.name!).child("cost").setValue(classType.cost)
        itemForSaleRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("ItemsList").child(classType.name!).child("description").setValue(classType.description!)
        
        if classType.itemImage != nil {
            if let uploadImage = UIImagePNGRepresentation(classType.itemImage!) {
                
                itemForSaleStorageRef.put(uploadImage, metadata: uploadMetadata, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let itemImgUrl = metadata?.downloadURL()?.absoluteString
                    self.itemForSaleRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("ItemsList").child(classType.name!).child("itemImgUrl").setValue(itemImgUrl)
                    print(itemImgUrl!)
                })
            }
        }
    }
    
    func retrieveAll() -> [ItemForSale] {
        
        return itemsForSale
    }
    
    func update(_ classType: ItemForSale, _ oldClasstype: ItemForSale, school: School) {
        delete(oldClasstype, school: school)
        create(classType, school: school)
    }
    
    func delete(_ classType: ItemForSale, school: School) {
        itemForSaleRef = FIRDatabase.database().reference()
        itemForSaleStorageRef = FIRStorage.storage().reference(forURL: classType.itemImageUrl!)
        let schoolNameChild: String = (school.name?.lowercased())!
        let ref = itemForSaleRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("ItemsList").child(classType.name!)
        ref.removeValue { (error, reference) in
            if error != nil {
                print(error!)
                return
            }
            
            message = "SUCCESS"
        }
        
        itemForSaleStorageRef.delete { (error) in
            if error != nil {
                print(error!)
            }
            else {
                message = "SUCCESS"
            }
        }
    }
    
    func getCount() -> Int {
        return itemsForSale.count
    }
    
    func getItemForSale(_ name: String, school: School) -> ItemForSale {
        let item: ItemForSale = ItemForSale()
        let schoolNameChild: String = (school.name?.lowercased())!
        itemForSaleRef = FIRDatabase.database().reference()
        let ref = itemForSaleRef.child("schoolList").child(schoolNameChild + school.zipCode!).child("ItemsList").child(name)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! [String: AnyObject]
            
            item.name = data["name"] as! String?
            item.cost = data["cost"] as! Float?
            item.description = data["description"] as! String?
            item.itemImageUrl = data["itemImgUrl"] as! String?
            
            print("ITEM SUCCESS")
        })
        
        return item
    }
    
    func retrieveMessage() -> String {
        print("\(itemForSaleMessage)")
        return itemForSaleMessage
    }
}
