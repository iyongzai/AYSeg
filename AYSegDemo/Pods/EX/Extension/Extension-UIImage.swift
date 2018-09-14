//
//  Extension-UIImage.swift
//  iVCoin
//
//  Created by Tyler.Yin on 2018/1/7.
//  Copyright © 2018年 阿勇. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK: - 重新绘制一张指定大小的图片
    public func scaleToSize(_ size:CGSize) -> UIImage {
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        // 绘制改变大小的图片
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        // 从当前context中创建一个改变大小后的图片
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return img;
    }
}
