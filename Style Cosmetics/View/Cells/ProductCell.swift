//
//  ProductCell.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    func configureCell(product: productsModel) {
        productName.text = product.title
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImg.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImg.kf.setImage(with: url)
        }
    }
    
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
}
