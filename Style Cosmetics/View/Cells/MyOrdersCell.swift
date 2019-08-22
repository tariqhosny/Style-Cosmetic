//
//  MyOrdersCell.swift
//  Style Cosmetics
//
//  Created by user on 7/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class MyOrdersCell: UITableViewCell {
    
    @IBOutlet weak var viewContents: UIView!
    @IBOutlet weak var orderImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    func configureCell(orderList: productsModel) {
        titleLbl.text = NSLocalizedString("order:", comment: "") + " \(orderList.orderID)"
        dateLbl.text = orderList.orderDate
        priceLbl.text = orderList.orderPrice
        
        if Int(orderList.orderState) == 0{
            statusLbl.text = NSLocalizedString("Order in Progress", comment: "")
        }
        if Int(orderList.orderState) == 1{
            statusLbl.text = NSLocalizedString("Order Delevered", comment: "")
        }
        if Int(orderList.orderState) == 2{
            statusLbl.text = NSLocalizedString("Order Canceled", comment: "")
        }
    }
    
    override func awakeFromNib() {
        orderImg.layer.cornerRadius = orderImg.frame.width/2
        orderImg.clipsToBounds = true
        viewContents.layer.cornerRadius = 10.0
        viewContents.layer.masksToBounds = true
        viewContents.layer.borderWidth = 0.2
        viewContents.layer.borderColor = UIColor.gray.cgColor
    }
    
}
