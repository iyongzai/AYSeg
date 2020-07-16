//
//  ViewController.swift
//  AYSegDemo
//
//  Created by Tyler.Yin on 2018/9/13.
//  Copyright © 2018年 ayong. All rights reserved.
//

import UIKit
import EX


extension UIColor {
    static let theme = UIColor.init(red: 36.0/255.0, green: 39.0/255.0, blue: 54.0/255.0, alpha: 1)//主题深蓝
    static let navBGColor = theme
}


private let cellReuseIdentifier = "CellReuseIdentifier"
class ViewController: UIViewController {

    private var dataSource = ["拖控件方式示例", "所有分页用VC控制", "所有分页用View控制", "page中既有VC控制又有View控制", "TestAYGradientSegViewVC", "TestOtherVC"]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.16)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubviews()
        self.addConstraints()
        self.adjustUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //dataSource = ["拖控件方式示例", "所有分页用VC控制", "所有分页用View控制", "page中既有VC控制又有View控制"]
        switch indexPath.row {
        case 0://拖控件方式示例
            self.performSegue(withIdentifier: "goto_sbVC", sender: nil)
        case 1://"所有分页用VC控制"
            self.show(VCsControlViewController(), sender: nil)
        case 2://"所有分页用View控制"
            self.show(ViewsControlViewController(), sender: nil)
        case 3://"page中既有VC控制又有View控制"
            self.show(MixViewController(), sender: nil)
        case 4:
            self.show(TestAYGradientSegViewVC(), sender: nil)
        case 5:
            self.show(TestOtherVC(), sender: nil)
        default:
            break
        }
    }
}


//MARK: - UI
extension ViewController: UI {
    
    func addSubviews() {
        self.view.addSubview(tableView)
    }
    func addConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func adjustUI() {
        self.navigationItem.title = "AYSegDemo"
        self.view.backgroundColor = UIColor.theme
        tableView.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackground(UIColor.navBGColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
