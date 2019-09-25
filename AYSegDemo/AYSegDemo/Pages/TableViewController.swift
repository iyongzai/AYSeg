//
//  TableViewController.swift
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
class TableViewController: UITableViewController, AYSegPage {
    var viewIsVisable: Bool = false
    
    var owner: UIViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.adjustUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        
        cell.textLabel?.text = "Row: \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}

extension TableViewController: UI {
    func adjustUI() {
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
