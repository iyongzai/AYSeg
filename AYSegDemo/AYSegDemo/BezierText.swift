//
//  BezierText.swift
//  hangge_1898
//
//  Created by hangge on 2017/12/23.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit

class BezierText: UIView, CAAnimationDelegate {
    
    //字迹动画时间
    private let duration:TimeInterval = 3
    
    //字迹书写图层
    private let pathLayer = CAShapeLayer()
    
    //钢笔图标图层
    private var penLayer = CALayer()
    
    private let fontPoint: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化字迹图层
        pathLayer.frame = self.bounds
        pathLayer.isGeometryFlipped = true
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(pathLayer)
        
        //初始化钢笔图标图层
        var pen = UIImage(named: "pen")!
        pen = pen.scaleToSize(CGSize.init(width: fontPoint+10, height: pen.size.height/pen.size.width*(fontPoint+10)))
        penLayer.contents = pen.cgImage
        penLayer.anchorPoint = .zero
        penLayer.frame = CGRect(x: 0, y: 0, width: pen.size.width,
                                height: pen.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pathLayer.frame.origin = CGPoint.init(x: (self.frame.size.width-pathLayer.bounds.width)/2, y: (self.frame.size.height-pathLayer.bounds.height)/2)
    }
    
    //动态书写指定文字
    func show(text: String) {
        //获取文字对应的贝塞尔曲线
        let textPath = bezierPathFrom(string: text)
        //让文字居中显示
        pathLayer.bounds = textPath.cgPath.boundingBox
        pathLayer.frame.origin = CGPoint.init(x: (self.bounds.size.width-pathLayer.bounds.width)/2, y: (self.bounds.size.height-pathLayer.bounds.height)/2)
        //设置笔记书写路径
        pathLayer.path = textPath.cgPath
        
        //添加笔迹书写动画
        let textAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        textAnimation.duration = duration
        textAnimation.fromValue = 0
        textAnimation.toValue = 1
        //textAnimation.repeatCount = HUGE
        pathLayer.add(textAnimation, forKey: "strokeEnd")
        
        //将钢笔图层添加到字迹图层中
        pathLayer.addSublayer(penLayer)
        
        //给钢笔图标添加移动动画
        let orbit = CAKeyframeAnimation(keyPath:"position")
        orbit.delegate = self
        orbit.duration = duration
        orbit.path = textPath.cgPath
        orbit.calculationMode = kCAAnimationPaced
        orbit.isRemovedOnCompletion = false
        orbit.fillMode = kCAFillModeForwards
        penLayer.add(orbit,forKey:"position")
    }
    
    //钢笔移动动画播放结束
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //文字书写完毕后将钢笔移出
        penLayer.removeFromSuperlayer()
    }
    
    //将字符串转为贝塞尔曲线
    private func bezierPathFrom(string:String) -> UIBezierPath{
        let paths = CGMutablePath()
        let fontName = __CFStringMakeConstantString("SnellRoundhand")!
        let fontRef:AnyObject = CTFontCreateWithName(fontName, fontPoint, nil)
        
        let attrString = NSAttributedString(string: string, attributes:
            [kCTFontAttributeName as NSAttributedStringKey : fontRef])
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runA = CTLineGetGlyphRuns(line)
        
        for runIndex in 0..<CFArrayGetCount(runA) {
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, to: CTRun.self)
            
            let CTFontName = unsafeBitCast(kCTFontAttributeName,
                                           to: UnsafeRawPointer.self)
            
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)
            
            let width = self.bounds.size.width
            
            var temp = 0
            var offset:CGFloat = 0.0
            
            for i in 0..<CTRunGetGlyphCount(runb) {
                let range = CFRangeMake(i, 1)
                let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                let position = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                position.initialize(to: .zero)
                CTRunGetGlyphs(runb, range, glyph)
                CTRunGetPositions(runb, range, position);
                
                let temp3 = CGFloat(position.pointee.x)
                let temp2 = (Int) (temp3 / width)
                let temp1 = 0
                if(temp2 > temp1){
                    
                    temp = temp2
                    offset = position.pointee.x - (CGFloat(temp) * width)
                }
                if let path = CTFontCreatePathForGlyph(runFontS,glyph.pointee,nil) {
                    let x = position.pointee.x - (CGFloat(temp) * width) - offset
                    let y = position.pointee.y - (CGFloat(temp) * 80)
                    let transform = CGAffineTransform(translationX: x, y: y)
                    paths.addPath(path, transform: transform)
                }
                
                glyph.deinitialize(count: 1)
                glyph.deallocate()
                position.deinitialize(count: 1)
                position.deallocate()
            }
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.append(UIBezierPath(cgPath: paths))
        
        return bezierPath
    }
}

