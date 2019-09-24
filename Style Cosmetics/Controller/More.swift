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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
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
        alert.addAction(UIAlertAction(title: "English", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("en")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: "עברית", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("he")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: "عربى", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("ar")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        if self.logoutBtn.currentTitle == "Log Out"{
            let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to log out?", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (action: UIAlertAction) in
                let defUser = UserDefaults.standard
                defUser.removeObject(forKey: "user_token")
                helper.restartApp()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            helper.restartApp()
        }
    }
    
}
