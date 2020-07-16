//
//  Protocols.swift
//  AYSegDemo
//
//  Created by zhiyong yin on 2020/7/15.
//  Copyright © 2020 ayong. All rights reserved.
//

import Foundation
import UIKit


// MARK: - 每个分页遵循AYSegPage协议。
@objc public protocol AYSegPage {
    var viewIsVisable: Bool {get set}
    var owner: UIViewController? {get set}
    var view: UIView! {get set}
    
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

////////////////////////////////////AYSegViewDelegate协议////////////////////////////////////
@objc public protocol AYSegViewDelegate: class {
    /// 滑动切换分页
    ///
    /// - Parameters:
    ///   - scrollView: bodyScrollView
    ///   - seg: 当前SegView实例
    ///   - view: 当前显示的页面
    ///   - previousView: 之前的页面
    /// - Returns: Void
    @objc optional func scrollView(_ scrollView: UIScrollView, seg: AYSegView, viewDidappear currentPage: AYSegPage, previousPage: AYSegPage?) -> Void
    
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView) -> Void
}

////////////////////////////////////AYSegViewDataSource协议////////////////////////////////////
@objc public protocol AYSegViewDataSource: class {
    /// 提供数据源--个数
    ///
    /// - Parameter segView: 传递当前的segView实例
    /// - Returns: 提供需要展现的个数
    //func numberOfPage(segView: AYSegView) -> Int
    
    //上面的方法废弃，采用下面的方式
    var pages: [AYSegPage] {get set}

    
    
    /// 提供数据源--显示的View
    ///
    /// - Parameters:
    ///   - segView: 传递当前的segView实例
    ///   - page: 当前的页码
    /// - Returns: 提供当前页码需要展现的View
    //func viewForPage(segView: AYSegView, page: Int) -> AYSegPage
}


@objc public protocol AYSegHeader where Self: UIView {
    func updateUIDidEndScrolling(currentIndex: Int)
    weak var segView: AYSegView? { set get }
    var handle: AYSegHandle? { get }
}
