//
//  FavoriteCell.swift
//  Style Cosmetics
//
//  Created by user on 7/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    
    func configureCell(product: productsModel) {
        productName.text = product.productName1
        unitPrice.text = NSLocalizedString("Price:", comment: "") + " \(product.price)"
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        favoriteImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            favoriteImage.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
    }
}
