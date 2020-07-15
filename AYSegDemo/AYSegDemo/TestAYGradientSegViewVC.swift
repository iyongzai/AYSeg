//
//  TestAYGradientSegViewVC.swift
//  AYSegDemo
//
//  Created by zhiyong yin on 2020/7/15.
//  Copyright © 2020 ayong. All rights reserved.
//


//import UIKit
//
//class TestAYGradientSegViewVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.theme
//
//        let gradientSegView = AYGradientTXTHeader()
//        self.view.addSubview(gradientSegView)
//        gradientSegView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(100)
//            make.left.equalToSuperview()
//            make.size.equalTo(CGSize.init(width: UIScreen.main.bounds.width, height: 40))
//        }
//    }
//
//}

import UIKit
import EX

class TestAYGradientSegViewVC: UIViewController, AYSegViewDataSource, AYSegViewDelegate {
    
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
    
    //step1：创建AYSegView实例（添加到父视图代码在其他代码行）
    private lazy var segView: AYSegView = {
        let segView = AYSegView.init(frame: self.view.bounds)
        //segView.backgroundColor = UIColor.clear
        segView.delegate = self
        segView.dataSource = self
        
        return segView
    }()
    
    private lazy var segHeader: AYGradientTXTHeader = {
        let titles = ["法币账户", "币币账户", "合约账户"]
        let normalFont = UIFont.init(name: pingFangRegular, size: 15)!
        let selectedFont = UIFont.init(name: pingFangRegular, size: 25)!
        
        let normalGradientParams = GradientParams.init(colors: ["#BEBEB0".uiColor(), "#BEBEB0".uiColor()])
        let selectedGradientParams = GradientParams.init(colors: ["#FDEA5D".uiColor(), "#F6921E".uiColor()])
        
        var normalItems: [AYGradientLabelConf] = []
        var selectedItems: [AYGradientLabelConf] = []
        titles.forEach { (title) in
            let normalItem = AYGradientLabelConf.init(text: title, font: normalFont, gradientParams: normalGradientParams)
            let selectedItem = AYGradientLabelConf.init(text: title, font: selectedFont, gradientParams: selectedGradientParams)
            normalItems.append(normalItem)
            selectedItems.append(selectedItem)
        }
        let header = AYGradientTXTHeader.init(items: normalItems, selectedItems: selectedItems)
        
        return header
    }()
    
    //step2：遵循AYSegViewDelegate和AYSegViewDataSource协议，实现AYSegViewDataSource协议，提供数据源
    private lazy var page1: VCViewController = {
        let page = VCViewController()
        page.showText = "VCViewController1"
        page.btnTitle = "Test button 1"
        
        return page
    }()
    private lazy var page2: VCViewController = {
        let page = VCViewController()
        page.showText = "VCViewController2"
        page.btnTitle = "Test button 2"
        
        return page
    }()
    private lazy var page3: VCViewController = {
        let page = VCViewController()
        page.showText = "VCViewController3"
        page.btnTitle = "Test button 3"
        
        return page
    }()
    
    
    lazy var pages: [AYSegPage] = [page1, page2, page3]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviews()
        self.addConstraints()
        self.adjustUI()
        self.addEvents()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //step3：viewDidAppear方法里面调用segView.reloadData()
        segView.reloadData()
        segView.setCustomHeader(segHeader, height: 60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension TestAYGradientSegViewVC: UI {
    func addSubviews() {
        self.view.addSubview(segView)
    }
    func addConstraints() {
        segView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func adjustUI() {
        self.navigationItem.title = "所有分页用VC控制"
        self.view.backgroundColor = UIColor.theme
        
    }
    func addEvents() {
        (segView.header as? AYSegDefaultHeader)?.handle = { [weak self] (index: Int) in
            self?.segView.scrollToPage(index)
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension TestAYGradientSegViewVC {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        pages.forEach { (page: AYSegPage) in
            (page as? UIViewController)?.viewWillTransition(to: size, with: coordinator)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+coordinator.transitionDuration) {
            self.segView.viewWillTransition(to: self.view.frame.size, with: coordinator)
        }
        
        
        self.view.layoutIfNeeded()
    }
}
