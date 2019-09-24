//
//  Home.swift
//  Style Cosmetics
//
//  Created by user on 6/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var slider = [sliderModel]()
    var latestProduct = [productsModel]()
    var featureProduct = [productsModel]()
    var cart = [productsModel]()
    var productShortDescription = String()
    var productDescription = String()
    var productPrice = String()
    var productGeneralPrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var rate = Double()
    var timer = Timer()
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        
        cartCounter()
        latestHandleRefresh()
        sliderHandleRefresh()
        featureHandleRefresh()
        startTimer()
        
        // Clear the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.title = ""
        
        serviceCollectionView.dataSource = self
        serviceCollectionView.delegate = self
        
        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartCounter()
        sliderHandleRefresh()
        latestHandleRefresh()
        featureHandleRefresh()
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func startTimer(){
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }

    @objc fileprivate func sliderHandleRefresh() {
        homeApi.sliderPhotos { (error: Error?, photos:[sliderModel]?) in
            if let photos = photos {
                self.slider = photos
                self.pageControl.numberOfPages = self.slider.count
                self.pageControl.currentPage = 0
                self.topCollectionView.reloadData()
            }
        }
    }
    
    
    @objc func changeImage() {
        
        if counter < slider.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
        
    }
    
    @objc fileprivate func latestHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        homeApi.latestProducts { (error: Error?, photo: [productsModel]?) in
            if let photos = photo {
                self.latestProduct = photos
                self.serviceCollectionView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            self.addBadge()
        }
    }
    
    @objc fileprivate func featureHandleRefresh() {
        homeApi.featuredProducts { (error: Error?, photo: [productsModel]?) in
            if let photos = photo {
                self.featureProduct = photos
                self.productCollectionView.reloadData()
            }
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
    
    
    @IBAction func cartBtn(_ sender: Any) {
        if helper.getUserToken() != nil {
            self.performSegue(withIdentifier: "cart", sender: nil)
        }else{
            let alert = UIAlertController(title: NSLocalizedString("Please Login First", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Login", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
                helper.restartApp()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func cartCounter(){
        cartApi.cartCountApi { (error: Error?, cartData: [productsModel]?) in
            if let cartCounter = cartData{
                self.cart = cartCounter
                print("caaarrrt: \(self.cart.count)")
            }
        }
    }
    
    func addBadge() {
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        bagButton.setImage(UIImage(named: "cart"), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = "\(cart.count)"
        bagButton.addTarget(self, action: #selector(self.cartTaped), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bagButton)
    }
    
    @objc func cartTaped(){
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
    @IBAction func firstViewBtn(_ sender: Any) {
        
    }
    
    @IBAction func secondViewBtn(_ sender: Any) {
    }
    
    
    
}
extension Home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topCollectionView{
            return slider.count
        } else if collectionView == self.serviceCollectionView{
            return latestProduct.count
        }else {
            return featureProduct.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.serviceCollectionView{
            if let serviceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeServicesCell", for: indexPath) as? HomeServicesCell{
                let latestData = latestProduct[indexPath.item]
                serviceCell.configureCell(latest: latestData)
                return serviceCell
            }else{
                return HomeServicesCell()
            }
        }
        else if collectionView == self.productCollectionView{
            
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductsCell", for: indexPath) as? HomeProductsCell{
                let featureData = featureProduct[indexPath.item]
                productCell.configureCell(featured: featureData)
                return productCell
            }else{
                return HomeProductsCell()
            }
        }
        else{
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopCollectionViewCell", for: indexPath) as! HomeTopCollectionViewCell
            
            let sliderImg = slider[indexPath.item]
            topCell.configureCell(slider: sliderImg)
            
            return topCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.serviceCollectionView{
            self.productDescription = latestProduct[indexPath.item].shortDescription
            self.productShortDescription = latestProduct[indexPath.item].productDescription
            self.productGeneralPrice = latestProduct[indexPath.item].price
            self.productPrice = latestProduct[indexPath.item].salePrice
            self.productTitle = latestProduct[indexPath.item].title
            self.productID = latestProduct[indexPath.item].id
            self.isFavorite = latestProduct[indexPath.item].isFavorite
            self.rate = latestProduct[indexPath.item].rateAvrg
            performSegue(withIdentifier: "goToSingleCell", sender: latestProduct[indexPath.item])
        }
        if collectionView == self.productCollectionView{
            self.productDescription = featureProduct[indexPath.item].shortDescription
            self.productShortDescription = featureProduct[indexPath.item].productDescription
            self.productGeneralPrice = featureProduct[indexPath.item].price
            self.productPrice = featureProduct[indexPath.item].salePrice
            self.productTitle = featureProduct[indexPath.item].title
            self.productID = featureProduct[indexPath.item].id
            self.isFavorite = featureProduct[indexPath.item].isFavorite
            self.rate = featureProduct[indexPath.item].rateAvrg
            performSegue(withIdentifier: "goToSingleCell", sender: featureProduct[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 2{
            let screenWidth = collectionView.frame.width
            var width = (screenWidth-20)/2
            width = width < 130 ? 160 : width
            return CGSize.init(width: width, height: width)
        }else if collectionView.tag == 0{
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.height)
        }else {
            return CGSize.init(width: collectionView.frame.size.width / 2.5, height: collectionView.frame.height)
        }
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.tag == 0{
//        currentIndex = Int(scrollView.contentOffset.x / topCollectionView.frame.size.width)
//        pageControl.currentPage = currentIndex
//        }
//    }
    
}
