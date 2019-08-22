//
//  ProductCategoryDetails.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ProductCategoryDetails: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [productsModel]()
    var catId = Int()
    var brandId = Int()
    var productDescription = String()
    var productShortDescription = String()
    var productPrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var rate = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsHandleRefresh()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        productsHandleRefresh()
    }
    
    @objc fileprivate func productsHandleRefresh() {
        productsApi.productApi(catID: catId, brandID: brandId) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.products = products
                self.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? SingleProductDetail{
            destenation.productDescription = self.productDescription
            destenation.productShortDescription = self.productShortDescription
            destenation.productPrice = self.productPrice
            destenation.productTitle = self.productTitle
            destenation.productID = self.productID
            destenation.isFavorite = self.isFavorite
            destenation.rate = self.rate
        }
    }
}

extension ProductCategoryDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryDetailsCell", for: indexPath) as! ProductCategoryDetailsCell
        let productData = products[indexPath.item]
        cell.configureCell(product: productData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productDescription = products[indexPath.item].shortDescription
        self.productShortDescription = products[indexPath.item].productDescription
        self.productPrice = products[indexPath.item].price
        self.productTitle = products[indexPath.item].title
        self.productID = products[indexPath.item].id
        self.isFavorite = products[indexPath.item].isFavorite
        self.rate = products[indexPath.item].rateAvrg
        performSegue(withIdentifier: "SingleProductCell", sender: products[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        
        var width = (screenWidth-30)/2
        
        width = width < 130 ? 160 : width
        
        return CGSize.init(width: width, height: width)
    }
}
