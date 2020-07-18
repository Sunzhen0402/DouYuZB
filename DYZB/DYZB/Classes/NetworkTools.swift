//
//  NetworkTools.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/8.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools{
    
   class func requestData(type: MethodType, URLString:String, parameters:[String : Any]? = nil,finishedCallback:@escaping (_ result : Any)->()){
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let result = response.result.value else{
                print(response.result.error as Any)
                return
            }
            finishedCallback(result)
            
        }
    }
}
    
