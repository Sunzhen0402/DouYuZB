//
//  PageContentView.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/5.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit

private let ContentCellID = "ContentCellID"

protocol PageContentViewDelegate: class{
    func pageContentView(contentView: PageContentView,progress: CGFloat,sourceIndex: Int,taretIndex: Int)
}

class PageContentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: -定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private  var startOffSetX: CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate:PageContentViewDelegate?
    
    //MARK: -懒加载属性
    private lazy var collectionView:UICollectionView = {[weak self] in
       //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    //MARK: -自定义构造函数
    init(frame : CGRect,childVcs : [UIViewController], parentViewController : UIViewController?){
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame:frame)
        
        //设置Ui
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
//MARK: -设置UI界面
extension PageContentView{
    private func setupUI(){
        //1.将所有的子控制器添加到付控制器中
        for childVc in childVcs{
            parentViewController?.addChild(childVc)
        }
        
        //2.添加UIcollectionView，用于在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
    

//MARK: - UICollectionViewDataSource协议
extension PageContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        //2.给cell设置内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK: -遵守UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffSetX = scrollView.contentOffset.x
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0.判断是否为点击时事件
        if(isForbidScrollDelegate) {return}
        
        //1.定义需要的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        //2.判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if(currentOffsetX > startOffSetX){//左滑
            //1.计算progress
            progress = currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW)
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX/scrollViewW)
            //3.计算targetIndex
            targetIndex = sourceIndex+1
            if(targetIndex >= childVcs.count-1){
                targetIndex = childVcs.count-1
            }
            //4.如果完全滑过去
            if currentOffsetX - startOffSetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//右滑
           //1.计算progress
           progress = 1 - (currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW))
           //2.计算targetIndex
           targetIndex = Int(currentOffsetX/scrollViewW)
           //3.计算sourceIndex
           sourceIndex = sourceIndex+1
           if(sourceIndex >= childVcs.count-1){
               sourceIndex = childVcs.count-1
           }
        }
        
        //3.将参数床底给titleview
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, taretIndex: targetIndex)
        
        
    }
}
//MARK: -对外暴露的方法
extension PageContentView{
    func setCurrentIndex(currentIndex: Int){
        //1.记录禁止代理方法
        isForbidScrollDelegate = true
        
        //2.滚动到正确位置
        let offsetX = CGFloat(currentIndex)*collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offsetX,y:0), animated: false)
    }
}
