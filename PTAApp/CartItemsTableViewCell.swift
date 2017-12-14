//
//  CartItemsTableViewCell.swift
//  PTAApp
//
//  Created by Jacob Rios on 12/10/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class CartItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
