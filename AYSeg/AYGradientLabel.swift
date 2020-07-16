//
//  AYGradientLabel.swift
//  AYGradientLabel
//
//  Created by zhiyong yin on 2020/6/29.
//  Copyright © 2020 zhiyong yin. All rights reserved.
//

import UIKit


/// 文字渐变效果的UILabel，注意：只支持单行
public class AYGradientLabel: UILabel {
    
    public var gradientParams: GradientParams = {
        var gradientParams = GradientParams()
        gradientParams.colors = [UIColor(red: 0.99, green: 0.92, blue: 0.36, alpha: 1),
                                 UIColor(red: 0.96, green: 0.57, blue: 0.12, alpha: 1)]
        gradientParams.startPoint = GradientDirection.top2Bottom.startPoint
        gradientParams.endPoint = GradientDirection.top2Bottom.endPoint

        return gradientParams
    }()

    lazy var gradientLayer = CAGradientLayer()
    
    public var gradientContentSize: CGSize {
        //return self.bezierPath().cgPath.boundingBoxOfPath.size
        return ((self.text ?? "") as NSString).boundingRect(with: CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                                       options: [],
                                                       attributes: [NSAttributedString.Key.font : self.font!],
            context: nil).size
    }
    
    public override func draw(_ rect: CGRect) {
        
        if gradientLayer.superlayer == nil {
            self.layer.addSublayer(gradientLayer)
        }
        gradientLayer.frame = self.bounds
        gradientLayer.colors = gradientParams.colors.compactMap { return $0.cgColor }
        gradientLayer.locations = gradientParams.locations
        gradientLayer.startPoint = gradientParams.startPoint
        gradientLayer.endPoint = gradientParams.endPoint
        
        let bezier = self.bezierPath()
        
        let maskLayer = CAShapeLayer()
        // The path is upside down (CG coordinate system)
        // 第一种处理方法，layer翻转
        //maskLayer.isGeometryFlipped = true
        // 第二种方法，转换坐标轴
        //bezier.apply(CGAffineTransform.init(scaleX: 1.0, y: -1.0))
        //bezier.apply(CGAffineTransform.init(translationX: 0.0, y: bezier.cgPath.boundingBoxOfPath.size.height))
        
        maskLayer.path = bezier.cgPath
        maskLayer.bounds = maskLayer.path!.boundingBoxOfPath
        var x: CGFloat
        switch self.textAlignment {
        case .right:
            x = gradientLayer.bounds.size.width-maskLayer.bounds.size.width
        case .center:
            x = (gradientLayer.bounds.size.width-maskLayer.bounds.width)/2
        default:
            x = 0
        }
        maskLayer.frame.origin = CGPoint.init(x: x, y: (gradientLayer.bounds.size.height-maskLayer.bounds.height)/2)
        
        gradientLayer.mask = maskLayer
    }
    
    private func bezierPath() -> UIBezierPath {
        return (self.text ?? "").bezierPath(fontName: self.font.fontName, fontPoint: self.font?.pointSize ?? 18, width: self.bounds.width)
    }
}
