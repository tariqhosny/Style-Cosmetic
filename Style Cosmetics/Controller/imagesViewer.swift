//
//  imagesViewer.swift
//  Style Cosmetics
//
//  Created by Tariq on 10/9/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class imagesViewer: UIViewController {
    
        @IBOutlet weak var imagesCollectionView: UICollectionView!
        
        var imageGuide = String()
        var images = [productsModel]()
        var productID = Int()
        var selected = Int()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

            imagesCollectionView.delegate = self
            imagesCollectionView.dataSource = self
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        override func viewWillDisappear(_ animated: Bool) {    super.viewWillDisappear(true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        
        @objc fileprivate func imagesHandleRefresh() {
            productsApi.productImagesApi(id: productID) { (error: Error?, product: [productsModel]?) in
                if let products = product {
                    self.images = products
                    self.imagesCollectionView.reloadData()
                }
            }
        }
        
        
        
        @IBAction func close(_ sender: Any) {
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    extension imagesViewer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
            cell.configureCell(image: images[indexPath.item].photo)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.height)
        }
        
    }
