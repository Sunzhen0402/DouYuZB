//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/7.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

        // MARK:- 控件属性
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var iconImageView: UIImageView!
        @IBOutlet weak var moreBtn: UIButton!
        
        // MARK:- 定义模型属性
        var group : AnchorGroup? {
            didSet {
                titleLabel.text = group?.tag_name
                iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
            }
        }
}

// MARK:- 从Xib中快速创建的类方法
extension CollectionHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}