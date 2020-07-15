//
//  FGGradientButton.swift
//  iFGEX
//
//  Created by zhiyong yin on 2020/7/2.
//  Copyright © 2020 iFGEX. All rights reserved.
//

import UIKit

public class AYGradientTitleButton: UIButton {
        
    public var gradientParams = GradientParams()
    
    public var isGradient = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    public var showBottomLine = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 在不需要渐变的时候，恢复selected状态的标题颜色
    private var selectedStateColor: UIColor?

    lazy var gradientLabel: AYGradientLabel = AYGradientLabel()
    public private(set) var bottomLine: AYGradientView?
    
    private func newGradientView() -> AYGradientView {
        var gradientParams = GradientParams()
        gradientParams.startPoint = GradientDirection.left2Right.startPoint
        gradientParams.endPoint = GradientDirection.left2Right.endPoint
        
        let view = AYGradientView.init(gradientParams: gradientParams)
        view.halfCorner = false

        return view
    }
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        gradientLabel.isHidden = !isGradient        
        gradientLabel.text = self.titleLabel?.text
        gradientLabel.font = self.titleLabel?.font
        let gradientContentSize = gradientLabel.gradientContentSize
        if isGradient {
            super.setTitleColor(UIColor.clear, for: .selected)
            if gradientLabel.superview == nil {
                self.addSubview(gradientLabel)
            }
            gradientLabel.gradientParams = gradientParams
            gradientLabel.isGradient = isGradient

            gradientLabel.frame = self.bounds
            gradientLabel.frame = CGRect.init(x: (self.bounds.width-gradientContentSize.width)/2,
                                              y: (self.bounds.height-gradientLabel.font!.pointSize)/2,
                                              width: gradientContentSize.width,
                                              height: gradientLabel.font!.pointSize)
        }else{
            super.setTitleColor(selectedStateColor, for: .selected)
        }
        if showBottomLine, isGradient {
            if bottomLine == nil {
                bottomLine = self.newGradientView()
            }
            self.addSubview(bottomLine!)
            bottomLine?.frame = CGRect.init(x: (self.bounds.width-gradientContentSize.width)/2,
                                           y: self.bounds.height/2+gradientLabel.font!.pointSize/2+4,
                                           width: gradientContentSize.width,
                                           height: 1)
            
        }else{
            bottomLine?.removeFromSuperview()
            bottomLine = nil
        }
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.setNeedsDisplay()
    }
    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        switch state {
        case .selected:
            selectedStateColor = color
            super.setTitleColor(isGradient ? UIColor.clear : color, for: state)
        default:
            super.setTitleColor(color, for: state)
        }
        self.setNeedsDisplay()
    }
    
    public override var isSelected: Bool {
        set {
            super.isSelected = newValue
            isGradient = newValue
        }
        get {
            return super.isSelected
        }
    }
    
    public func setTitleFont(_ font: UIFont) {
        self.titleLabel?.font = font
        self.setNeedsDisplay()
    }
}
