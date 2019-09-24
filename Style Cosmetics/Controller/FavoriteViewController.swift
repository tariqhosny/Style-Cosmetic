//
//  FavoriteViewController.swift
//  Style Cosmetics
//
//  Created by user on 7/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var products = [productsModel]()
    var productDescription = String()
    var productShortDescription = String()
    var productPrice = String()
    var productGeneralPrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = 1
    var rate = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        activityIndicator.isHidden = true
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = " "
        
        categoriesHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.products.removeAll()
        categoriesHandleRefresh()
    }
    
    @objc fileprivate func categoriesHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        favoriteApi.favoriteListApi { (error: Error?, product: [productsModel]?) in
            //let products = product
            self.products = product ?? []
            self.collectionView.reloadData()
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? SingleProductDetail{
            destenation.productDescription = self.productDescription
            destenation.productShortDescription = self.productShortDescription
            destenation.productPrice = self.productPrice
            destenation.productGeneralPrice = self.productGeneralPrice
            destenation.productTitle = self.productTitle
            destenation.productID = self.productID
            destenation.isFavorite = self.isFavorite
            destenation.rate = self.rate
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let productData = products[indexPath.item]
        cell.configureCell(product: productData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productDescription = products[indexPath.item].shortDescription
        self.productShortDescription = products[indexPath.item].productDescription
        self.productPrice = products[indexPath.item].price
        self.productGeneralPrice = products[indexPath.item].salePrice
        self.productTitle = products[indexPath.item].productName1
        self.productID = Int(products[indexPath.item].productID1) ?? 0
        self.rate = products[indexPath.item].rateAvrg
        performSegue(withIdentifier: "showDetails", sender: products[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        
        var width = (screenWidth-30)/2
        
        width = width < 130 ? 170 : width
        
        return CGSize.init(width: width, height: 245)
    }
}
