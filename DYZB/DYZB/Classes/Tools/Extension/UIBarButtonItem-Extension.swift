//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/5.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
//    class func createItem(imageName: String,highImageName: String,size: CGSize) -> UIBarButtonItem{
//        let btn = UIButton()
//
//        btn.setImage(UIImage(named: imageName), for: .normal)
//        btn.setImage(UIImage(named: highImageName), for: .highlighted)
//
//        btn.frame = CGRect(origin: CGPoint.zero, size: size)
//
//        return UIBarButtonItem(customView: btn)
        
//    }
    
    
    //便利构造函数：（只能扩展便利构造函数）
    convenience init(imageName: String,highImageName: String = "",size: CGSize = CGSize.zero){
        let btn = UIButton()

        btn.setImage(UIImage(named: imageName), for: .normal)
        
        if(highImageName != ""){
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        if(size == CGSize.zero){
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        //必须要调用self.init
        self.init(customView: btn)
    }

}
