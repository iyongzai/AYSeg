//
//  TestGradientTXTButton.swift
//  AYSegDemo
//
//  Created by zhiyong yin on 2020/7/6.
//  Copyright © 2020 ayong. All rights reserved.
//

import UIKit

class TestGradientTXTButtonVC: UIViewController {
    @IBOutlet weak var gradientButton: GradientTXTButton!
    
    class func loadVC() -> TestGradientTXTButtonVC {
        return TestGradientTXTButtonVC.init(nibName: "TestGradientTXTButtonVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientButton.setTitle("法币账号", forState: .normal)
//        gradientButton.setFont(UIFont.systemFont(ofSize: 15), forState: .normal)
//        gradientButton.setFont(UIFont.boldSystemFont(ofSize: 36), forState: .selected)
//        gradientButton.setTitleColors([UIColor.red, UIColor.yellow], forState: .normal)
//        gradientButton.setTitleColors([UIColor.blue, UIColor.green], forState: .selected)
        gradientButton.addTargetForTouch(self, action: #selector(self.click(_:)))
    }
    
    @objc private func click(_ sender: GradientTXTButton) {
        print("******")
        sender.isSelected = !sender.isSelected
    }
    
}
