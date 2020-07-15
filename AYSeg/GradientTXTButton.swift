//
//  GradientTXTButton.swift
//  AYSegDemo
//
//  Created by zhiyong yin on 2020/7/6.
//  Copyright © 2020 ayong. All rights reserved.
//

import Foundation

import UIKit

public enum GradientState {
    case normal
    case selected
}
public enum GradientDirection {
    case left2Right
    case top2Bottom
    case leftTop2RightBottom
    case leftBottom2RightTop
}

public struct GradientParams {
    var locations: [NSNumber]? = [0, 1]
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
}

public class GradientTXTButton: UIView {

    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    lazy var gradientLayer = CAGradientLayer()
    
    public var gradientParams = GradientParams() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var direct: GradientDirection = .top2Bottom {
        didSet{
            var newParams = gradientParams
            newParams.locations = [0, 1]
            switch direct {
            case .left2Right:
                newParams.startPoint = CGPoint.init(x: 0, y: 0.5)
                newParams.endPoint = CGPoint.init(x: 1, y: 0.5)
            case .top2Bottom:
                newParams.startPoint = CGPoint.init(x: 0.5, y: 0)
                newParams.endPoint = CGPoint.init(x: 0.5, y: 1)
            case .leftTop2RightBottom:
                newParams.startPoint = CGPoint.init(x: 0, y: 0)
                newParams.endPoint = CGPoint.init(x: 1, y: 1)
            case .leftBottom2RightTop:
                newParams.startPoint = CGPoint.init(x: 0, y: 1)
                newParams.endPoint = CGPoint.init(x: 1, y: 0)
            }
            gradientParams = newParams
        }
    }
    
    public var isSelected = false {
        didSet {
            currentState = isSelected ? .selected : .normal
        }
    }
    public var currentTitle: String? {
        return titles[currentState]
    }
    public var state: GradientState {
        return currentState
    }
    private var currentState: GradientState = .normal {
        didSet {
            self.setNeedsLayout()
        }
    }
    private var titles: [GradientState : String] = [:]
    private var fonts = [GradientState.normal : UIFont.systemFont(ofSize: 15), GradientState.selected : UIFont.boldSystemFont(ofSize: 18)]
    private var titleColors = [GradientState.normal : [UIColor.white, UIColor.white], GradientState.selected : [UIColor.yellow, UIColor.red]]
    
    
    public var maxWidth: CGFloat = UIScreen.main.bounds.width
    private var isAddedWeakSizeLayout = false
    
    //touch
    private var touchTarget: Any?
    private var touchSelector: Selector?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.addSubview(label)
        
        self.textAlignment = .center
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(_:)))
        self.addGestureRecognizer(tap)
    }
    
        
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        guard let senderButton = sender.view as? GradientTXTButton else { return }
        let target = senderButton.touchTarget as AnyObject
        guard  let sel = senderButton.touchSelector else { return }
        
        if target.canPerformAction(sel, withSender: senderButton) {
            target.performSelector(onMainThread: sel, with: senderButton, waitUntilDone: true)
        }
    }
    
    func addTargetForTouch(_ target: Any?, action: Selector) {
        self.touchTarget = target
        self.touchSelector = action
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.superview != nil else { return }
        
        gradientLayer.locations = gradientParams.locations
        gradientLayer.startPoint = gradientParams.startPoint
        gradientLayer.endPoint = gradientParams.endPoint
        gradientLayer.colors = (titleColors[currentState] ?? titleColors[.normal])?.compactMap { return $0.cgColor }
        
        label.text = titles[currentState] ?? titles[GradientState.normal]
        label.font = fonts[currentState] ?? fonts[GradientState.normal]
        
        let textRect = label.textRect(forBounds: self.bounds, limitedToNumberOfLines: 1)
        gradientLayer.frame = CGRect.init(x: (self.bounds.width-textRect.width)/2,
                                          y: (self.bounds.height-textRect.height)/2,
                                          width: textRect.width,
                                          height: textRect.height)
        label.frame = gradientLayer.bounds
        
        self.layer.addSublayer(gradientLayer)

        gradientLayer.mask = label.layer
    }
    
    public var textAlignment: NSTextAlignment = .center{
        didSet{
            self.label.textAlignment = textAlignment
            setNeedsLayout()
        }
    }
    
    
    public func setFont(_ font: UIFont, for state: GradientState) {
        fonts[state] = font
        setNeedsLayout()
    }
    public func font(for state: GradientState) -> UIFont? {
        return fonts[state]
    }
    
    public func setTitle(_ title: String, for state: GradientState) {
        titles[state] = title
        setNeedsLayout()
    }
    public func title(for state: GradientState) -> String? {
        return titles[state]
    }
    
    public func setTitleColors(_ colors: [UIColor], for state: GradientState) {
        titleColors[state] = colors
        setNeedsLayout()
    }
    public func titleColor(for state: GradientState) -> [UIColor]? {
        return titleColors[state]
    }
}
