//
//  AYGradientTXTHeader.swift
//  AYSegDemo
//
//  Created by zhiyong yin on 2020/7/15.
//  Copyright © 2020 ayong. All rights reserved.
//

import UIKit

public struct AYGradientLabelConf {
    public var text: String? = "我的分类"
    public var font = UIFont.init(name: kPingFangRegular, size: 15)!
    
    public var gradientParams: GradientParams? = GradientParams()
    
    public init(text: String? = "我的分类",
                font: UIFont = UIFont.init(name: kPingFangRegular, size: 15)!,
                gradientParams: GradientParams? = GradientParams()) {
        self.text = text
        self.font = font
        self.gradientParams = gradientParams
    }
    
}

public class AYGradientTXTHeader: UIView, AYSegHeader {
    public weak var segView: AYSegView?
    
    public private(set) var currentIndex = 0
    private var normalItems = [AYGradientLabelConf(), AYGradientLabelConf(), AYGradientLabelConf()]
    private var selectedItems = [AYGradientLabelConf.init(font: UIFont.init(name: kPingFangRegular, size: 25)!),
                                 AYGradientLabelConf.init(font: UIFont.init(name: kPingFangRegular, size: 25)!),
                                 AYGradientLabelConf.init(font: UIFont.init(name: kPingFangRegular, size: 25)!)]
    private var labels: [UILabel] = []
    private var gradientLayers: [CAGradientLayer] = []
    
