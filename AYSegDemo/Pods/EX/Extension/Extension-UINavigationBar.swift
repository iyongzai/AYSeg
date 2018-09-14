//
//  Extension-UINavigationBar.swift
//  iVCoin
//
//  Created by Tyler.Yin on 2017/11/30.
//  Copyright © 2017年 阿勇. All rights reserved.
//

import UIKit

extension UINavigationBar {
    // MARK: - 修改navbar背景颜色
    public func setBackground(_ color: UIColor) {
        self.setBackgroundImage(color.image(), for: .any, barMetrics: .default)
    }
    // MARK: - 是否显示navbar的底部阴影效果
    public func setShadowVisible(_ visible: Bool) {
        self.shadowImage = visible ? nil : UIImage()
    }
}
