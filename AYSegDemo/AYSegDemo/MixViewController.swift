//
//  MixViewController.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/14.
//  Copyright © 2018年 ayong. All rights reserved.
//

import UIKit
import EX

class MixViewController: UIViewController, AYSegViewDataSource, AYSegViewDelegate {
    
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
    private lazy var page1: TableViewController = {
        let page = TableViewController.init(style: .plain)
        
        return page
    }()
    private lazy var page2: VCViewController = {
        let page = VCViewController()
        page.showText = "VCViewController"
        page.btnTitle = "Test button"
        
        return page
    }()
    private lazy var page3: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        page.showText = "DemoView1"
        
        return page
    }()
    private lazy var page4: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        page.showText = "DemoView1"
        
        return page
    }()
    
    lazy var pages: [AYSegPage] = [page1, page2, page3, page4]
    
    private var segHeaderStyle = 0
    
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
    
    
    @objc private func changeSegHeaderStyle(_ sender: UIBarButtonItem) {
        segHeaderStyle = (segHeaderStyle+1)%3
        switch segHeaderStyle {
        case 0:
            (segView.header as? AYSegDefaultHeader)?.enableBottomLine(true)
            (segView.header as? AYSegDefaultHeader)?.enableSelectView(false)
            (segView.header as? AYSegDefaultHeader)?.bottomLine.backgroundColor = UIColor.white
        case 1:
            (segView.header as? AYSegDefaultHeader)?.enableBottomLine(true)
            (segView.header as? AYSegDefaultHeader)?.enableSelectView(false)
        case 2:
            (segView.header as? AYSegDefaultHeader)?.enableBottomLine(false)
            (segView.header as? AYSegDefaultHeader)?.enableSelectView(true)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



extension MixViewController: UI {
    func addSubviews() {
        self.view.addSubview(segView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "样式", style: .plain, target: self, action: #selector(MixViewController.changeSegHeaderStyle(_:)))
    }
    func addConstraints() {
        segView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func adjustUI() {
        self.navigationItem.title = "所有分页用VC控制"
        self.view.backgroundColor = UIColor.theme
        
        (segView.header as? AYSegDefaultHeader)?.updateTitles(["分页1", "分页2", "分页3", "分页4", "分页5"], selectedColor: UIColor.white)
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


extension MixViewController {
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
