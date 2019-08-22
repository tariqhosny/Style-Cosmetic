//
//  sliderModel.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SwiftyJSON

class sliderModel: NSObject {
    
    var photo: String
    
    init?(dict:[String: JSON]){
        guard let photo = dict["image"]?.string, !photo.isEmpty else {return nil}
        self.photo = photo
    }
}

