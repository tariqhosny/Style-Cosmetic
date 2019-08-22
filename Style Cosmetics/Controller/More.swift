//
//  More.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import MOLH

class More: UIViewController {

    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        guestOrUser()
        // Do any additional setup after loading the view.
    }
    
    func guestOrUser() {
        if helper.getUserToken() == nil{
            self.profileBtn.isHidden = true
            self.favoriteBtn.isHidden = true
            self.logoutBtn.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        }
    }
    
    @IBAction func profile(_ sender: UIButton) {
    }
    
    @IBAction func favorite(_ sender: UIButton) {
    }
    
    @IBAction func language(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Select Language", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "עברית", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("he")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: "English", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("en")
            MOLH.reset()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let defUser = UserDefaults.standard
        defUser.removeObject(forKey: "user_token")
        
        helper.restartApp()
    }
    
}
