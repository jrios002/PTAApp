//
//  ItemForSale.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/6/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import Foundation
import UIKit

class ItemForSale{
    var name: String?
    var cost: Float?
    var description: String?
    var itemImage: UIImage?
    var itemImageUrl: String?
    
    init() {
        name = ""
        cost = 0
        description = ""
        itemImageUrl = ""
    }
    
    func GetDescription() -> String {
        return name! + "::" + description! + "::" + itemImageUrl!
    }
}
