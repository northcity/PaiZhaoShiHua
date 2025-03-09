//
//  DisplayViewController.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/2/25.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
import SwiftyMarkdown
import SnapKit
import CoreData

class DisplayViewController: UIViewController {
    var markdownContent: String?
    var imageUrl: String?
    var imageData: UIImage?
    var record: HistoryRecord?
    
    // 页面组件
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 图片卡片
    private let imageCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.cellBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 10
        return view
    }()
    
    // 图片容器
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent.withAlphaComponent(0.05)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // 图片视图
    private let progressImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    // 文本卡片
    private let textCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.cellBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 10
        return view
    }()
    
    // 文本视图
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false // 禁用内部滚动，使用外部scrollView
        tv.backgroundColor = .clear
        tv.font = UIFont(name: "Chalkboard SE", size: 16) ?? UIFont.systemFont(ofSize: 16)
        tv.textColor = AppColor.primaryText
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return tv
    }()
    
    // 标题标签
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
        label.textColor = AppColor.primaryText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // 分割标签
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textColor = AppColor.accent
        label.text = "详细信息"
        return label
    }()
    
    // 加载指示器
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColor.accent
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = AppColor.accent.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullContent = markdownContent ?? ""
        setupUI()
        loadImage()
        loadContent()
//        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: NSNotification.Name("DashScopeUpdate"), object: nil)
        // 监听流式更新
        NotificationCenter.default.addObserver(self, selector: #selector(handleStreamingUpdate(_:)), name: NSNotification.Name("StreamingUpdate"), object: nil)
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(finalUpdate),
                                                 name: NSNotification.Name("StreamComplete"),
                                                 object: nil)
    }
    
    @objc private func finalUpdate() {
        // 最后一次保存确保数据完整
        saveToLocalDatabase()
        // 可以在这里添加UI完成状态更新
    }
    private var fullContent: String = ""

    private func saveToLocalDatabase() {
        // 你的数据库保存逻辑
        if let record = self.record {
            record.content = fullContent
            CoreDataManager.shared.saveContext()
        }
    }
    
    @objc private func handleStreamingUpdate(_ notification: Notification) {
        guard let newContent = notification.object as? String else { return }
        
        
        DispatchQueue.main.async {
            self.fullContent += newContent
            self.markdownContent = self.fullContent
            self.loadContent()
            
//            // 自动滚动到底部（带动画）
//            UIView.animate(withDuration: 0.3) {
//                let bottomOffset = CGPoint(
//                    x: 0,
//                    y: max(0, self.textView.contentSize.height - self.textView.bounds.height)
//                )
//                self.textView.setContentOffset(bottomOffset, animated: false)
//            }
//            
//            // 或者更精确的文本范围滚动方式
//            let end = self.textView.textStorage.length
//            self.textView.scrollRangeToVisible(NSRange(location: end, length: 0))
            
            // 每次更新后保存到数据库（可选）
            self.saveToLocalDatabase()
        }
    }
    
    private func setupUI() {
        // 设置背景和导航
        view.backgroundColor = AppColor.background
        navigationItem.title = "识花结果"
        
        // 添加关闭按钮
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        // 设置滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        // 添加标题
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        
        // 添加图片卡片
        contentView.addSubview(imageCard)
        imageCard.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(imageCard.snp.width)
        }
        
        // 图片容器
        imageCard.addSubview(imageContainer)
        imageContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        // 图片
        imageContainer.addSubview(progressImageView)
        progressImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 加载指示器
        imageContainer.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 分割标签
        contentView.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCard.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
        }
        
        // 添加文本卡片
        contentView.addSubview(textCard)
        textCard.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200) // 设置初始高度
            make.bottom.lessThanOrEqualToSuperview().offset(-32) // 改为 lessThanOrEqualTo
        }
        
        // 文本视图
        textCard.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadImage() {
        activityIndicator.startAnimating()
        
        if let record = self.record {
            
            // 加载图片
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageURL = documentsDirectory.appendingPathComponent(record.imagePath ?? "")
            
            UIView.transition(with: self.progressImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.progressImageView.image = UIImage(contentsOfFile: imageURL.path)
            }) { _ in
                self.activityIndicator.stopAnimating()
            }
            
        } else if let imageData = self.imageData {
            self.progressImageView.image = imageData
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    private func loadContent() {

        // 延迟一点点再显示，添加动画效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            // 加载图片
            if let record = self.record {
                // 标题设置
                let title = self.extractTitle(from: record.content ?? "未知花卉")
                self.titleLabel.text = title
                
//                // 加载图片
//                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let imageURL = documentsDirectory.appendingPathComponent(record.imagePath ?? "")
//                
//                UIView.transition(with: self.progressImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
//                    self.progressImageView.image = UIImage(contentsOfFile: imageURL.path)
//                }) { _ in
//                    self.activityIndicator.stopAnimating()
//                }
//                
                // 处理Markdown内容
                if let md = record.content {
                    let swiftyMarkdown = SwiftyMarkdown(string: md)
                    self.customizeMarkdownStyle(swiftyMarkdown)
                    self.textView.attributedText = swiftyMarkdown.attributedString()
                    
                    // 重新调整textCard高度
                    self.updateTextCardHeight()
                }
            } else if let imageData = self.imageData {
//                self.progressImageView.image = imageData
//                self.activityIndicator.stopAnimating()
                
                if let md = self.markdownContent {
                    let swiftyMarkdown = SwiftyMarkdown(string: md)
                    self.customizeMarkdownStyle(swiftyMarkdown)
                    self.textView.attributedText = swiftyMarkdown.attributedString()
                    
                    // 提取标题
                    let title = self.extractTitle(from: md)
                    self.titleLabel.text = title
                    
                    // 重新调整textCard高度
                    self.updateTextCardHeight()
                }
            }
        }
    }
    
    private func updateTextCardHeight() {
        // 确保主线程执行
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.updateTextCardHeight()
            }
            return
        }
        
        // 确保视图已布局
        guard textView.frame.width > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.updateTextCardHeight()
            }
            return
        }
        
        // 使用 textView 的 textContainer 实际可用宽度
        let textContainerWidth = textView.frame.width
            - textView.textContainerInset.left
            - textView.textContainerInset.right
            - 2 * textView.textContainer.lineFragmentPadding
        
        // 获取实际排版属性
        let attributes: [NSAttributedString.Key: Any] = [
            .font: textView.font ?? UIFont.systemFont(ofSize: 17),
            .paragraphStyle: textView.typingAttributes[.paragraphStyle] ?? NSParagraphStyle.default
        ]
        
        // 精确计算文本高度
        let textString = textView.attributedText?.string ?? ""
        let calculatedHeight: CGFloat = {
            guard !textString.isEmpty else { return 200 }
            
            let constraintRect = CGSize(
                width: textContainerWidth,
                height: CGFloat.greatestFiniteMagnitude
            )
            
            let options: NSStringDrawingOptions = [
                .usesLineFragmentOrigin,
                .usesFontLeading,
                .truncatesLastVisibleLine // 包含可能的截断行
            ]
            
            let boundingBox = textString.boundingRect(
                with: constraintRect,
                options: options,
                attributes: attributes,
                context: nil
            )
            
            // 包含所有内边距和额外间距
            return ceil(boundingBox.height)
                + textView.textContainerInset.top
                + textView.textContainerInset.bottom
                + 16 // 自定义安全间距
        }()
        
        // 约束更新逻辑
        textCard.snp.remakeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(calculatedHeight).priority(.high) // 设置高优先级
        }
        
        // 动态底部约束
        contentView.snp.remakeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(textCard.snp.bottom).offset(32)
        }
        
        // 强制刷新布局
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // 二次校准：检查实际显示行数
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
//                guard let self = self else { return }
//                
//                // 获取实际渲染行数
//                let actualLineCount = self.textView.layoutManager.numberOfLines
//                
//                // 计算预期行数（考虑段落样式）
//                var expectedLineCount = 0
//                let storage = self.textView.textStorage
//                storage.enumerateAttribute(.paragraphStyle, in: NSRange(location: 0, length: storage.length)) { _, range, _ in
//                    let paragraphString = storage.attributedSubstring(from: range).string
//                    expectedLineCount += paragraphString.components(separatedBy: .newlines).count
//                }
//                
//                // 动态补偿高度（基于行高）
//                if actualLineCount < expectedLineCount {
//                    let lineHeight = self.textView.font?.lineHeight ?? 20
//                    let missingLines = expectedLineCount - actualLineCount
//                    let compensation = CGFloat(missingLines) * lineHeight
//                    
//                    self.textCard.snp.updateConstraints { make in
//                        make.height.equalTo(calculatedHeight + compensation)
//                    }
//                    
//                    UIView.animate(withDuration: 0.3) {
//                        self.view.layoutIfNeeded()
//                    }
//                }
//            }
    }
    
    // 提取标题（假设Markdown第一行是标题）
    private func extractTitle(from markdown: String) -> String {
        let lines = markdown.components(separatedBy: .newlines)
        if let firstLine = lines.first {
            // 去除Markdown标题标记
            let title = firstLine.replacingOccurrences(of: "# ", with: "")
                                .replacingOccurrences(of: "#", with: "")
                                .trimmingCharacters(in: .whitespaces)
            return title
        }
        return "花卉识别结果"
    }
    
    // 自定义Markdown样式
    private func customizeMarkdownStyle(_ markdown: SwiftyMarkdown) {
        // 设置字体名称
        let fontName = "Chalkboard SE"
        
        // 设置各级标题和正文字体
        markdown.body.fontName = fontName
        markdown.h1.fontName = fontName
        markdown.h2.fontName = fontName
        markdown.h3.fontName = fontName
        markdown.h4.fontName = fontName
        markdown.code.fontName = "Menlo" // 使用等宽字体显示代码
        
        // 设置字体大小
        markdown.body.fontSize = 16
        markdown.h1.fontSize = 22
        markdown.h2.fontSize = 20
        markdown.h3.fontSize = 18
        markdown.h4.fontSize = 16
        markdown.code.fontSize = 15
        
        // 设置颜色
        markdown.body.color = AppColor.primaryText
        markdown.h1.color = AppColor.primaryText
        markdown.h2.color = AppColor.primaryText
        markdown.h3.color = AppColor.primaryText
        markdown.h4.color = AppColor.primaryText
        
        // 其他样式
        markdown.link.color = AppColor.accent
        markdown.bold.color = AppColor.primaryText
        markdown.italic.color = AppColor.primaryText
        
        // 设置字重
        markdown.h1.fontStyle = .bold
        markdown.h2.fontStyle = .bold
        
        // 段落间距
        markdown.body.paragraphSpacing = 12
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 更新阴影路径
        imageCard.layer.shadowPath = UIBezierPath(roundedRect: imageCard.bounds, cornerRadius: imageCard.layer.cornerRadius).cgPath
        textCard.layer.shadowPath = UIBezierPath(roundedRect: textCard.bounds, cornerRadius: textCard.layer.cornerRadius).cgPath
    }
}

// 添加扩展方法计算行数
extension NSLayoutManager {
    var numberOfLines: Int {
        var numberOfLines = 0
        let numberOfGlyphs = self.numberOfGlyphs
        var index = 0
        
        while index < numberOfGlyphs {
            var lineRange = NSRange(location: 0, length: 0)
            self.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            numberOfLines += 1
            index = NSMaxRange(lineRange)
        }
        
        return numberOfLines
    }
}
