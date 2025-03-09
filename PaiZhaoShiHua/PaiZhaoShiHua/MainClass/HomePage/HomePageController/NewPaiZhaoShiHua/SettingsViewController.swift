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
import MessageUI

// 在文件顶部定义全局颜色常量（放在 class 外部）
enum AppColor {
    static let background = UIColor(red: 0.98, green: 0.96, blue: 1.0, alpha: 1) // 淡紫色背景
    static let cellBackground = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1) // 纯白色
    static let accent = UIColor(red: 1.0, green: 0.5, blue: 0.7, alpha: 1) // 粉色
    static let primaryText = UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1) // 深紫色
    static let secondaryText = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1) // 浅紫色
    static let separator = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1) // 浅灰紫色
}

class SettingsViewController: UIViewController {
    
    // MARK: - 数据源
    private let sections: [[SettingItem]] = [
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
            .init(icon: nil, title: "隐私政策", detail: nil, type: .legal)
        ]
    ]
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = AppColor.background
        tv.separatorStyle = .none
        tv.register(SettingCell.self, forCellReuseIdentifier: "cell")
        tv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tv.sectionHeaderHeight = 40
        tv.sectionFooterHeight = 0
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
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
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = AppColor.background.withAlphaComponent(0.8)
        appearance.titleTextAttributes = [
            .foregroundColor: AppColor.primaryText,
            .font: UIFont(name: "Chalkboard SE", size: 17) ?? UIFont.systemFont(ofSize: 17)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppColor.primaryText,
            .font: UIFont(name: "Chalkboard SE", size: 34) ?? UIFont.systemFont(ofSize: 34)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColor.accent
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.background
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        
        // 创建一个可爱的自定义提示
        let toastView = UIView()
        toastView.backgroundColor = AppColor.accent.withAlphaComponent(0.9)
        toastView.layer.cornerRadius = 20
        
        let label = UILabel()
        label.text = "✓ 复制成功"
        label.textColor = .white
        label.font = UIFont(name: "Chalkboard SE", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        
        toastView.addSubview(label)
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(50)
        }
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        // 添加弹出动画
        toastView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: {
            toastView.transform = CGAffineTransform.identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.8, options: [], animations: {
                toastView.alpha = 0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
    }
    
    func shareLink(url: URL, title: String) {
        let items: [Any] = [title, url]
        
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        activityVC.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .saveToCameraRoll
        ]
        
        activityVC.completionWithItemsHandler = { activityType, success, items, error in
            if success {
                print("分享成功，平台：\(activityType?.rawValue ?? "未知")")
            } else {
                print("用户取消分享")
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        present(activityVC, animated: true)
    }
    
    func onShareButtonClick() {
        let url = URL(string: "itms-apps://itunes.apple.com/cn/app/id1439881374?mt=8")!
        shareLink(url: url, title: "我正在使用 拍照识花应用。它真的是一个很方便的识别花朵的App。现在就分享给你吧。\n在这里下载它：\niOS: itms-apps://itunes.apple.com/cn/app/id1439881374?mt=8")
    }
    
    // 添加反馈邮件功能
    func feedBackUseMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["506343892@qq.com"])
            mailComposeVC.setSubject("拍照识花 - 功能反馈")
            mailComposeVC.setMessageBody("请在这里描述您的想法或建议：\n\n", isHTML: false)
            present(mailComposeVC, animated: true)
        } else {
            // 提示用户设置邮箱
            let alert = UIAlertController(
                title: "无法发送邮件",
                message: "请检查您的邮箱设置，或直接联系我们：506343892@qq.com",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "复制邮箱", style: .default) { _ in
                self.copyToClipboard("506343892@qq.com")
            })
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
            present(alert, animated: true)
        }
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
        return 70 // 统一的行高
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    }
}

// MARK: - 邮件发送代理
//extension SettingsViewController: MFMailComposeViewControllerDelegate {
//    override func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//        
//        switch result {
//        case .sent:
//            let alert = UIAlertController(title: "发送成功", message: "感谢您的反馈！", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "好的", style: .default))
//            present(alert, animated: true)
//        default:
//            break
//        }
//    }
//}

// MARK: - 自定义单元格
class SettingCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.cellBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20 // 更大的圆角
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppColor.accent
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textColor = AppColor.primaryText
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.textColor = AppColor.secondaryText
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let accessoryIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        iv.tintColor = AppColor.accent.withAlphaComponent(0.5)
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(6)
        }
        
        containerView.addSubview(iconContainer)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        containerView.addSubview(accessoryIcon)
        iconContainer.addSubview(iconView)
        
        iconContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconContainer.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualTo(accessoryIcon.snp.leading).offset(-12)
        }
        
        detailLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.lessThanOrEqualTo(accessoryIcon.snp.leading).offset(-12)
        }
        
        accessoryIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 确保阴影正确绘制
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: containerView.layer.cornerRadius).cgPath
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateScale(0.95)
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
            self.containerView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func configure(with item: SettingItem) {
        titleLabel.text = item.title
        detailLabel.text = item.detail
        detailLabel.isHidden = item.detail == nil
        
        if let icon = item.icon {
            iconView.image = UIImage(systemName: icon)
            iconContainer.isHidden = false
            
            titleLabel.snp.remakeConstraints {
                $0.leading.equalTo(iconContainer.snp.trailing).offset(12)
                $0.top.equalToSuperview().offset(detailLabel.isHidden ? 5 : 5)
                $0.trailing.lessThanOrEqualTo(accessoryIcon.snp.leading).offset(-12)
            }
        } else {
            iconContainer.isHidden = true
            
            titleLabel.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
                $0.trailing.lessThanOrEqualTo(accessoryIcon.snp.leading).offset(-12)
            }
        }
        
        if detailLabel.isHidden {
            detailLabel.snp.remakeConstraints {
                $0.height.equalTo(0)
            }
        } else {
            detailLabel.snp.remakeConstraints {
                $0.leading.equalTo(titleLabel)
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
                $0.trailing.lessThanOrEqualTo(accessoryIcon.snp.leading).offset(-12)
            }
        }
        
        switch item.type {
        case .premium:
            titleLabel.textColor = AppColor.accent
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 17)?.withTraits(.traitBold) ?? UIFont.boldSystemFont(ofSize: 17)
            iconContainer.backgroundColor = AppColor.accent.withAlphaComponent(0.15)
            accessoryIcon.isHidden = true
        case .legal:
            iconContainer.backgroundColor = AppColor.accent.withAlphaComponent(0.1)
            accessoryIcon.isHidden = false
            accessoryIcon.image = UIImage(systemName: "arrow.up.forward.app.fill")
        case .contact:
            iconContainer.backgroundColor = AppColor.accent.withAlphaComponent(0.1)
            accessoryIcon.isHidden = false
            accessoryIcon.image = UIImage(systemName: "doc.on.doc.fill")
            accessoryIcon.tintColor = AppColor.accent.withAlphaComponent(0.7)
        default:
            iconContainer.backgroundColor = AppColor.accent.withAlphaComponent(0.1)
            accessoryIcon.isHidden = false
            accessoryIcon.image = UIImage(systemName: "chevron.right.circle.fill")
            accessoryIcon.tintColor = AppColor.accent.withAlphaComponent(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 扩展UIFont以添加粗体特性
extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
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
