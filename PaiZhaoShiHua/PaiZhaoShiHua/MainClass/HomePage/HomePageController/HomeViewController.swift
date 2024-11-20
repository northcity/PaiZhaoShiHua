//
//  HomeViewController.swift
//  PaiZhaoShiHua
//
//  Created by NorthCityDevMac on 2024/11/20.
//  Copyright © 2024 com.beicheng. All rights reserved.
//

//
//  HomeViewController.swift
//  PaiZhaoShiHua
//
//  Created by NorthCityDevMac on 2024/11/20.
//  Copyright © 2024 com.beicheng. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置背景色
        view.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "拍照识花"
        titleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 28)
        titleLabel.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 搜索栏
        let searchView = UIView()
        searchView.backgroundColor = .white
        searchView.layer.cornerRadius = 12
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowOpacity = 0.1
        searchView.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchView.layer.shadowRadius = 5
        view.addSubview(searchView)
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0)
        searchView.addSubview(searchIcon)
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(20)
        }
        
        let searchTextField = UITextField()
        searchTextField.placeholder = "输入你要了解的花的名称"
        searchTextField.font = UIFont(name: "PingFangSC-Regular", size: 14)
        searchTextField.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        searchView.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        // 卡片容器
        let cardContainer = UIView()
        view.addSubview(cardContainer)
        
        cardContainer.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // 卡片内容
        let cardTitles = ["拍照识花", "植物百科", "我的记录", "系统设置"]
        let cardSubtitles = [
            "拍摄照片一键识别种类",
            "专业植物百科全书",
            "记录你的每一次查看与识别",
            "支持我们一下吧"
        ]
        let cardIcons = ["camera", "book.closed", "note.text", "gearshape"]
        
        let numberOfColumns = 2
        let cardSpacing: CGFloat = 15
        var previousCard: UIView?
        var currentRowCards: [UIView] = []

        for i in 0..<cardTitles.count {
            let cardView = UIView()
            cardView.backgroundColor = .white
            cardView.layer.cornerRadius = 12
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 5
            cardContainer.addSubview(cardView)
            
            cardView.snp.makeConstraints { make in
                if i % numberOfColumns == 0 { // Start of a new row
                    make.leading.equalToSuperview()
                    
                    if let previousCard = previousCard {
                        make.top.equalTo(previousCard.snp.bottom).offset(cardSpacing)
                    } else {
                        make.top.equalToSuperview()
                    }
                } else { // Second column
                    make.leading.equalTo(previousCard!.snp.trailing).offset(cardSpacing)
                    make.top.equalTo(previousCard!)
                    make.width.equalTo(previousCard!)
                }
                
                if i % numberOfColumns == numberOfColumns - 1 { // Last column
                    make.trailing.equalToSuperview()
                }
                
                make.height.equalTo(140) // 卡片固定高度
            }
            
            // 图标
            let iconView = UIImageView(image: UIImage(systemName: cardIcons[i]))
            iconView.tintColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
            cardView.addSubview(iconView)
            
            iconView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(15)
                make.centerX.equalToSuperview()
                make.size.equalTo(40)
            }
            
            // 标题
            let titleLabel = UILabel()
            titleLabel.text = cardTitles[i]
            titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 16)
            titleLabel.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
            titleLabel.textAlignment = .center
            cardView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(iconView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            
            // 副标题
            let subtitleLabel = UILabel()
            subtitleLabel.text = cardSubtitles[i]
            subtitleLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
            subtitleLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0)
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 2
            cardView.addSubview(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
            }
            
            previousCard = cardView
            if i % numberOfColumns == numberOfColumns - 1 {
                currentRowCards.removeAll()
            }
            currentRowCards.append(cardView)
        }
    }
}

