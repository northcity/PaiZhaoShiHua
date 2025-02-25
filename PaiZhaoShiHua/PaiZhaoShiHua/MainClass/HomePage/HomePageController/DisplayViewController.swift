//
//  File.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/2/25.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
 
class DisplayViewController: UIViewController {
    var responseText: String?
    private let contentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        title = "API响应"
        
        // 配置Label
        contentLabel.numberOfLines  = 0
        contentLabel.textAlignment  = .center
        contentLabel.text  = responseText ?? "无响应内容"
        contentLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        // 添加布局
        view.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo:  view.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo:  view.centerYAnchor),
            contentLabel.leadingAnchor.constraint(greaterThanOrEqualTo:  view.leadingAnchor,  constant: 20),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo:  view.trailingAnchor,  constant: -20)
        ])
    }
}
