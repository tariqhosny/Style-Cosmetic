//
//  ProductsCategory.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class Products: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [productsModel]()
    var id = Int()
    var catId = Int()
    var brandId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Products", comment: "")
        
        categoriesHandleRefresh(url: URLs.categories)
    }
    
    @IBAction func segmentedSelected(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            categoriesHandleRefresh(url: URLs.categories)
        case 1:
            categoriesHandleRefresh(url: URLs.brands)
        default:
            print("AnyThing")
        }
    }
    
    @objc fileprivate func categoriesHandleRefresh(url: String) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productsApi.catigoriesApi(url: url) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.products = products
                print(self.products)
                self.collectionView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? ProductCategoryDetails{
            destenation.catId = self.catId
            destenation.brandId = self.brandId
        }
    }
}

extension Products: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let productData = products[indexPath.item]
        cell.configureCell(product: productData)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.id = products[indexPath.item].id
        print("id = \(id)")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            catId = id
            brandId = Int("") ?? 0
        case 1:
            catId = Int("") ?? 0
            brandId = id
        default:
            print("AnyThing")
        }
        performSegue(withIdentifier: "productSegue", sender: products[indexPath.item])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        
        var width = (screenWidth-30)/2
        
        width = width < 130 ? 160 : width
        
        return CGSize.init(width: width, height: 140)
    }
}

