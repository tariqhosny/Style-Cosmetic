//
//  imagesCell.swift
//  Style Cosmetics
//
//  Created by Tariq on 10/9/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class imagesCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var productImage: UIImageView!
    
    func configureCell(image: String) {
        let urlWithoutEncoding = ("\(URLs.file_root)\(image)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scroll.delegate = self
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 3.5
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return productImage
    }
    
}
