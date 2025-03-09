//
//  HistoryCell.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
import SnapKit

class HistoryCell: UITableViewCell {
    // 卡片容器
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.cellBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    // 缩略图容器
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent.withAlphaComponent(0.05)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // 缩略图
    private let thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    // 文字内容
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont(name: "Chalkboard SE", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textColor = AppColor.primaryText
        return label
    }()
    
    // 日期
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 13) ?? UIFont.systemFont(ofSize: 13)
        label.textColor = AppColor.secondaryText
        return label
    }()
    
    // 图标
    private let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        iv.tintColor = AppColor.accent.withAlphaComponent(0.5)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        // 选中样式
        selectionStyle = .none
        backgroundColor = .clear
        
        // 添加子视图
        contentView.addSubview(cardView)
        cardView.addSubview(imageContainer)
        imageContainer.addSubview(thumbImageView)
        cardView.addSubview(contentLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(iconView)
        
        // 设置约束
        cardView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageContainer.snp.trailing).offset(16)
            make.trailing.equalTo(iconView.snp.leading).offset(-12)
            make.top.equalToSuperview().offset(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        iconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 确保阴影正确绘制
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cardView.layer.cornerRadius).cgPath
    }
    
    // 触摸动画
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateScale(0.97)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateScale(1.0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateScale(1.0)
    }
    
    private func animateScale(_ scale: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    // 数据绑定
    func configure(with record: HistoryRecord) {
        contentLabel.text = record.content
        
        // 美化日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        
        if let createDate = record.createDate {
            // 如果日期是今天，显示"今天 HH:mm"
            if Calendar.current.isDateInToday(createDate) {
                dateLabel.text = "今天 " + DateFormatter.localizedString(
                    from: createDate,
                    dateStyle: .none,
                    timeStyle: .short
                )
            } else {
                dateLabel.text = dateFormatter.string(from: createDate)
            }
        }
        
        // 图片加载逻辑
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsDirectory.appendingPathComponent(record.imagePath ?? "")
        
        // 添加图片加载动画
        UIView.transition(with: thumbImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.thumbImageView.image = UIImage(contentsOfFile: imageURL.path)
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
