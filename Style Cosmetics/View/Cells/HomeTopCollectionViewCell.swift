//
//  HomeTopCollectionViewCell.swift
//  Style Cosmetics
//
//  Created by Tariq M.fathy on 7/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class HomeTopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImg: UIImageView!
    
    func configureCell(slider: sliderModel) {
        let urlWithoutEncoding = ("\(URLs.file_root)\(slider.photo)")
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
    }
}
