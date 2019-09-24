//
//  SingleProductDetail.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Cosmos

class SingleProductDetail: UIViewController {
    
    var productImages = [productsModel]()
    var productColors = [productsModel]()
    var rateComments = [productsModel]()
    var productDescription = String()
    var productShortDescription = String()
    var productPrice = String()
    var productGeneralPrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var colorID = Int()
    var rate = Double()

    @IBOutlet weak var productRAte: CosmosView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var generalPrice: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var favoriteOutlet: UIButton!
    @IBOutlet weak var reviewsCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        productRAte.settings.updateOnTouch = false
        productRAte.settings.fillMode = .precise
        
        productRAte.rating = self.rate
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationItem.title = productTitle
        
        self.descriptionLbl.text = productShortDescription
        self.shortDescription.text = productTitle
        self.priceLbl.text = productPrice
        self.generalPrice.text = productGeneralPrice
        
        
        if isFavorite == 1{
            favoriteOutlet.setImage(UIImage(named: "selecyedFavorite"), for: .normal)
        }else{
            favoriteOutlet.setImage(UIImage(named: "favorite"), for: .normal)
        }
        
        imagesHandleRefresh()
        colorsHandleRefresh()
        commentsHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.colorCollectionView.reloadData()
    }
    
    @objc fileprivate func commentsHandleRefresh() {
        rateApi.orderListApi(productID: productID) { (error: Error?, comment: [productsModel]?) in
            if let comments = comment {
                self.rateComments = comments
                self.reviewsCount.text = "\(self.rateComments.count)  " + NSLocalizedString("Reviews", comment: "")
                self.tableView.reloadData()
            }
        }
    }
    
    @objc fileprivate func imagesHandleRefresh() {
        productsApi.productImagesApi(id: productID) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.productImages = products
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc fileprivate func colorsHandleRefresh() {
        productsApi.productColorsApi(id: productID) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.productColors = products
                self.colorCollectionView.reloadData()
            }
        }
    }
    @IBAction func addToCart(_ sender: UIButton) {
        
        if helper.getUserToken() != nil {
            if self.colorID == 0{
                let alert = UIAlertController(title: NSLocalizedString("Please Select Color", comment: ""), message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                cartApi.addCartApi(id: productID, color_id: colorID) { (error: Error?, success: Bool?) in
                    if success!{
                        self.performSegue(withIdentifier: "addToCart", sender: nil)
                    }else{
                        let alert = UIAlertController(title: NSLocalizedString("Please Login First", comment: ""), message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Login", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
                            //self.performSegue(withIdentifier: "login", sender: nil) //segue not found
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        print("\(error ?? "" as! Error)")
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }else{
            let alert = UIAlertController(title: NSLocalizedString("Please Login First", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Login", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
                helper.restartApp()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func favoriteBtn(_ sender: UIButton) {
        if helper.getUserToken() != nil {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            favoriteApi.setFavoriteApi(product_id: productID) { (error: Error?, status: Bool?, errorString: String?) in
                if status == true{
                    if self.isFavorite == 0{
                        self.isFavorite = 1
                        self.favoriteOutlet.setImage(UIImage(named: "selecyedFavorite"), for: .normal)
                    }else{
                        self.isFavorite = 0
                        self.favoriteOutlet.setImage(UIImage(named: "favorite"), for: .normal)
                    }
                }else{
                    print("\(error ?? "" as! Error)")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }else{
            let alert = UIAlertController(title: NSLocalizedString("Please Login First", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Login", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
                helper.restartApp()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    var selectedRow = -1
    
}
extension SingleProductDetail : UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rateComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleProductDetailCell", for: indexPath) as! singleProductDetailsCell
        let comments = rateComments[indexPath.row]
        cell.configureCell(comment: comments)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return productImages.count
        }
        else{
            return productColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleProductDetailsCollectionViewCell", for: indexPath) as! singleProductDetailsCollectionViewCell
            let productData = productImages[indexPath.item]
            cell.configureCell(product: productData)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productColorCell", for: indexPath) as! productColorCell
            let productData = productColors[indexPath.item]
            if selectedRow == indexPath.row {
                cell.colorView.layer.borderColor = UIColor.gray.cgColor
                cell.colorView.layer.borderWidth = 2
            }
            else {
                cell.layer.borderWidth = 0
            }
            cell.configureCell(product: productData)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.height)
        }else {
            return CGSize.init(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.colorID = productColors[indexPath.item].colorID
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == colorCollectionView{
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
                let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
                dataSourceCount > 0 else {
                    return .zero
            }

            let cellCount = CGFloat(dataSourceCount)
            let itemSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = flowLayout.itemSize.width + itemSpacing
            var insets = flowLayout.sectionInset
            
            let totalCellWidth = (cellWidth * cellCount) - itemSpacing
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            guard totalCellWidth < contentWidth else {
                return insets
            }

            let padding = (contentWidth - totalCellWidth) / 2.0
            insets.left = padding
            insets.right = padding
            return insets
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

