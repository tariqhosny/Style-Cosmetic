//
//  Cart.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class Cart: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var taxs: UILabel!
    @IBOutlet weak var deleveryFees: UILabel!
    
    var products = [productsModel]()
    var cartID = Int()
    var price = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true

        tableView.dataSource = self
        tableView.delegate = self
        
        cartHandleRefresh()
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = " "
        
    }
    override func viewDidAppear(_ animated: Bool) {
        cartHandleRefresh()
    }

    @objc fileprivate func cartHandleRefresh() {
        cartApi.listCartApi { (error: Error?, product: [productsModel]?, price, taxs, deleveryFees) in
            if let products = product {
                self.products = products
                self.price = price ?? 0
                self.totalPrice.text = NSLocalizedString("Total Price:", comment: "") + " $\(price ?? 0)"
                self.taxs.text = NSLocalizedString("Taxes:", comment: "") + " $\(taxs ?? 0)"
                self.deleveryFees.text = NSLocalizedString("Delivery Fees:", comment: "") + " $\(deleveryFees ?? "0")"
                self.tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? createOrder{
            destenation.totalPrice = self.price
        }
    }
    
    @IBAction func checkOut(_ sender: UIButton) {
        if products.count != 0{
            performSegue(withIdentifier: "createOrder", sender: nil)
        }
    }
    
}

extension Cart : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let productData = products[indexPath.row]
        print(productData.color)
        cell.plus = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.plusCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("increased")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        cell.min = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.minCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("decreased")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        cell.delete = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.deleteCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("deleted")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
            if self.products.count == 1 {
                self.products.removeAll()
                self.totalPrice.text = NSLocalizedString("Total Price: ", comment: "") + " $0"
                self.taxs.text = NSLocalizedString("Taxes: ", comment: "") + " $0"
                self.deleveryFees.text = NSLocalizedString("Delivery Fees: ", comment: "") + " $0"
                self.tableView.reloadData()
            }
        }
        cell.configureCell(product: productData)
        return cell
    }

}
