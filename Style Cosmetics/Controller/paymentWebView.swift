//
//  paymentWebView.swift
//  Mona
//
//  Created by Tariq on 11/3/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import WebKit

class paymentWebView: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var paymentWeb: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentURL = String()
    var totalPrice = Int()
    var phone = String()
    var address = String()
    var notes = String()
    var city = String()
    var country = String()
    var street = String()
    var lat = Float()
    var lang = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.paymentWeb.load(URLRequest(url: URL(string: "https://direct.tranzila.com/georgetest/iframenew.php?sum=\(totalPrice)&currency=1&cred_type=1&nologo=1&tranmode=AK")!))
        self.activityIndicator.isHidden = true
        paymentWeb.navigationDelegate = self
        paymentWeb.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            self.currentURL = "\(newValue)"
            if self.currentURL == "https://e-bakers.org/About-Us"{
                self.paymentWeb.stopLoading()
                self.paymentWeb.isHidden = true
                orderApi.createOrderApi(totalPrice: self.totalPrice, phone: self.phone, address: self.address, notes: self.notes, city: self.city, country: self.country, street: self.street, latidude: self.lat, langitude: self.lang, method: 1, completion: { (error: Error?, success: Bool?) in
                    if success == true{
                        let alert = UIAlertController(title: "Congratulation!".localized, message: "Your order done".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: { (action: UIAlertAction) in
                            helper.restartApp()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
            if self.currentURL == "https://e-bakers.org/Contact-Us"{
                self.paymentWeb.stopLoading()
                self.paymentWeb.isHidden = true
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                let alert = UIAlertController(title: "Error".localized, message: "payment Failed".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: { (action: UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            print("url changed: \(newValue)")
        }
    }
    
}
