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
    
    var slider = [sliderModel]()
    var latestProduct = [productsModel]()
    var featureProduct = [productsModel]()
    var productDescription = String()
    var productShortDescription = String()
    var productPrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var rate = Double()
    var currentIndex = 0
    var timer : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderHandleRefresh()
        latestHandleRefresh()
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
        sliderHandleRefresh()
        latestHandleRefresh()
        featureHandleRefresh()
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    func startTimer(){
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerAction(){
        
        let desiredScrollPosition = (currentIndex < slider.count - 1) ? currentIndex + 1 : 0
        topCollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
        
//        if currentIndex < slider.count {
//            let index = IndexPath.init(item: currentIndex, section: 0)
//            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            pageControl.currentPage = currentIndex
//            currentIndex += 1
//        } else {
//            currentIndex = 0
//            let index = IndexPath.init(item: currentIndex, section: 0)
//            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//            pageControl.currentPage = currentIndex
//            currentIndex = 1
//        }
    }

    @objc fileprivate func sliderHandleRefresh() {
        homeApi.sliderPhotos { (error: Error?, photos:[sliderModel]?) in
            if let photos = photos {
                self.slider = photos
                self.pageControl.numberOfPages = self.slider.count
                self.topCollectionView.reloadData()
            }
        }
    }
    
    @objc fileprivate func latestHandleRefresh() {
        homeApi.latestProducts { (error: Error?, photo: [productsModel]?) in
            if let photos = photo {
                self.latestProduct = photos
                self.serviceCollectionView.reloadData()
            }
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
            self.productPrice = latestProduct[indexPath.item].price
            self.productTitle = latestProduct[indexPath.item].title
            self.productID = latestProduct[indexPath.item].id
            self.isFavorite = latestProduct[indexPath.item].isFavorite
            self.rate = latestProduct[indexPath.item].rateAvrg
            performSegue(withIdentifier: "goToSingleCell", sender: latestProduct[indexPath.item])
        }
        if collectionView == self.productCollectionView{
            self.productDescription = featureProduct[indexPath.item].shortDescription
            self.productShortDescription = featureProduct[indexPath.item].productDescription
            self.productPrice = featureProduct[indexPath.item].price
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0{
        currentIndex = Int(scrollView.contentOffset.x / topCollectionView.frame.size.width)
        pageControl.currentPage = currentIndex
        }
    }
    
}
