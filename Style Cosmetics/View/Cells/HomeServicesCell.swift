//
//  HomeServicesCell.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Kingfisher

class HomeServicesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var serviceImg: UIImageView!
    @IBOutlet weak var serviceLbl: UILabel!

    func configureCell(latest: productsModel) {
        serviceLbl.text = latest.title
        let urlWithoutEncoding = ("\(URLs.file_root)\(latest.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        serviceImg.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            serviceImg.kf.setImage(with: url)
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
