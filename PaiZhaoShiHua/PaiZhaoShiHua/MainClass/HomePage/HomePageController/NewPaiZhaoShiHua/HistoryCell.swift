//
//  File.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import Foundation
class HistoryCell: UITableViewCell {
    private let cardView = UIView()
      private let thumbImageView = UIImageView()
      private let contentLabel = UILabel()
      private let dateLabel = UILabel()
      
      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          setupUI()
          setupConstraints()
      }
      
      private func setupUI() {
          // 卡片容器
          cardView.backgroundColor = .white
          cardView.layer.cornerRadius = 12
          cardView.layer.shadowColor = UIColor.black.cgColor
          cardView.layer.shadowOpacity = 0.08
          cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
          cardView.layer.shadowRadius = 6
          contentView.addSubview(cardView)
          
          // 缩略图
          thumbImageView.contentMode = .scaleAspectFill
          thumbImageView.clipsToBounds = true
          thumbImageView.layer.cornerRadius = 8
          thumbImageView.layer.borderWidth = 0.5
          thumbImageView.layer.borderColor = UIColor.systemGray5.cgColor
          cardView.addSubview(thumbImageView)
          
          // 文字内容
          contentLabel.numberOfLines = 2
          contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
          contentLabel.textColor = .darkText
          cardView.addSubview(contentLabel)
          
          // 日期
          dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
          dateLabel.textColor = .secondaryLabel
          cardView.addSubview(dateLabel)
          
          // 选中样式
          selectionStyle = .none
          backgroundColor = .clear
      }
      
      private func setupConstraints() {
          cardView.snp.makeConstraints { make in
              make.top.bottom.equalToSuperview().inset(8)
              make.leading.trailing.equalToSuperview().inset(16)
          }
          
          thumbImageView.snp.makeConstraints { make in
              make.leading.equalToSuperview().offset(16)
              make.centerY.equalToSuperview()
              make.size.equalTo(CGSize(width: 72, height: 72))
          }
          
          contentLabel.snp.makeConstraints { make in
              make.leading.equalTo(thumbImageView.snp.trailing).offset(16)
              make.trailing.equalToSuperview().offset(-16)
              make.top.equalToSuperview().offset(16)
          }
          
          dateLabel.snp.makeConstraints { make in
              make.leading.equalTo(contentLabel)
              make.top.equalTo(contentLabel.snp.bottom).offset(6)
              make.bottom.equalToSuperview().offset(-16)
          }
      }
      
      // 数据绑定保持原有逻辑不变
      func configure(with record: HistoryRecord) {
          contentLabel.text = record.content
          dateLabel.text = DateFormatter.localizedString(
              from: record.createDate ?? Date(),
              dateStyle: .medium,
              timeStyle: .short
          )
          
          // 图片加载逻辑保持原有方式
          let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
          let imageURL = documentsDirectory.appendingPathComponent(record.imagePath ?? "")
          thumbImageView.image = UIImage(contentsOfFile: imageURL.path)
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
