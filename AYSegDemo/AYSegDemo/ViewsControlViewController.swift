//
//  ViewsControlViewController.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/14.
//  Copyright © 2018年 ayong. All rights reserved.
//

import UIKit
import EX

class ViewsControlViewController: UIViewController, AYSegViewDataSource, AYSegViewDelegate {
    
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
    
    //step2：遵循AYSegViewDelegate和AYSegViewDataSource协议，实现AYSegViewDataSource协议，提供数据源
    private lazy var page1: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        page.showText = "DemoView1"
        
        return page
    }()
    private lazy var page2: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        page.showText = "DemoView2"
        
        return page
    }()
    private lazy var page3: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        page.showText = "DemoView3"
        
        return page
    }()
    private lazy var page4: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        page.showText = "DemoView4"
        
        return page
    }()
    
    lazy var pages: [AYSegPage] = [page1, page2, page3, page4]
    
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



extension ViewsControlViewController: UI {
    func addSubviews() {
        self.view.addSubview(segView)
    }
    func addConstraints() {
        segView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func adjustUI() {
        self.navigationItem.title = "所有分页用View控制"
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


extension ViewsControlViewController {
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
