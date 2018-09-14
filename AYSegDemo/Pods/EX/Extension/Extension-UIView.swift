//
//  Extension-UIView.swift
//  iVCoin
//
//  Created by ayong on 2017/11/28.
//  Copyright © 2017年 阿勇. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    //MARK: - 给view添加圆角
    @IBInspectable public var ayCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        // also  set(newValue)
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    //MARK: - 给view指定边框宽度
    @IBInspectable public var ayBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //MARK: - 给view指定边框颜色
    @IBInspectable public var ayBorderColor: UIColor? {
        get {
            return UIColor.init(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


// MARK: - 扩展toast功能：上面图片，下面文字
extension UIView {
    // MARK: - 扩展toast功能：上面图片，下面文字
    public func makeToast(_ topImg: UIImage, bottomMSG: String) {
        let toast = UIView()
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toast.ayCornerRadius = 10
        self.addSubview(toast)
        toast.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 125, height: 100))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-50)
        }
        let label = UILabel()
        label.text = bottomMSG
        label.font = UIFont.init(name: "PingFangSC-Medium", size: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        toast.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-15)
            make.height.equalTo(20)
        }
        
        let imgView = UIImageView()
        imgView.image = topImg
        imgView.contentMode = .center
        toast.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(label.snp.top)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            toast.removeFromSuperview()
        }
    }
}



//MARK: - 自定义View定义的协议方法
public protocol UI {
    
    /// 用于调整UI的接口
    func adjustUI()
    
    /// UI添加事件
    func addEvents()
    
    /// 用来添加子视图的接口
    func addSubviews()
    
    /// 用来给子视图添加约束的接口
    func addConstraints()
    
    /// 设置数据源
    func configure<T>(model: T)
}

public extension UI {
    /// 用于调整UI的接口
    func adjustUI(){}
    
    /// UI添加事件
    func addEvents(){}
    
    /// 用来添加子视图的接口
    func addSubviews(){}
    
    /// 用来给子视图添加约束的接口
    func addConstraints(){}
    
    /// 设置数据源
    func configure<T>(model: T) {}
}

extension UIView {
    // MARK: - view截图
    public func snapshot() -> UIImage? {
        let rect = self.frame
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
extension UIView {
    // MARK: - view截图
    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    public func screenShot() -> UIImage? {
        
        return self.screenShot(scale: 0)
    }
    // MARK: - view截图
    public func screenShot(scale: CGFloat) -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


extension UIView {
    // MARK: - 快捷生成一个渐变layer
    public static func newGradientLayer(frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-32, height: 44), startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 0), colors: [Any]? = ["#FC5D9F".uiColor().cgColor, "#5863FC".uiColor().cgColor]) -> CAGradientLayer {
        let caGradientLayer = CAGradientLayer()
        caGradientLayer.frame = frame
        caGradientLayer.startPoint = startPoint
        caGradientLayer.endPoint = endPoint
        caGradientLayer.colors = colors
        
        return caGradientLayer
    }
    
    // MARK: - 底层添加一个同样大小，位置一样的渐变背景
    public func addGradientBG() {
        let _ = self.addGradientBGThenReturnIt()
    }
    public func addGradientBGThenReturnIt() -> AYGradientView? {
        guard self.superview != nil else {
            return nil
        }
        self.backgroundColor = UIColor.clear
        let gradientView = AYGradientView.init()
        gradientView.ayCornerRadius = self.ayCornerRadius
        self.superview?.insertSubview(gradientView, belowSubview: self)
        gradientView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(self.snp.size)
        }
        return gradientView
    }
}



public class AYGradientView: UIView {
    
    public var caGradientLayer: CAGradientLayer!
    
    public init(startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 0), colors: [Any]? = ["#FC5D9F".uiColor().cgColor, "#5863FC".uiColor().cgColor]) {
        super.init(frame: CGRect.zero)
        caGradientLayer = UIView.newGradientLayer(startPoint: startPoint, endPoint: endPoint, colors: colors)
        self.layer.insertSublayer(caGradientLayer, at: 0)
        self.isUserInteractionEnabled = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.insertSublayer(caGradientLayer, at: 0)
        self.isUserInteractionEnabled = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        caGradientLayer.frame = self.bounds
    }
}