    public var shouldShowBottomLine = true
    weak private var bottomLine: CAGradientLayer?
    public var bottomLineGradientParams = GradientParams.init(startPoint: CGPoint.init(x: 0, y: 0.5), endPoint: CGPoint.init(x: 1, y: 0.5))
    
    
    public var itemSpace: CGFloat = 20
    public var minTouchHeight: CGFloat = 44
    public var handle: AYSegHandle? = nil
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return scrollView
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLabels(inView: scrollView)
    }
    
    public init(items: [AYGradientLabelConf], selectedItems: [AYGradientLabelConf]) {
        super.init(frame: .zero)
        self.normalItems = items
        self.selectedItems = selectedItems
        self.setupLabels(inView: scrollView)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLabels(inView: scrollView)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if gradientLayers.first?.frame.origin.y ?? 0 < 0 {
            self.refresh()
        }
    }
    
    private func refresh() {
        var x: CGFloat = itemSpace
        for (index, gradientLayer) in gradientLayers.enumerated() {
            let showItem = currentIndex == index ? selectedItems[index] : normalItems[index]
            let selectedItem = selectedItems[index]
            let textMaxWidth = ((selectedItem.text ?? "") as NSString).boundingRect(with: CGSize.init(width: self.bounds.width, height: 20000),
                                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                        attributes: [NSAttributedString.Key.font : selectedItem.font],
                                                                        context: nil).width
            let h = currentIndex == index ? selectedItem.font.pointSize : normalItems[index].font.pointSize
            var y = (self.bounds.height-h)/2
            if currentIndex != index {
                // 垂直方向对齐处理(默认居中)
                // 底部对齐(默认居中对齐，底部对齐的话，需要加上高度：(selectedItem.font.pointSize - normalItems[index].font.pointSize)/2)
                y += (selectedItem.font.pointSize - normalItems[index].font.pointSize)/2
            }
            let frame = CGRect.init(x: x,
                                    y: y,
                                    width: textMaxWidth,
                                    height: h)
            gradientLayer.frame = frame
            self.refreshGradient(layer: gradientLayer, gradientParams: showItem.gradientParams!)
            
            let label = labels[index]
            label.frame = gradientLayer.bounds
            self.refreshLabel(label, item: showItem)
            
            x += textMaxWidth+itemSpace
        }
        
        // 底部线条指示器
        if shouldShowBottomLine {
            if bottomLine == nil {
                let bottomLine = CAGradientLayer()
                self.layer.addSublayer(bottomLine)
                self.bottomLine = bottomLine

            }
            bottomLine?.frame = CGRect.init(x: gradientLayers[currentIndex].frame.origin.x,
                                           y: self.bounds.height-2,
                                           width: gradientLayers[currentIndex].frame.width,
                                           height: 2)
            bottomLine?.cornerRadius = (bottomLine?.frame.height ?? 2)/2
            self.refreshGradient(layer: bottomLine!, gradientParams: bottomLineGradientParams)
        }else{
            bottomLine?.removeFromSuperlayer()
        }
    }
    
    
    private func setupLabels(inView: UIView) {
        labels.removeAll()
        gradientLayers.forEach { (elem) in
            elem.removeFromSuperlayer()
        }
        gradientLayers.removeAll()
        var x: CGFloat = itemSpace
        for index in 0..<normalItems.count {
            let item = currentIndex == index ? selectedItems[index] : normalItems[index]
            let selectedItem = selectedItems[index]
            let textMaxWidth = ((selectedItem.text ?? "") as NSString).boundingRect(with: CGSize.init(width: self.bounds.width, height: 20000),
                                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                        attributes: [NSAttributedString.Key.font : selectedItem.font],
                                                                        context: nil).width
            let h = currentIndex == index ? selectedItem.font.pointSize : normalItems[index].font.pointSize
            // 垂直方向对齐处理(默认居中)
            var y = (self.bounds.height-h)/2
            // 底部对齐(默认居中对齐，底部对齐的话，需要加上高度：(selectedItem.font.pointSize - normalItems[index].font.pointSize)/2)
            y += (selectedItem.font.pointSize - normalItems[index].font.pointSize)/2
            let frame = CGRect.init(x: x,
                                    y: y,
                                    width: textMaxWidth,
                                    height: h)
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = frame
            self.refreshGradient(layer: gradientLayer, gradientParams: item.gradientParams!)
            inView.layer.addSublayer(gradientLayer)
            gradientLayers.append(gradientLayer)
            
            let label = UILabel.init(frame: gradientLayer.bounds)
            label.textAlignment = .center
            label.tag = index
            self.refreshLabel(label, item: item)
            gradientLayer.mask = label.layer
            labels.append(label)
            
            x += textMaxWidth+itemSpace*2
        }
        if let frame = gradientLayers.last?.frame {
            scrollView.contentSize = CGSize.init(width: frame.origin.x+frame.width, height: self.frame.height)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(_:)))
        inView.isUserInteractionEnabled = true
        inView.addGestureRecognizer(tap)
        
        let bottomLine = CAGradientLayer()
        bottomLine.frame = CGRect.init(x: gradientLayers[currentIndex].frame.origin.x,
                                       y: self.bounds.height-2,
                                       width: gradientLayers[currentIndex].frame.width,
                                       height: 2)
        inView.layer.addSublayer(bottomLine)
        self.bottomLine = bottomLine
        self.refreshGradient(layer: bottomLine, gradientParams: bottomLineGradientParams)
    }
    private func refreshGradient(layer: CAGradientLayer, gradientParams: GradientParams) {
        layer.locations = gradientParams.locations
        layer.startPoint = gradientParams.startPoint
        layer.endPoint = gradientParams.endPoint
        layer.colors = gradientParams.colors.compactMap{ return $0.cgColor }
    }
    private func refreshLabel(_ label: UILabel, item: AYGradientLabelConf) {
        label.text = item.text
        label.font = item.font
    }
    
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        print(sender.view!.tag)
        let point = sender.location(in: sender.view!)
        if let index = gradientLayers.firstIndex(where: { (elem) -> Bool in
            var newFrame = elem.frame
            newFrame.origin.x -= itemSpace
            newFrame.size.width += 2*itemSpace
            if newFrame.height < minTouchHeight {
                newFrame.origin.y -= (minTouchHeight-newFrame.height)/2
                newFrame.size.height = minTouchHeight
            }
            return newFrame.contains(point)
        }) {
            guard currentIndex != index else {
                return
            }
            self.handle?(index)
            if self.handle == nil {
                segView?.scrollToPage(index)
            }else{
                self.updateUIDidEndScrolling(currentIndex: index)
            }
        }
    }
    
    private func refreshScrollViewContentOffset() {
        //处理滑动
        guard scrollView.contentSize.width > scrollView.frame.width else {
            return
        }
        let maxOffsetX = scrollView.contentSize.width-self.frame.width
        var nextOffsetX = (self.gradientLayers[self.currentIndex].frame.origin.x + self.gradientLayers[self.currentIndex].frame.width/2) - (self.frame.width/2)
        nextOffsetX = min(max(nextOffsetX, 0), maxOffsetX)
        scrollView.setContentOffset(CGPoint.init(x: nextOffsetX, y: 0), animated: true)
    }
}

extension AYGradientTXTHeader {
    public func updateUIDidEndScrolling(currentIndex: Int) {
        print(#function)
        guard currentIndex != self.currentIndex else {
            return
        }
        self.currentIndex = currentIndex
        UIView.animate(withDuration: 0.5) {
            self.refresh()
            self.refreshScrollViewContentOffset()
        }
    }
    
    
    /// 拖拽过程调用此方法，有过渡效果
    /// - Parameters:
    ///   - nextPage: 即将要展示的页面下标
    ///   - scale: 拖拽的比例(0~1)
    public func setNextPage(_ nextPage: Int, scale: CGFloat) {
        guard nextPage != currentIndex else { return }
        if nextPage > currentIndex {//查看右边页面
            
        }else{//查看左边页面
            
        }
        self.refreshScrollViewContentOffset()
    }
}
