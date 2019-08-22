//
//  imageRound.swift
//  Style Cosmetics
//
//  Created by Tariq M.fathy on 7/16/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class imageRound: UIImage {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = self.frame.width/2
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
