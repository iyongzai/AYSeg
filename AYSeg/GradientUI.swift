//
//  GradientUI.swift
//  iFGEX
//
//  Created by zhiyong yin on 2020/7/3.
//  Copyright © 2020 iFGEX. All rights reserved.
//

import Foundation
import UIKit


public enum GradientDirection {
    case left2Right
    case top2Bottom
    case leftTop2RightBottom
    case leftBottom2RightTop
    
    public var startPoint: CGPoint {
        switch self {
        case .left2Right:
            return CGPoint.init(x: 0, y: 0.5)
        case .top2Bottom:
            return CGPoint.init(x: 0.5, y: 0)
        case .leftTop2RightBottom:
            return CGPoint.init(x: 0, y: 0)
        case .leftBottom2RightTop:
            return CGPoint.init(x: 0, y: 1)
        }
    }
    public var endPoint: CGPoint {
        switch self {
        case .left2Right:
            return CGPoint.init(x: 1, y: 0.5)
        case .top2Bottom:
            return CGPoint.init(x: 0.5, y: 1)
        case .leftTop2RightBottom:
            return CGPoint.init(x: 1, y: 1)
        case .leftBottom2RightTop:
            return CGPoint.init(x: 1, y: 0)
        }
    }
}

public struct GradientParams {
    public var locations: [NSNumber]? = [0, 1]
    public var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    public var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    public var colors: [UIColor] = [UIColor(red: 0.99, green: 0.92, blue: 0.36, alpha: 1), UIColor(red: 0.96, green: 0.57, blue: 0.12, alpha: 1)]
    
    public mutating func setLocations(_ locations: [NSNumber]?) -> GradientParams {
        self.locations = locations
        return self
    }
    public mutating func setStartPoint(_ startPoint: CGPoint) -> GradientParams {
        self.startPoint = startPoint
        return self
    }
    public mutating func setEndPoint(_ endPoint: CGPoint) -> GradientParams {
        self.endPoint = endPoint
        return self
    }
    public mutating func setColors(_ colors: [UIColor]) -> GradientParams {
        self.colors = colors
        return self
    }
    
}


public protocol GradientUI {
    var gradientlayer : CAGradientLayer {get}
    
    func configure(gradientParams: GradientParams)
}

public extension GradientUI {
    func configure(gradientParams: GradientParams) {
        gradientlayer.startPoint = gradientParams.startPoint
        gradientlayer.endPoint = gradientParams.endPoint
        gradientlayer.locations = gradientParams.locations
        gradientlayer.colors = gradientParams.colors.compactMap { return $0.cgColor }
    }
}




