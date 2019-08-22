//
//  textViewRound.swift
//  Style Cosmetics
//
//  Created by Tariq M.fathy on 7/17/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class textViewRound: UITextView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
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
