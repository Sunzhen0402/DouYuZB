//
//  NSDate-Extension.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/9.
//  Copyright © 2020 孙震. All rights reserved.
//

import Foundation


extension NSDate{
    class func getCurrentTime() -> String{
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
