//
//  SBDemoViewController.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/13.
//  Copyright © 2018年 ayong. All rights reserved.
//

import UIKit
import EX

class SBDemoViewController: UIViewController, AYSegViewDelegate, AYSegViewDataSource {
    
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
    
    //step1：创建AYSegView实例，添加到父视图
    @IBOutlet weak var segView: AYSegView!
    
    
    //step2：遵循AYSegViewDelegate和AYSegViewDataSource协议，实现AYSegViewDataSource协议，提供数据源
    private lazy var page1: DemoView = {
        let page = DemoView()
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        
        return page
    }()
    private lazy var page2: DemoView = {
        let page = DemoView()
        page.showText = "😊ayong😊"
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        
        return page
    }()
    private lazy var page3: DemoView = {
        let page = DemoView()
        page.showText = "微擎科技"
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        
        return page
    }()
    private lazy var page4: DemoView = {
        let page = DemoView()
        page.showText = "阿勇"
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        
        return page
    }()
    private lazy var page5: DemoView = {
        let page = DemoView()
        page.showText = "写点什么好呢！"
        page.backgroundColor = UIColor.randColor()
        page.owner = self
        
        return page
    }()
    lazy var pages: [AYSegPage] = [page1, page2, page3, page4, page5]
    
    

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SBDemoViewController: UI {
    func addSubviews() {
        
    }
    func addConstraints() {
        
    }
    func adjustUI() {
        self.navigationItem.title = "拖控件方式示例"
        self.view.backgroundColor = UIColor.theme
        segView.defaultHeader?.updateTitles(["分页1", "分页2", "分页3", "分页4", "分页5"], selectedColor: UIColor.white)
    }
    func addEvents() {
        segView.defaultHeader?.handle = { [weak self] (index: Int) in
            self?.segView.scrollToPage(index)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
