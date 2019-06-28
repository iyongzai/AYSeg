//
//  DemoView.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/14.
//  Copyright © 2018年 ayong. All rights reserved.
//

import UIKit

/*
 使用说明(很简单)：
 使用主要分2块：主控制器(vc/v)遵循AYSegViewDelegate和AYSegViewDataSource协议，副控制器(vc/v)遵循AYSegPage协议
 主控制器步骤：
 step1：创建AYSegView实例，添加到父视图
 step2：遵循AYSegViewDelegate和AYSegViewDataSource协议，实现AYSegViewDataSource协议，提供数据源
 step3：在viewDidAppear方法里面调用segView.reloadData()
 副控制器一个步骤：
 step1：遵循AYSegPage协议，实现协议
 */

//step1：遵循AYSegPage协议，实现协议
class DemoView: UIView, AYSegPage {
    var viewIsVisable: Bool = false
    
    var owner: UIViewController?
    
    var view: UIView {
        get{
            return self
        }
        set {
            print("set 调用无效")
        }
    }
    
    var showText = "iVCoin"
    
    
    private lazy var bezierText: BezierText = {
        let bezierText = BezierText.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(30+44)))
        
        return bezierText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.theme
        self.addSubview(bezierText)
        bezierText.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func viewWillAppear(_ animated: Bool) {
        print("AYPageDemoView--viewWillAppear")
    }
    func viewDidAppear(_ animated: Bool) {
        print("AYPageDemoView--viewDidAppear")
        
        guard viewIsVisable else {
            return
        }
        bezierText.show(text: showText)
    }
    func viewWillDisappear(_ animated: Bool) {
        print("AYPageDemoView--viewWillDisappear")
    }
    func viewDidDisappear(_ animated: Bool) {
        print("AYPageDemoView--viewDidDisappear")
    }
    
    
}
