//
//  AYGradientView.swift
//  iFGEX
//
//  Created by zhiyong yin on 2020/7/3.
//  Copyright © 2020 iFGEX. All rights reserved.
//

import Foundation
import UIKit

public class AYGradientView: UIView, GradientUI {
    public var gradientlayer = CAGradientLayer.init()
    
    public var gradientParams: GradientParams!
    
    public var cornerRadius: CGFloat?
    public var halfCorner = true
    
    
    public init(gradientParams: GradientParams) {
        
        super.init(frame: CGRect.zero)
        
        self.gradientParams = gradientParams
        
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    
    private func setup() {
        self.isUserInteractionEnabled = false
        if gradientParams == nil {
            var gradientParams = GradientParams()
            gradientParams.startPoint = GradientDirection.left2Right.startPoint
            gradientParams.endPoint = GradientDirection.left2Right.endPoint
            self.gradientParams = gradientParams
        }
        self.layer.addSublayer(gradientlayer)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientlayer.frame = self.bounds
        gradientlayer.startPoint = gradientParams.startPoint
        gradientlayer.endPoint = gradientParams.endPoint
        gradientlayer.locations = gradientParams.locations
        gradientlayer.colors = gradientParams.colors.compactMap{ return $0.cgColor }
        gradientlayer.frame = self.bounds
        if cornerRadius != nil {
            self.ayCornerRadius = cornerRadius!
        }else{
            self.ayCornerRadius = halfCorner ? gradientlayer.frame.height/2 : 0
        }
    }
    
    public func refresh() {
        setNeedsDisplay()
    }
}
