//
//  AYGradientTitleButton.swift
//  iFGEX
//
//  Created by zhiyong yin on 2020/7/2.
//  Copyright © 2020 iFGEX. All rights reserved.
//

import UIKit

extension UIControl.State: Hashable {
    
}

public class AYGradientTitleButton: UIButton {
    
    public var isGradientTitle = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// 不同状态下的字体
    private var fonts = [UIControl.State.normal : UIFont.systemFont(ofSize: 15)]
    private var titleColors: [UIControl.State : UIColor?] = [UIControl.State.normal : UIColor.white]
    /// 渐变条件下不同状态下的渐变参数
    private var gradientTitleParamsArray = [UIControl.State.normal : GradientParams()]

    lazy var gradientLabel: AYGradientLabel = {
        let lab = AYGradientLabel()
        lab.textAlignment = .center
        
        return lab
    }()
    
    public private(set) lazy var bottomLine: AYGradientView = {
        var gradientParams = GradientParams()
        gradientParams.startPoint = GradientDirection.left2Right.startPoint
        gradientParams.endPoint = GradientDirection.left2Right.endPoint
        
        let view = AYGradientView.init(gradientParams: gradientParams)
        view.halfCorner = false
        
        return view
    }()
    public var showBottomLine = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    public var gradientBottomLineParams = GradientParams() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.setTitleColor(isGradientTitle ? UIColor.clear : titleColors[state]!, for: state)
        super.titleLabel?.font = fonts[state] ?? fonts[.normal]
        super.draw(rect)
        
        // 渐变标题处理
        gradientLabel.text = self.titleLabel?.text
        gradientLabel.font = self.titleLabel?.font
//        gradientLabel.textAlignment
        let gradientContentSize = gradientLabel.gradientContentSize
        
        if gradientLabel.superview == nil {
            self.addSubview(gradientLabel)
        }
        if isGradientTitle {
            gradientLabel.gradientParams = gradientTitleParamsArray[state] ?? gradientTitleParamsArray[.normal] ?? GradientParams()
        }else{
            var newParams = GradientParams()
            let titleColor = self.titleColor(for: state) ?? self.titleColor(for: .normal) ?? UIColor.darkText
            newParams.colors = [titleColor, titleColor]
            gradientLabel.gradientParams = newParams
        }
        gradientLabel.frame = self.bounds
        gradientLabel.frame = CGRect.init(x: (self.bounds.width-gradientContentSize.width)/2,
                                          y: (self.bounds.height-gradientLabel.font!.pointSize)/2,
                                          width: gradientContentSize.width,
                                          height: gradientLabel.font!.pointSize)
        
        // 底部线条处理
        if bottomLine.superview == nil {
            self.addSubview(bottomLine)
        }
        bottomLine.isHidden = showBottomLine
        bottomLine.frame = CGRect.init(x: (self.bounds.width-gradientContentSize.width)/2,
                                       y: self.bounds.height/2+gradientLabel.font!.pointSize/2+4,
                                       width: gradientContentSize.width,
                                       height: 1)
        bottomLine.gradientParams = gradientBottomLineParams
    }
    
    public override var isSelected: Bool {
        set {
            super.isSelected = newValue
            self.setNeedsDisplay()
        }
        get {
            return super.isSelected
        }
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.setNeedsDisplay()
    }
    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        titleColors[state] = color
        super.setTitleColor(color, for: state)
        self.setNeedsDisplay()
    }
    public func setTitleGradientColor(gradientParams: GradientParams, for state: UIControl.State) {
        gradientTitleParamsArray[state] = gradientParams
        self.setNeedsDisplay()
    }
    
    public func setTitleFont(_ font: UIFont, for state: UIControl.State) {
        fonts[state] = font
        if state == self.state {
            self.setNeedsDisplay()
        }
    }
}
