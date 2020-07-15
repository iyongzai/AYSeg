//
//  Extension-String.swift
//  AYGradientLabel
//
//  Created by zhiyong yin on 2020/6/29.
//  Copyright © 2020 zhiyong yin. All rights reserved.
//

import Foundation
import UIKit


extension String {
    /// 将字符串转为贝塞尔曲线
    /// - Parameters:
    ///   - fontName: 字库名称
    ///   - fontPoint: 文字大小
    ///   - width: width
    /// - Returns: 贝塞尔路径
    func bezierPath(fontName: String = "SnellRoundhand",
                    fontPoint: CGFloat = 14,
                    width: CGFloat = UIScreen.main.bounds.width) -> UIBezierPath {
        
        let paths = CGMutablePath()
        let fontName = __CFStringMakeConstantString(fontName)!
        let fontRef:AnyObject = CTFontCreateWithName(fontName, fontPoint, nil)
        
        let attrString = NSAttributedString(string: self, attributes:
            [kCTFontAttributeName as NSAttributedString.Key : fontRef])
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runA = CTLineGetGlyphRuns(line)
        
        for runIndex in 0..<CFArrayGetCount(runA) {
            let run = CFArrayGetValueAtIndex(runA, runIndex);
            let runb = unsafeBitCast(run, to: CTRun.self)
            
            let CTFontName = unsafeBitCast(kCTFontAttributeName,
                                           to: UnsafeRawPointer.self)
            
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)
            
            
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
        let textUIBezierPath = UIBezierPath(cgPath: paths)
        textUIBezierPath.apply(CGAffineTransform.init(scaleX: 1.0, y: -1.0))
        textUIBezierPath.apply(CGAffineTransform.init(translationX: 0.0, y: paths.boundingBox.size.height))

        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.append(textUIBezierPath)
        
        return bezierPath
    }
}
