//
//  ProductCategoryDetailsCell.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ProductCategoryDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var productDetailImg: UIImageView!
    @IBOutlet weak var productDetailDes: UILabel!
    @IBOutlet weak var productDetailPrice: UILabel!
    
    func configureCell(product: productsModel) {
        productDetailDes.text = product.title
        productDetailPrice.text = product.price
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productDetailImg.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productDetailImg.kf.setImage(with: url)
        }
    }
}
