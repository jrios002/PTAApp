//
//  MemberCartItem.swift
//  PTAApp
//
//  Created by Jacob Rios on 12/10/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import UIKit

class MemberCartItem{
    var name: String?
    var cost: Float?
    var quantity: Int?
    var itemImage: UIImage?
    var cartImageUrl: String?
    
    init() {
        name = ""
        cost = 0
        quantity = 0
        cartImageUrl = ""
    }
    
    func GetDescription() -> String {
        return name! + "::" + cartImageUrl! + "::" + "\(quantity)" + "::" + "\(cost)"
    }
}
