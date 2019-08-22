//
//  JSON.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON{
    
    var toImagePath: String?{
        guard let string = self.string, !string.isEmpty else { return nil }
        return URLs.file_root + string
    }
}
