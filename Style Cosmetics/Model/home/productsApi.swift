//
//  productsApi.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class productsApi: NSObject {

    class func catigoriesApi (url:String,completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "lang": "en"
        ]
        Alamofire.request(url, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func productApi (catID:Int, brandID:Int, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "category_id": catID,
            "brand_id": brandID,
            "lang": "en"
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        Alamofire.request(URLs.products, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)

            case .success(let value):
                let json = JSON(value)
                print(json)

                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    class func productImagesApi (id: Int, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "product_id": id
            ]
        Alamofire.request(URLs.productImages, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func productColorsApi (id: Int, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "product_id": id
        ]
        Alamofire.request(URLs.productColor, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
}
