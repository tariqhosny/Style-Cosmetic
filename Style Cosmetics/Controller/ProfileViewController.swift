//
//  ProfileViewController.swift
//  Style Cosmetics
//
//  Created by user on 7/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var profile = [productsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        profileHandleRefresh()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileHandleRefresh()
    }
    
    @objc fileprivate func profileHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        profileApi.profileApi { (error: Error?, profile: [productsModel]?) in
            if let profileData = profile{
                self.profile = profileData
                self.fullName.text = self.profile[0].customerName
                self.phoneNumber.text = self.profile[0].customerPhone
                self.email.text = self.profile[0].customerEmail
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func fullNameBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Edit Full Name", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {
            $0.text = self.fullName.text
            $0.placeholder = NSLocalizedString("Change Full Name", comment: "")
            $0.textAlignment = .left
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else {return}
            profileApi.updateProfileApi(name: title, email: "", phone: "", password: "", completion: { (error: Error?, message: String?) in
                self.fullName.text = title
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func phoneNumberBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Edit Phone Number", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {
            $0.text = self.phoneNumber.text
            $0.placeholder = NSLocalizedString("Change Phone Number", comment: "")
            $0.textAlignment = .left
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else {return}
            profileApi.updateProfileApi(name: "", email: "", phone: title, password: "", completion: { (error: Error?, message: String?) in
                self.phoneNumber.text = title
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func emailBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Edit Email", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {
            $0.text = self.email.text
            $0.placeholder = NSLocalizedString("Change Email", comment: "")
            $0.textAlignment = .left
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else {return}
            profileApi.updateProfileApi(name: "", email: title, phone: "", password: "", completion: { (error: Error?, message: String?) in
                self.email.text = title
            })
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func passwordBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Edit Password", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {
            $0.isSecureTextEntry = true
            $0.placeholder = NSLocalizedString("Change Password", comment: "")
            $0.textAlignment = .left
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else {return}
            profileApi.updateProfileApi(name: "", email: "", phone: "", password: title, completion: { (error: Error?, message: String?) in
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
