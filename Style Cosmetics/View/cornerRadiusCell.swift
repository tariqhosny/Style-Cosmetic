//
//  cornerRadiusCell.swift
//  Style Cosmetics
//
//  Created by Tariq M.fathy on 7/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

func cornerRadiusCell(){
    self.contentView.layer.cornerRadius = 10.0
    self.contentView.layer.borderWidth = 0.0
    self.contentView.layer.borderColor = UIColor.clear.cgColor
    self.contentView.layer.masksToBounds = true
    
    self.layer.shadowColor = UIColor.clear.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    self.layer.shadowRadius = 2.0
    self.layer.shadowOpacity = 0.5
    self.layer.masksToBounds = false
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
}
