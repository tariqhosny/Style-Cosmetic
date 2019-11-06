//
//  MyOrders.swift
//  Style Cosmetics
//
//  Created by user on 6/26/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class MyOrders: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var products = [productsModel]()
    var orderPrice = String()
    var orderID = Int()
    var deleveryFees = String()
    var taxs = Int()
    var orderState = String()
    var address = String()
    var paymentMethod = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        activityIndicator.isHidden = true
        
        OrderListHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("My Orders", comment: "")
        
        OrderListHandleRefresh()
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc fileprivate func OrderListHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.products.removeAll()
        orderApi.orderListApi { (error: Error?, orderList: [productsModel]?) in
            if let products = orderList {
                self.products = products
                self.tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? MyOrdersDetail{
            destenation.orderPrice = self.orderPrice
            destenation.orderID = self.orderID
            destenation.deleveryFees = self.deleveryFees
            destenation.taxs = self.taxs
            destenation.orderState = self.orderState
            destenation.address = self.address
            destenation.paymentMethod = self.paymentMethod
        }
    }
}

extension MyOrders : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersCell", for: indexPath) as! MyOrdersCell
        let productData = products[indexPath.row]
        cell.configureCell(orderList: productData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderPrice = products[indexPath.item].orderPrice
        self.orderID = products[indexPath.item].orderID
        self.deleveryFees = products[indexPath.item].deleveryFees
        self.taxs = products[indexPath.item].taxs
        self.address = "\(products[indexPath.item].country), \(products[indexPath.item].city), \(products[indexPath.item].address), \(products[indexPath.item].street)"
        
        if Int(products[indexPath.item].orderState) == 0{
            self.orderState = NSLocalizedString("Order in Progress", comment: "")
        }
        if Int(products[indexPath.item].orderState) == 1{
            self.orderState = NSLocalizedString("Order Delivered", comment: "")
        }
        if Int(products[indexPath.item].orderState) == 2{
            self.orderState = NSLocalizedString("Order Canceled", comment: "")
        }
        
        if Int(products[indexPath.item].payment_method) == 1{
            self.paymentMethod = "Payment Online".localized
        }
        if Int(products[indexPath.item].payment_method) == 2{
            self.paymentMethod = "Cash on Delivered".localized
        }
        performSegue(withIdentifier: "segue", sender: nil)
    }
}
