//
//  HomeProductsCell.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class HomeProductsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productLbl: UILabel!
    
    func configureCell(featured: productsModel){
        productLbl.text = featured.title
        let urlWithoutEncoding = ("\(URLs.file_root)\(featured.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImg.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImg.kf.setImage(with: url)
        }
    }
    
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.borderWidth = 0.2
        self.contentView.layer.borderColor = UIColor.gray.cgColor
    }
}
