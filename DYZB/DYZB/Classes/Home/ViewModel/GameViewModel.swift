//
//  GameViewModel.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/18.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit

class GameViewModel {
    @objc lazy var games : [GameModel] = [GameModel]()
}

extension GameViewModel {
    func loadAllGameData(finishedCallback : @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: ["shortName" : "game"]) { (result) in
            // 1.获取到数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 2.字典转模型
            for dict in dataArray {
                self.games.append(GameModel(dict: dict))
                print(dict)
            }
            
            // 3.完成回调
            finishedCallback()
        }
    }
}
