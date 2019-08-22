//
//  rateApi.swift
//  Style Cosmetics
//
//  Created by Tariq on 8/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class rateApi: NSObject {

    class func createRateApi (productID: Int, rateRange:Int, rateComment: String, completion: @escaping(_ error: Error?, _ data: String?)-> Void){
        let parametars = [
            "product_id": productID,
            "rate_range": rateRange,
            "rate_comment": rateComment
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken() ?? "")"
        ]
        print(parametars)
        Alamofire.request(URLs.createRate, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].string else {
                    completion(nil, nil)
                    return
                }
                
                completion(nil, data)
            }
        }
    }
    
    class func orderListApi (productID: Int, completion: @escaping(_ error: Error?, _ data: [productsModel]?)-> Void){
        let parametars = [
            "product_id": productID
        ]
        Alamofire.request(URLs.rateList, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                var orderData = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productsModel(dict: dict) {
                        orderData.append(product)
                    }
                })
                completion(nil, orderData)
            }
        }
    }
    
}
