//
//  ViewController.swift
//  Style Cosmetics
//
//  Created by user on 6/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Login: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text else {return}
        if (email.isEmpty == true || password.isEmpty == true){
            self.displayErrors(errorText: NSLocalizedString("Empty Fields", comment: ""))
        }else {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            API.login(email: email, password: password) { (error: Error?, success: Bool) in
                if success == true {
                   print("login successfully")
                }else{
                    self.displayErrors(errorText: NSLocalizedString("Email or Password incorrect", comment: ""))
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    func displayErrors (errorText: String){
        let alert = UIAlertController.init(title: NSLocalizedString("Message", comment: ""), message: errorText, preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension Login {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
