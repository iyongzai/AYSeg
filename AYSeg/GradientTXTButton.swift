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
    private var currentState: GradientState = .normal {
        didSet {
            self.setNeedsLayout()
        }
    }
    private var fonts: [GradientState : UIFont] = [:]
    private var titles: [GradientState : String] = [:]
    private var titleColors: [GradientState : [UIColor]] = [:]
    
    
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
                
        fonts[.normal] = UIFont.systemFont(ofSize: 15)
        fonts[.selected] = UIFont.boldSystemFont(ofSize: 18)
        
        titleColors[.normal] = [UIColor.white, UIColor.white]
        titleColors[.selected] = [UIColor.yellow, UIColor.red]
        
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
        
        gradientLayer.locations = gradientParams.locations
        gradientLayer.startPoint = gradientParams.startPoint
        gradientLayer.endPoint = gradientParams.endPoint
        gradientLayer.colors = (titleColors[currentState] ?? titleColors[.normal])?.compactMap { return $0.cgColor }
        
        label.text = titles[currentState] ?? titles[GradientState.normal]
        label.font = fonts[currentState] ?? fonts[GradientState.normal]
        
        let textSize = ((label.text ?? "") as NSString).boundingRect(with: CGSize.init(width: maxWidth, height: 20000),
                                                                     options: [],
                                                                     attributes: [NSAttributedString.Key.font : label.font!],
            context: nil).size
        
        self.frame.size = textSize
        
        label.frame = self.bounds
        gradientLayer.frame = label.frame
        
        self.layer.addSublayer(gradientLayer)

        gradientLayer.mask = label.layer
    }
    
    public var textAlignment: NSTextAlignment = .left{
        didSet{
            self.label.textAlignment = textAlignment
            setNeedsLayout()
        }
    }
    
    
    public func setFont(_ font: UIFont, forState state: GradientState) {
        fonts[state] = font
        setNeedsLayout()
    }
    public func font(forState state: GradientState) -> UIFont? {
        return fonts[state]
    }
    
    public func setTitle(_ title: String, forState state: GradientState) {
        titles[state] = title
        setNeedsLayout()
    }
    public func title(forState state: GradientState) -> String? {
        return titles[state]
    }
    
    public func setTitleColors(_ colors: [UIColor], forState state: GradientState) {
        titleColors[state] = colors
        setNeedsLayout()
    }
    public func titleColor(forState state: GradientState) -> [UIColor]? {
        return titleColors[state]
    }
}
