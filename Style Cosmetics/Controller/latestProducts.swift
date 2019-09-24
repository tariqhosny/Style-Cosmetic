//
//  latestProducts.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class latestProducts: UIViewController {
    
    var latestProduct = [productsModel]()
    var productDescription = String()
    var productShortDescription = String()
    var productPrice = String()
    var productGeneralPrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var rate = Double()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Latest Products", comment: "")
        
        collectionView.delegate = self
        collectionView.dataSource = self

        latestHandleRefresh()
        
    }
    @objc fileprivate func latestHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        homeApi.latestProducts { (error: Error?, photo: [productsModel]?) in
            if let photos = photo {
                self.latestProduct = photos
                self.collectionView.reloadData()
            }
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
extension latestProducts: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestProductsCell", for: indexPath) as! latestProductsCell
            let latestData = latestProduct[indexPath.item]
        cell.configureCell(product: latestData)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productDescription = latestProduct[indexPath.item].shortDescription
        self.productShortDescription = latestProduct[indexPath.item].productDescription
        self.productGeneralPrice = latestProduct[indexPath.item].price
        self.productPrice = latestProduct[indexPath.item].salePrice
        self.productTitle = latestProduct[indexPath.item].title
        self.productID = latestProduct[indexPath.item].id
        self.isFavorite = latestProduct[indexPath.item].isFavorite
        self.rate = latestProduct[indexPath.item].rateAvrg
        performSegue(withIdentifier: "SingleProductCell", sender: latestProduct[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        var width = (screenWidth-30)/2
        width = width < 130 ? 160 : width
        return CGSize.init(width: width, height: width)
    }
}
