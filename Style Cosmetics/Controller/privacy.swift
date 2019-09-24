//
//  privacy.swift
//  Style Cosmetics
//
//  Created by Tariq on 9/18/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class privacy: UIViewController {

    @IBOutlet weak var privacy: UILabel!
    
    var policies = [productsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        privacyHandleRefresh()
    }

    @objc fileprivate func privacyHandleRefresh() {
        profileApi.privacyApi { (error: Error?, privacy: [productsModel]?) in
            if let privacies = privacy{
                self.policies = privacies
                self.privacy.text = self.policies[0].productDescription
            }
        }
    }
    
}
