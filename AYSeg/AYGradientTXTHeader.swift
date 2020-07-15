//
//  AYGradientTXTHeader.swift
//  AYSegDemo
//
//  Created by zhiyong yin on 2020/7/15.
//  Copyright © 2020 ayong. All rights reserved.
//

import UIKit

struct AYGradientLabelConf {
    var text: String? = "法币账户"
    var font = UIFont.init(name: pingFangRegular, size: 15)!
    
    var gradientParams: GradientParams? = GradientParams()
}

public class AYGradientTXTHeader: UIView, AYSegHeader {
    
    
    private(set) var currentIndex = 0
    private var normalItems = [AYGradientLabelConf(), AYGradientLabelConf(), AYGradientLabelConf()]
    private var selectedItems = [AYGradientLabelConf.init(font: UIFont.init(name: pingFangRegular, size: 25)!),
                                 AYGradientLabelConf.init(font: UIFont.init(name: pingFangRegular, size: 25)!),
                                 AYGradientLabelConf.init(font: UIFont.init(name: pingFangRegular, size: 25)!)]
    private var labels: [UILabel] = []
    private var gradientLayers: [CAGradientLayer] = []
    
    var shouldShowBottomLine = true
    weak private var bottomLine: CAGradientLayer?
    var bottomLineGradientParams = GradientParams.init(startPoint: CGPoint.init(x: 0, y: 0.5), endPoint: CGPoint.init(x: 1, y: 0.5))
    
    
    var itemSpace: CGFloat = 20
    var minTouchHeight: CGFloat = 44
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLabels()
    }
    
    init(items: [AYGradientLabelConf], selectedItems: [AYGradientLabelConf]) {
        super.init(frame: .zero)
        self.normalItems = items
        self.selectedItems = selectedItems
        self.setupLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLabels()
    }
    
    
    
    public override func draw(_ rect: CGRect) {
        var x: CGFloat = itemSpace
        for (index, gradientLayer) in gradientLayers.enumerated() {
            let item = currentIndex == index ? selectedItems[index] : normalItems[index]
            let selectedItem = selectedItems[index]
            let textMaxWidth = ((selectedItem.text ?? "") as NSString).boundingRect(with: CGSize.init(width: self.bounds.width, height: 20000),
                                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                        attributes: [NSAttributedString.Key.font : selectedItem.font],
                                                                        context: nil).width
            let h = selectedItem.font.pointSize
            let frame = CGRect.init(x: x,
                                    y: (self.bounds.height-h)/2,
                                    width: textMaxWidth,
                                    height: h)
            gradientLayer.frame = frame
            self.refreshGradient(layer: gradientLayer, gradientParams: item.gradientParams!)
            
            let label = labels[index]
            label.frame = gradientLayer.bounds
            self.refreshLabel(label, item: item)
            
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
    
    
    private func setupLabels() {
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
            let h = selectedItem.font.pointSize
            let frame = CGRect.init(x: x,
                                    y: (self.bounds.height-h)/2,
                                    width: textMaxWidth,
                                    height: h)
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = frame
            self.refreshGradient(layer: gradientLayer, gradientParams: item.gradientParams!)
            self.layer.addSublayer(gradientLayer)
            gradientLayers.append(gradientLayer)
            
            let label = UILabel.init(frame: gradientLayer.bounds)
            label.textAlignment = .center
            label.tag = index
            self.refreshLabel(label, item: item)
            gradientLayer.mask = label.layer
            labels.append(label)
            
            x += textMaxWidth+itemSpace*2
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        
        let bottomLine = CAGradientLayer()
        bottomLine.frame = CGRect.init(x: gradientLayers[currentIndex].frame.origin.x,
                                       y: self.bounds.height-2,
                                       width: gradientLayers[currentIndex].frame.width,
                                       height: 2)
        self.layer.addSublayer(bottomLine)
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
            self.currentIndex = index
            UIView.animate(withDuration: 0.35) {
                self.setNeedsDisplay()
            }
        }
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
            self.setNeedsDisplay()
        }
    }
}
