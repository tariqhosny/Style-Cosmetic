//
//  myOrdersRate.swift
//  Style Cosmetics
//
//  Created by user on 7/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Cosmos

class myOrdersRate: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rateRange: CosmosView!
    @IBOutlet weak var rateName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    var productID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if rateRange.rating == 1{
            self.rateName.text = NSLocalizedString("Very Bad", comment: "")
        }
        rateRange.didFinishTouchingCosmos = didFinishTouchingCosmos
        activityIndicator.isHidden = true
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    

    private func didFinishTouchingCosmos(_ rating: Double) {
        if rateRange.rating == 1{
            self.rateName.text = NSLocalizedString("Very Bad", comment: "")
        }else if rateRange.rating == 2{
            self.rateName.text = NSLocalizedString("Bad", comment: "")
        }else if rateRange.rating == 3{
            self.rateName.text = NSLocalizedString("Good", comment: "")
        }else if rateRange.rating == 4{
            self.rateName.text = NSLocalizedString("Very Good", comment: "")
        }else{
            self.rateName.text = NSLocalizedString("Excellent", comment: "")
        }
    }
    
    @IBAction func rateBtn(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        if textView.text != ""{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            rateApi.createRateApi(productID: productID, rateRange: Int(rateRange.rating), rateComment: textView.text ?? "") { (error: Error?, message: String?) in
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("dismiss", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            }
        }else{
            let alert = UIAlertController(title: NSLocalizedString("Please write Comment", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("dismiss", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
}
extension myOrdersRate {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
