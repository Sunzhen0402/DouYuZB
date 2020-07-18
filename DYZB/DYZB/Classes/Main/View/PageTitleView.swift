//
//  PageTitleView.swift
//  DYZB
//
//  Created by 孙震 on 2020/7/5.
//  Copyright © 2020 孙震. All rights reserved.
//

import UIKit

//MARK: -协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView: PageTitleView,selectedIndex index : Int)
}
//MARK: -定义常量
private let kScrollLineH:CGFloat = 2
private let kNormalColor: (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor: (CGFloat,CGFloat,CGFloat) = (255,128,0)

//MARK: -PageTitleView类
class PageTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
// MARK: - 定义属性
    private var titles: [String]
    private var currentIndex:Int = 0
    weak var delegate:PageTitleViewDelegate?
//MARK: -懒加载属性
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    
    }()
    
    private lazy var scrollLine:UIView = {
       let scrollLine = UIView()
       scrollLine.backgroundColor = UIColor.orange
        
        return scrollLine
    }()
    
    private lazy var titleLabels:[UILabel] = [UILabel]()
    
// MARK: - 自定义构造函数
    init (frame: CGRect,titles: [String]){
        self.titles = titles
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


//MARK: -设置ui界面
extension PageTitleView{
    private func setupUI(){
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        
        //2.添加titl对应的label
        setupTitleLabels()
        
        //3.设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels(){
        //0.确定label的一些属性
        let labelW : CGFloat = frame.width/CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for(index,title) in titles.enumerated(){
            //1.创建label
            let label = UILabel()
            
            //2.设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //3.设置label的frame
            let labelX:CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4.将label添加到scrollview中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
            
        }
    }
    
    private func setupBottomLineAndScrollLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let LineH:CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height-LineH, width: frame.width, height: LineH)
        addSubview(bottomLine)
        
        //2.添加scrollLine
        //2.1获取第一个label
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //2.2设置scrollLine的属性
            
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

//MARK: - 监听label的点击
extension PageTitleView{
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer){
        // 0.获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        
        //3.切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        
        
        //4.保存最新label的下标值
        currentIndex = currentLabel.tag
        
        //5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15){
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        
        //6.通知代理
        self.delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
        
    }
}


//MARK: -对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(progress: CGFloat, sourceIndex : Int, targetIndex : Int){
        //1。取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX*progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x+moveX
        
        //3.颜色渐变
        sourceLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        targetLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //3.1 取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        
        //3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0-colorDelta.0*progress, g: kSelectColor.1-colorDelta.1*progress, b: kSelectColor.1-colorDelta.1*progress)
        
        //3.2 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0+colorDelta.0*progress, g: kNormalColor.1+colorDelta.1*progress, b: kNormalColor.2+colorDelta.2*progress)
        
        //4. 记录最新的index
        currentIndex = targetIndex
        
    }
}
