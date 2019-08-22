//
//  latestProductsCell.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class latestProductsCell: UICollectionViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    func configureCell(product: productsModel) {
        productTitle.text = product.title
        productPrice.text = product.price
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImg.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImg.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
    }
}
