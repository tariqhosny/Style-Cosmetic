//
//  CartCell.swift
//  Style Cosmetics
//
//  Created by user on 7/2/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var plus: (()->())?
    var min: (()->())?
    var delete: (()->())?
    
    func configureCell(product: productsModel) {
        self.colorView.backgroundColor = hexStringToUIColor(hex: product.color)
        productTitle.text = product.productName
        totalPrice.text = "\(product.totalUnitPrice)"
        unitPrice.text = product.unitPrice
        counter.text = product.counter
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }

    @IBAction func plusBtn(_ sender: UIButton) {
        plus?()
    }
    
    @IBAction func minBtn(_ sender: UIButton) {
        min?()
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delete?()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF,
            blue: CGFloat(rgbValue & 0x0000FF) / 0xFF,
            alpha: CGFloat(1.0)
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
}
