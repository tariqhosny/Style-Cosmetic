//
//  MyOrdersDetail.swift
//  Style Cosmetics
//
//  Created by user on 6/26/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class MyOrdersDetail: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var paymentState: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var taxsLb: UILabel!
    @IBOutlet weak var deleveryFeesLb: UILabel!
    
    var products = [productsModel]()
    var orderPrice = String()
    var orderID = Int()
    var deleveryFees = String()
    var taxs = Int()
    var orderState = String()
    var address = String()
    var productID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = " "
        
        OrderDetailsHandleRefresh()
        
        self.customerAddress.text = address
        self.paymentState.text = NSLocalizedString("Cash on Delivered", comment: "")
        self.totalPrice.text = NSLocalizedString("Total Price:", comment: "") + " $" + orderPrice
        self.taxsLb.text = NSLocalizedString("Taxes:", comment: "") + " $\(taxs)"
        self.deleveryFeesLb.text = NSLocalizedString("Delivery Fees:", comment: "") + " $" + deleveryFees
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc fileprivate func OrderDetailsHandleRefresh() {
        orderApi.orderDetailsApi(orderID: self.orderID) { (error: Error?, orderDetails: [productsModel]?) in
            if let products = orderDetails {
                self.products = products
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? myOrdersRate{
            destenation.productID = self.productID
        }
    }
}


extension MyOrdersDetail : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersDetailsCell", for: indexPath) as! MyOrdersDetailsCell
        let productData = products[indexPath.row]
        cell.configureCell(orderDetails: productData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.productID = Int(products[indexPath.row].productID1) ?? 0
        self.performSegue(withIdentifier: "rate", sender: nil)
    }
}
