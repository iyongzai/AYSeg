//
//  Extension-UITextField.swift
//  iVCoin
//
//  Created by ayong on 2017/11/29.
//  Copyright © 2017年 阿勇. All rights reserved.
//

import UIKit

extension UITextField {
    //MARK: - 设置UITextField的leftView
    public func aySetLeftImageView(_ imageName: String, width: CGFloat = 30, height: CGFloat = 44) {
        let uLeftView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        uLeftView.image = UIImage.init(named: imageName)
        uLeftView.contentMode = .center
        self.leftView = uLeftView
        self.leftViewMode = .always
    }
    //MARK: - 设置UITextField的rightView
    public func aySetRightImageView(_ imageName: String, width: CGFloat = 30, height: CGFloat = 44) {
        let uRightView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        uRightView.image = UIImage.init(named: imageName)
        uRightView.contentMode = .center
        self.rightView = uRightView
        self.rightViewMode = .always
    }
    //MARK: - 设置UITextField的rightView
    public func aySetRightButton(_ normalImageName: String, width: CGFloat = 30, height: CGFloat = 44) -> UIButton {
        let uRightView = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        uRightView.setImage(UIImage.init(named: normalImageName), for: .normal)
        uRightView.contentMode = .center
        self.rightView = uRightView
        self.rightViewMode = .always
        
        return uRightView
    }
}
