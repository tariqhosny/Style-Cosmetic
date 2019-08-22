//
//  helper.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/23/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class helper: NSObject {
    
    class func saveUserToken(token: String){
        let defUser = UserDefaults.standard
        defUser.setValue(token, forKey: "user_token")
        defUser.synchronize()
        restartApp()
    }
    
    class func getUserToken() -> String? {
        let defUser = UserDefaults.standard
        return defUser.value(forKey: "user_token") as? String
    }
    
    class func restartApp(){
        guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if getUserToken() == nil{
            vc = sb.instantiateInitialViewController()!
        }else{
            vc = sb.instantiateViewController(withIdentifier: "home")
        }
        window.rootViewController = vc
        
    }
    

}
