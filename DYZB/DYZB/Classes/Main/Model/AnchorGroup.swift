//
//  AnchorGroup.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/9.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit

class AnchorGroup: BaseGameModel {
    /// 该组中对应的房间信息
    @objc var room_list : [[String : NSObject]]? {
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    /// 组显示的图标
    @objc var icon_name : String = "home_header_normal"
    /// 定义主播的模型对象数组
    @objc lazy var anchors : [AnchorModel] = [AnchorModel]()
}
