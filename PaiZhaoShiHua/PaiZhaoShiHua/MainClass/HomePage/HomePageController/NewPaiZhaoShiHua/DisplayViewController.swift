//
//  File.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/2/25.
//  Copyright © 2025 com.beicheng. All rights reserved.
//


import UIKit
import SwiftyMarkdown
//import Kingfisher

class DisplayViewController: UIViewController {
    var markdownContent: String?
    private let textView = UITextView()  // 改用 UITextView
    
    var imageUrl:String?
    
    var imageData:UIImage?
    var record: HistoryRecord?

    // MARK: - 进阶版（带加载状态）
       private let progressImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.layer.masksToBounds = true
           iv.layer.cornerRadius = 16
           return iv
       }()
       
       private let activityIndicator = UIActivityIndicatorView(style: .medium)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "分析结果"


        view.addSubview(progressImageView)
        progressImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        // 加载指示器
        progressImageView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        // 配置支持滚动的 TextView
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        // SnapKit 布局
        textView.snp.makeConstraints { make in
            make.top.equalTo(progressImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        // 渲染 Markdown
        if let md = markdownContent {
            let swiftyMarkdown = SwiftyMarkdown(string: md)
            textView.attributedText = swiftyMarkdown.attributedString()
        }
        
        loadImages()
        guard let record = record else { return }
        
//        加载完整图片
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsDirectory.appendingPathComponent(record.imagePath ?? "")
        let image = UIImage(contentsOfFile: imageURL.path)
        progressImageView.image = image
        
        if let md = record.content {
            let swiftyMarkdown = SwiftyMarkdown(string: md)
            textView.attributedText = swiftyMarkdown.attributedString()
        }
        
    }
    
    // MARK: - 图片加载逻辑
    private func loadImages() {
        
//        progressImageView.image = imagedata
        // 基础版加载
        let basicURL = URL(string: "https://example.com/image1.jpg")
        
        progressImageView.image = imageData
//        
//        // 进阶版加载（带进度）
//        let progressURL = URL(string: imageUrl ?? "")
//        progressImageView.kf.setImage(
//            with: progressURL,
//            placeholder: nil,
//            options: [
//                .cacheOriginalImage,
//                .transition(.fade(0.5)),
//                .keepCurrentImageWhileLoading
//            ],
//            progressBlock: { [weak self] (received, total) in
//                let progress = Float(received) / Float(total)
//                print("下载进度: \(progress)")
//            },
//            completionHandler: { [weak self] _ in
//                self?.activityIndicator.stopAnimating()
//            }
//        )
//        activityIndicator.startAnimating()
    }
}
