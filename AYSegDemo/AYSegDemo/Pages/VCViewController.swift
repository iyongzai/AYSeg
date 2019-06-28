//
//  VCViewController.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/14.
//  Copyright © 2018年 ayong. All rights reserved.
//

import UIKit
import EX

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
class VCViewController: UIViewController, AYSegPage {
    
    var viewIsVisable: Bool = false
    
    var owner: UIViewController?    
    
    
    var showText = "VCViewController"
    var btnTitle = "Test button 1"
    
    private lazy var testBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(btnTitle, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.ayCornerRadius = 22
        
        return btn
    }()
    
    private lazy var bezierText: BezierText = {
        let bezierText = BezierText.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(30+44)))
        
        return bezierText
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviews()
        self.addConstraints()
        self.adjustUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewIsVisable else {
            return
        }
        bezierText.show(text: showText)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension VCViewController: UI {
    func addSubviews() {
        self.view.addSubview(testBtn)
        self.view.addSubview(bezierText)
    }
    func addConstraints() {
        testBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(44)
        }
        bezierText.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(testBtn.snp.top).offset(-30)
        }
    }
    func adjustUI() {
        self.view.backgroundColor = UIColor.theme
        //bezierText.backgroundColor = UIColor.selectedBG
    }
}


