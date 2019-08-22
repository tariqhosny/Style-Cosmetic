//
//  singleProductDetailsCell.swift
//  Style Cosmetics
//
//  Created by Tariq M.fathy on 7/17/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Cosmos

class singleProductDetailsCell: UITableViewCell {

    @IBOutlet weak var commentRates: CosmosView!
    @IBOutlet weak var userDescreption: UILabel!
    @IBOutlet weak var username: UILabel!
    
    func configureCell(comment: productsModel) {
        commentRates.rating = Double(comment.rateRange) ?? 0.0
        userDescreption.text = comment.rateComment
        username.text = comment.username
    }
    
    override func awakeFromNib() {
        commentRates.settings.updateOnTouch = false
    }
}
