//
//  MyOrdersDetailsCell.swift
//  Style Cosmetics
//
//  Created by user on 7/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class MyOrdersDetailsCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var titlePrice: UILabel!
    
    var rate: (()->())?

    func configureCell(orderDetails: productsModel) {
        itemTitle.text = orderDetails.productQuantity + "  " + orderDetails.productName
        titlePrice.text = orderDetails.productPrice
    }
    
    @IBAction func rateBtn(_ sender: Any) {
        rate?()
    }
}
