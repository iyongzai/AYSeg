//
//  AYSegDefaultHeader.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/13.
//  Copyright © 2018年 ayong. All rights reserved.
//

import Foundation
import UIKit
import EX

//MARK: 构造一个Bar作为header
public typealias SegHandle = (_ index: Int) -> Void
public class AYSegDefaultHeader: UIView {
    
    public var baseContentSize: CGSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 44)
    override public var intrinsicContentSize: CGSize {
        return baseContentSize
    }
    
    private(set) var buttons = [UIButton]()
    //image's name is seg_line_v
    private(set) var lines = [UIImageView]()
    
    private(set) var currentIndex: Int = 0
    
    private(set) lazy var bottomLine: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 2))
        v.backgroundColor = buttonTitleSelectedColor
        return v
    }()
    private(set) lazy var selectedView: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 131, height: 32))
        v.ayCornerRadius = 16
        v.backgroundColor = "#32374F".uiColor()
        return v
    }()
    
    public var handle: SegHandle? = nil
    private var buttonFont: UIFont = UIFont.systemFont(ofSize: 14)
    private var buttonTitleNormalColor: UIColor = "#666666".uiColor()
    private var buttonTitleSelectedColor: UIColor = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)//主题深蓝
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect, titles: [String], lineImageNames: [String] , handle: SegHandle?, buttonFont: UIFont = UIFont.systemFont(ofSize: 14), buttonTitleNormalColor: UIColor = "#666666".uiColor(), buttonTitleSelectedColor: UIColor = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)) {
        self.init(frame: frame)
        
        self.handle = handle
        
        self.backgroundColor = UIColor.init(hexColor: "#f9f9f9")
        self.buttonFont = buttonFont
        self.buttonTitleNormalColor = buttonTitleNormalColor
        self.buttonTitleSelectedColor = buttonTitleSelectedColor
        for (index,title) in titles.enumerated() {
            let button = UIButton.init(type: .system)
            button.tintColor = buttonTitleNormalColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(buttonTitleNormalColor, for: .normal)
            button.titleLabel?.font = buttonFont
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            button.tag = index
            if index == currentIndex {
                button.setTitleColor(buttonTitleSelectedColor, for: .normal)
            }
            
            self.addSubview(button)
            
            button.snp.makeConstraints { (maker) in
                maker.top.equalTo(0)
                maker.bottom.equalTo(0)
                if index == 0 {
                    maker.left.equalTo(self)
                }else {
                    maker.left.equalTo(self.buttons.last!.snp.right)
                    maker.width.equalTo(self.buttons.first!)
                }
                if index+1 == titles.count{
                    maker.left.equalTo(self.buttons.last?.snp.right ?? 16)
                    maker.right.equalTo(self).priority(990)
                    maker.width.equalTo(self.buttons.first ?? 70).priority(991)
                }
            }
            self.buttons.append(button)
            
            if index < lineImageNames.count {
                let image = UIImage.init(named: lineImageNames[index])
                let imageView = UIImageView.init(image: image)
                imageView.contentMode = .center
                
                self.addSubview(imageView)
                
                imageView.snp.makeConstraints({ (maker) in
                    maker.top.equalTo(0)
                    maker.bottom.equalTo(0)
                    maker.width.equalTo(image?.size.width ?? 0)
                    maker.left.equalTo(button.snp.right)
                })
                
                self.lines.append(imageView)
            }
        }
        self.addSubview(bottomLine)
        let textWidth = self.buttons.first?.currentTitle?.boundingRect(with: CGSize.init(width: 100, height: 100), options: [], attributes: [NSAttributedStringKey.font : self.buttonFont], context: nil).size.width ?? 64
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.size.equalTo(CGSize.init(width: textWidth, height: 2))
            make.centerX.equalTo(buttons.first?.snp.centerX ?? 0)
        }
        //self.addSubview(selectedView)
        self.insertSubview(selectedView, at: 0)
        selectedView.isHidden = true
        selectedView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: textWidth+35, height: 32))
            make.centerX.equalTo(buttons.first?.snp.centerX ?? 0)
            make.centerY.equalTo(buttons.first?.snp.centerY ?? 0)
        }
        self.layoutIfNeeded()
    }
    
    public func updateUIDidEndScrolling(currentIndex: Int) {
        guard currentIndex != self.currentIndex else {
            return
        }
        print("updateUIDidEndScrollingCurrentIndex:\(currentIndex)")
        self.currentIndex = currentIndex
        for (index, button) in buttons.enumerated() {
            if index == currentIndex {
                button.setTitleColor(buttonTitleSelectedColor, for: .normal)
                button.titleLabel?.font = UIFont.init(name: self.buttonFont.fontName, size: buttonFont.pointSize+1)
            }else{
                button.setTitleColor(buttonTitleNormalColor, for: .normal)
                button.titleLabel?.font = self.buttonFont
            }
        }
        UIView.animate(withDuration: 0.35) {
            let textWidth = self.buttons[currentIndex].currentTitle?.boundingRect(with: CGSize.init(width: 100, height: 100), options: [], attributes: [NSAttributedStringKey.font : self.buttonFont], context: nil).size.width ?? 64
            self.bottomLine.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self)
                make.size.equalTo(CGSize.init(width: textWidth, height: 2))
                make.centerX.equalTo(self.buttons[currentIndex].snp.centerX)
            }
            self.selectedView.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: textWidth+35, height: 32))
                make.centerX.equalTo(self.buttons[currentIndex].snp.centerX)
                make.centerY.equalTo(self.buttons[currentIndex].snp.centerY)
            }
            self.layoutIfNeeded()
        }
        
    }
    
    public func enableBottomLine(_ enable: Bool) {
        self.bottomLine.isHidden = !enable
    }
    public func enableSelectView(_ enable: Bool) {
        self.selectedView.isHidden = !enable
    }
    
    public func updateTitles(_ titles: [String]) {
        for i in 0..<buttons.count {
            buttons[i].setTitle(titles[i], for: .normal)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc public func buttonClicked(_ sender: UIButton) -> Void {
        print("buttonClicked")
        self.handle?(sender.tag)
        self.updateUIDidEndScrolling(currentIndex: sender.tag)
    }
    
}
