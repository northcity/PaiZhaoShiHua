//
//  SettingsViewController.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


// 在文件顶部定义全局颜色常量（放在 class 外部）
enum AppColor {
    static let background = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    static let cellBackground = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    static let accent = UIColor(red: 1, green: 0.2, blue: 0, alpha: 1)
    static let primaryText = UIColor.black
    static let secondaryText = UIColor.black.withAlphaComponent(0.7)
    
    static let separator = UIColor.black.withAlphaComponent(0.2)
    
}

class SettingsViewController: UIViewController {
    
    
    
    // MARK: - 颜色定义
    private enum Color {
        static let background = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        static let cellBackground = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        static let accent = UIColor(red: 1, green: 0.2, blue: 0, alpha: 1)
        static let primaryText = UIColor.black
        static let secondaryText = UIColor.black.withAlphaComponent(0.7)
    }
    
    // MARK: - 数据源
    private let sections: [[SettingItem]] = [
//        [
//            .init(icon: "crown.fill", title: "升级会员", detail: nil, type: .premium),
//            .init(icon: "arrow.clockwise", title: "恢复购买", detail: nil, type: .normal)
//        ],
//        [
//            .init(icon: "globe", title: "修改语言", detail: "曲", type: .normal),
//            .init(icon: "textformat", title: "字体管理", detail: "在短句里管理本地字体和谷歌字体", type: .normal)
//        ],
        [
            .init(icon: "sparkles", title: "新功能许愿池", detail: "告诉我们你的想法，说不定会实现哦", type: .normal),
            .init(icon: "square.and.arrow.up", title: "分享APP", detail: "和朋友分享，说不定他们也会喜欢~", type: .normal)
        ],
        [
            .init(icon: "message.fill", title: "微信", detail: "shine5211314", type: .contact),
            .init(icon: "person.crop.square", title: "微博", detail: "陈年小城", type: .contact),
            .init(icon: "camera.fill", title: "小红书", detail: "@北城", type: .contact),
            .init(icon: "envelope.fill", title: "发送邮件", detail: "506343892@qq.com", type: .contact)
        ],
        [
//            .init(icon: nil, title: "服务条款", detail: nil, type: .legal),
            .init(icon: nil, title: "隐私政策", detail: nil, type: .legal)
        ]
    ]
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = Color.background
        tv.separatorColor = UIColor(white: 0.2, alpha: 1)
        tv.register(SettingCell.self, forCellReuseIdentifier: "cell")
        tv.sectionHeaderHeight = 32
        tv.sectionFooterHeight = 0
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "设置"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.background
        appearance.titleTextAttributes = [.foregroundColor: Color.primaryText]
        appearance.largeTitleTextAttributes = [.foregroundColor: Color.primaryText]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupUI() {
        view.backgroundColor = Color.background
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        SVProgressHUD.showInfo(withStatus: "复制成功")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    func shareLink(url: URL, title: String) {
            // 1. 准备分享内容
            let items: [Any] = [title, url] // 标题优先显示，URL自动识别为链接
            
            // 2. 初始化分享控制器
            let activityVC = UIActivityViewController(
                activityItems: items,
                applicationActivities: nil
            )
            
            // 3. 排除不需要的操作类型（可选）
            activityVC.excludedActivityTypes = [
                .addToReadingList,
                .assignToContact,
                .saveToCameraRoll
            ]
            
            // 4. 设置完成回调（可选）
            activityVC.completionWithItemsHandler = { activityType, success, items, error in
                if success {
                    print("分享成功，平台：\(activityType?.rawValue ?? "未知")")
                } else {
                    print("用户取消分享")
                }
            }
            
            // 5. 弹出分享界面（适配 iPad）
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            }
            present(activityVC, animated: true)
        }
        
        // 调用示例
        func onShareButtonClick() {
            let url = URL(string: "itms-apps://itunes.apple.com/cn/app/id1439881374?mt=8")!
            shareLink(url: url, title: "我正在使用 拍照识花应用。它真的是一个很方便的识别花朵的App。现在就分享给你吧。\n在这里下载它：\niOS: itms-apps://itunes.apple.com/cn/app/id1439881374?mt=8")
        }
}

// MARK: - 表格数据源和代理
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        cell.configure(with: sections[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = sections[indexPath.section][indexPath.row]
        if item.type == .contact {
            if let detail = item.detail {
                self.copyToClipboard(detail)
            }
        }
        
        if item.title == "隐私政策" {
            guard let url = URL(string: "http://www.northcity.top/2018/11/16/PaiZhaoShiHuaPrivacyPolicy/") else {
                print("URL格式无效")
                return
            }
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    print("打开链接失败，错误原因：网络问题或系统限制")
                }
            }
        }
        
        if item.title == "新功能许愿池" {
            self.feedBackUseMail()
        }
        
        if item.title == "分享APP" {
            self.onShareButtonClick()
        }
        
        

        
        
//        http://www.northcity.top/2018/11/16/PaiZhaoShiHuaPrivacyPolicy/
    }
}

// MARK: - 自定义单元格
class SettingCell: UITableViewCell {
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppColor.accent
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = AppColor.primaryText
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = AppColor.secondaryText
        return label
    }()
    
    private let accessoryIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = AppColor.secondaryText
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = AppColor.cellBackground
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        
        contentView.addSubview(iconView)
        contentView.addSubview(stackView)
        contentView.addSubview(accessoryIcon)
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(accessoryIcon.snp.leading).offset(-16)
        }
        
        accessoryIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with item: SettingItem) {
        titleLabel.text = item.title
        detailLabel.text = item.detail
        
        if let icon = item.icon {
            iconView.image = UIImage(systemName: icon)
        } else {
            iconView.image = nil
        }
        
        switch item.type {
        case .premium:
            titleLabel.textColor = AppColor.accent
            titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            accessoryIcon.isHidden = true
        case .legal:
            accessoryIcon.isHidden = true
//            stackView.snp.remakeConstraints {
//                $0.leading.equalToSuperview().offset(20)
//                $0.centerY.equalToSuperview()
//            }
        default:
            titleLabel.textColor = AppColor.primaryText
            accessoryIcon.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SettingItem {
    let icon: String?
    let title: String
    let detail: String?
    let type: ItemType
    
    enum ItemType {
        case premium
        case normal
        case contact
        case legal
    }
}
