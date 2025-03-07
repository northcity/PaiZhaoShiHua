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
import SVProgressHUD
import AliyunOSSiOS

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Collection View Data Source & Delegate
    private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let items = [
        ("leaf.fill", "拍照识花", "AI智能识别植物种类", UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0)),
        ("book.closed.fill", "植物百科", "十万种植物资料库", UIColor(red: 0.5, green: 0.3, blue: 0.9, alpha: 1.0)),
        ("photo.on.rectangle.fill", "识别记录", "您的植物发现历程", UIColor(red: 1.0, green: 0.6, blue: 0.3, alpha: 1.0)),
        ("gearshape.fill", "偏好设置", "个性化您的体验", UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
    ]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseView()
        setupTitle()
        setupModernSearch()
        setupCardGrid()
        setupBottomDecoration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateInterfaceElements()
    }
    
    // MARK: - Setup Methods
    private func configureBaseView() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.0, alpha: 1.0)
        
        let topDecoration = UIView()
        topDecoration.backgroundColor = UIColor(red: 0.95, green: 0.85, blue: 1.0, alpha: 1.0)
        topDecoration.layer.cornerRadius = 30
        topDecoration.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        view.addSubview(topDecoration)
        topDecoration.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 0.15)
        }
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setupTitle() {
        let titleContainer = UIView()
        view.addSubview(titleContainer)
        titleContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(24)
        }
        
        // 主标题
        let titleLabel = UILabel()
        titleLabel.text = "拍照识花"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0) // 深紫色
        
        // 可爱图标
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "leaf.fill")
        iconImageView.tintColor = UIColor(red: 0.5, green: 0.8, blue: 0.3, alpha: 1.0) // 绿色
        iconImageView.contentMode = .scaleAspectFit
        
        // 添加到容器
        titleContainer.addSubview(iconImageView)
        titleContainer.addSubview(titleLabel)
        
        // 设置约束
        iconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupModernSearch() {
        let searchContainer = UIView()
        searchContainer.backgroundColor = UIColor.white
        searchContainer.layer.cornerRadius = 20
        searchContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        searchContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        searchContainer.layer.shadowRadius = 8
        searchContainer.layer.shadowOpacity = 1
        
        view.addSubview(searchContainer)
        searchContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(72)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        
        // 搜索图标
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = UIColor(red: 0.7, green: 0.3, blue: 0.9, alpha: 1.0) // 紫色
        searchIcon.contentMode = .scaleAspectFit
        
        searchContainer.addSubview(searchIcon)
        searchIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        // 输入框
        let searchField = UITextField()
        searchField.placeholder = "搜索花朵信息"
        searchField.borderStyle = .none
        searchField.returnKeyType = .search
        searchField.font = UIFont.systemFont(ofSize: 16)
        searchField.textColor = UIColor.darkGray
        searchField.delegate = self
        searchField.clearButtonMode = .whileEditing
        
        searchContainer.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.leading.equalTo(searchIcon.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    private func setupCardGrid() {
        let layout = createCollectionLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(140)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func createCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.6)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func shibiehua(imageUrl:String,imageData:UIImage){
        // MARK: - 使用示例
        let userMessage = ChatRequest.Message(
            role: "user",
            content: [
                .init(text: "这是什么植物，详细介绍？"),
                .init(imageUrl:imageUrl)
            ]
        )
        
        Task {
            do {
                let responseData = try await sendChatRequest(
                    apiKey: "",
                    model: "qwen-vl-max",
                    messages: [userMessage]
                )
                
                // 打印原始响应（实际使用时需要解码）
//                if let jsonString = String(data: responseData, encoding: .utf8) {
//                    print("API Response: \(jsonString)")
//                
//                    
//                    DispatchQueue.main.async {
//                        SVProgressHUD.dismiss()
//                    }
//                    // 主线程执行UI操作
//                        DispatchQueue.main.async  {
//                            let displayVC = DisplayViewController()
//                            displayVC.responseText  = jsonString
//                            
//                            // 通过导航控制器跳转（需确保当前控制器已嵌入导航栈）
////                            self.navigationController?.pushViewController(displayVC,  animated: true)
//                            
//                            // 如果无导航控制器，改用模态呈现（需手动添加返回按钮）
//                             let nav = UINavigationController(rootViewController: displayVC)
//                             self.present(nav,  animated: true)
//                        }
//                    
//                }
                
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    // 解析 JSON 获取 content
                    if let jsonData = jsonString.data(using: .utf8),
                       let result = try? JSONDecoder().decode(ResponseModel.self, from: jsonData),
                       let content = result.choices.first?.message.content {
                        
                        let image = imageData
                        let content = content
                        saveRecord(content: content, image: image)

                        SVProgressHUD.show(withStatus: "识别成功")

                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                           
                            DispatchQueue.main.async  {
                               
                                SVProgressHUD.dismiss()
                                
                                let displayVC = DisplayViewController()
                                displayVC.markdownContent  = content
                                displayVC.imageUrl = imageUrl
                                displayVC.imageData = image
                                // 通过导航控制器跳转（需确保当前控制器已嵌入导航栈）
                                // 如果无导航控制器，改用模态呈现（需手动添加返回按钮）
//                                 let nav = UINavigationController(rootViewController: displayVC)
                                 self.present(displayVC,  animated: true)
                            }
                        }
                        
                       
                        
                        
                    }
                }
            } catch {
                print("Request failed: \(error)")
            }
        }
    }
  
    func uplodaImage(uiImage:UIImage){
        SVProgressHUD.show(withStatus: "分析中...")

        AliyunOSSUpload.aliyunInit().upLoad(uiImage) {(obj: String?) in
            
            print("======上传成功=============" + (obj ?? "") ?? "")
            
            if let obj = obj {
                SVProgressHUD.show(withStatus: "识别中...")
                self.shibiehua(imageUrl: obj, imageData: uiImage)
            }
        }
        
    }
    
    func saveRecord(content: String, image: UIImage) {
        // 创建新记录
        let newRecord = HistoryRecord(context: CoreDataManager.shared.context)
        newRecord.id = UUID()
        newRecord.content = content
        newRecord.createDate = Date()
        
        // 保存图片到文件系统
        let imagePath = saveImageToDisk(image: image)
        newRecord.imagePath = imagePath
        
        // 在需要保存的地方调用
        DispatchQueue.global(qos: .background).async {
            // 通过主线程执行保存
            DispatchQueue.main.async {
                CoreDataManager.shared.saveContext()
            }
        }
    }

    private func saveImageToDisk(image: UIImage) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
        
        return fileName
    }
    
    private func setupBottomDecoration() {
        // 创建底部装饰花朵图案
        let flowerIcon1 = UIImageView(image: UIImage(systemName: "leaf.fill"))
        flowerIcon1.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.4, alpha: 0.2)
        flowerIcon1.contentMode = .scaleAspectFit
        
        let flowerIcon2 = UIImageView(image: UIImage(systemName: "flower"))
        flowerIcon2.tintColor = UIColor(red: 0.9, green: 0.4, blue: 0.4, alpha: 0.2)
        flowerIcon2.contentMode = .scaleAspectFit
        
        view.addSubview(flowerIcon1)
        view.addSubview(flowerIcon2)
        
        flowerIcon1.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(30)
            $0.width.height.equalTo(50)
        }
        
        flowerIcon2.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.trailing.equalToSuperview().offset(-40)
            $0.width.height.equalTo(40)
        }
    }
    
    // MARK: - Animation Methods
    private func animateInterfaceElements() {
        // 获取所有需要动画的视图元素
        guard let titleContainer = view.subviews.first(where: { $0.subviews.contains(where: { $0 is UILabel && ($0 as? UILabel)?.text == "拍照识花" }) }),
              let searchContainer = view.subviews.first(where: { $0.subviews.contains(where: { $0 is UITextField }) }) else {
            return
        }
        
        // 标题弹性出现
        AnimationUtility.springInAnimation(for: titleContainer)
        
        // 搜索栏延迟后弹性出现
        AnimationUtility.springInAnimation(for: searchContainer, delay: 0.1)
        
        // 卡片网格逐个出现
        let visibleCells = collectionView.visibleCells
        AnimationUtility.sequentialAnimation(for: visibleCells)
    }
    
    // 统一的关闭按钮样式
    private func addStyledCloseButton(to viewController: UIViewController) {
        // 在 viewDidLoad 之后应用，避免覆盖 viewController 自己的设置
        DispatchQueue.main.async {
            // 创建圆形关闭按钮
            let closeButton = UIButton(type: .custom)
            closeButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            closeButton.layer.cornerRadius = 22
            closeButton.layer.shadowColor = UIColor.black.cgColor
            closeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            closeButton.layer.shadowRadius = 4
            closeButton.layer.shadowOpacity = 0.2
            
            // 设置关闭图标
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            let closeImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)
            closeButton.setImage(closeImage, for: .normal)
            closeButton.tintColor = UIColor(red: 0.6, green: 0.3, blue: 0.7, alpha: 1.0) // 与主题色一致的紫色
            
            // 添加到视图
            viewController.view.addSubview(closeButton)
            
            // 设置约束
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                closeButton.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
                closeButton.widthAnchor.constraint(equalToConstant: 44),
                closeButton.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            // 添加点击动画和触觉反馈
//            closeButton.addTarget(viewController, action: #selector(UIViewController.dismissAnimated), for: .touchUpInside)
            
            // 添加按压反馈
//            let pressInteraction = UIButtonPressInteraction()
//            pressInteraction.onPress = { [weak closeButton, weak viewController] _ in
//                guard let button = closeButton else { return }
//                
//                // 触发触觉反馈
//                AnimationUtility.triggerHaptic(style: .light)
//                
//                // 按压动画
//                UIView.animate(withDuration: 0.15, animations: {
//                    button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                })
//            }
//            
//            pressInteraction.onRelease = { [weak closeButton, weak viewController] _ in
//                guard let button = closeButton, let vc = viewController else { return }
//                
//                // 释放动画
//                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
//                    button.transform = .identity
//                }, completion: { _ in
//                    vc.dismiss(animated: true)
//                })
//            }
            
//            closeButton.addInteraction(pressInteraction)
        }
    }
    
    // 按钮按压交互类
//    class UIButtonPressInteraction: UIInteraction {
//        var onPress: ((UIButton) -> Void)?
//        var onRelease: ((UIButton) -> Void)?
//        
//        override func willMove(to view: UIView?) {
//            super.willMove(to: view)
//            
//            guard let button = view as? UIButton else { return }
//            
//            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
//            button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
//            button.addTarget(self, action: #selector(buttonTouchUpOutside(_:)), for: [.touchUpOutside, .touchCancel])
//        }
//        
//        @objc private func buttonTouchDown(_ sender: UIButton) {
//            onPress?(sender)
//        }
//        
//        @objc private func buttonTouchUpInside(_ sender: UIButton) {
//            onRelease?(sender)
//        }
//        
//        @objc private func buttonTouchUpOutside(_ sender: UIButton) {
//            UIView.animate(withDuration: 0.2) {
//                sender.transform = .identity
//            }
//        }
//    }
    
    // 添加扩展以便所有 ViewController 可以使用
//    extension UIViewController {
//        @objc func dismissAnimated() {
//            AnimationUtility.triggerHaptic(style: .medium)
//            dismiss(animated: true)
//        }
//    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        AnimationUtility.triggerHaptic(style: .light)
        
        AnimationUtility.pressAnimation(for: cell) { _ in
            AnimationUtility.releaseAnimation(for: cell) { _ in
                AnimationUtility.triggerHaptic(style: .rigid)
                
                switch indexPath.row {
                case 0:
                    let cameraVC = VisionCameraVC()
                    cameraVC.modalPresentationStyle = .formSheet
                    cameraVC.onImageCaptured = { [weak self] image in
                        self?.handleCapturedImage(image)
                    }
                    self.present(cameraVC, animated: true)
                case 1:
                    let encyclopediaVC = ZhiWuBaiKeViewController()
                    self.present(encyclopediaVC, animated: true)
                case 2:
                    let historyVC = HistoryListViewController()
                    self.present(historyVC, animated: true)
                case 3:
                    let settingsVC = SettingsViewController()
                    self.present(settingsVC, animated: true)
                default:
                    break
                }
            }
        }
    }
    
    private func handleCapturedImage(_ image: UIImage) {
        // 处理拍摄的图片
        uplodaImage(uiImage: image)
    }
}

// MARK: - UITextFieldDelegate
//extension HomeViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        let encyclopediaVC = ZhiWuBaiKeViewController()
//        encyclopediaVC.urlstring = textField.text
//        present(encyclopediaVC, animated: true)
//        return true
//    }
//}

// MARK: - Custom Card Cell
class CardCell: UICollectionViewCell {
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.cornerCurve = .continuous
        
        // 添加边框
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 优化阴影
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 2, height: 6)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let iconBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.preferredSymbolConfiguration = .init(pointSize: 28, weight: .medium)
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupInteractions()
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconBackground)
        iconBackground.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        iconBackground.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconBackground.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with data: (icon: String, title: String, subtitle: String, color: UIColor)) {
        iconView.image = UIImage(systemName: data.icon)
        iconBackground.backgroundColor = data.color
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        
        // 设置卡片边框颜色
        cardView.layer.borderColor = data.color.withAlphaComponent(0.3).cgColor
    }
    
    // 增强按压效果
    private func setupInteractions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        longPress.minimumPressDuration = 0.05
        longPress.cancelsTouchesInView = false
        addGestureRecognizer(longPress)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        // 只需定义，实际由 collectionView delegate 处理
    }
    
    @objc private func handlePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            AnimationUtility.triggerHaptic(style: .light)
            animateScale(0.92)
        case .changed:
            // 保持当前状态
            break
        case .ended, .cancelled:
            AnimationUtility.triggerHaptic(style: .light)
            animateScale(1.0)
        default:
            break
        }
    }
    
    private func animateScale(_ scale: CGFloat) {
        // 使用 UIViewPropertyAnimator 代替 UIView.animate，性能更好
        let animator = UIViewPropertyAnimator(
            duration: 0.2,
            dampingRatio: scale < 1 ? 0.7 : 0.6) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                
                // 缩放时调整阴影效果，增强立体感
                if scale < 1 {
                    self.cardView.layer.shadowOffset = CGSize(width: 1, height: 3)
                    self.cardView.layer.shadowOpacity = 0.15
                } else {
                    self.cardView.layer.shadowOffset = CGSize(width: 2, height: 6)
                    self.cardView.layer.shadowOpacity = 0.1
                }
            }
        
        animator.startAnimation()
    }
    
    // 增加光泽高光效果，提升卡片质感
    func addGlossEffect() {
        // 创建渐变光泽层
        let glossLayer = CAGradientLayer()
        glossLayer.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        glossLayer.locations = [0.0, 0.5, 1.0]
        glossLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        glossLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        glossLayer.frame = bounds
        glossLayer.cornerRadius = 24
        glossLayer.masksToBounds = true
        
        // 添加到卡片视图
        cardView.layer.addSublayer(glossLayer)
    }
    
    // 增强配置方法
//    func configure(with data: (icon: String, title: String, subtitle: String, color: UIColor)) {
//        iconView.image = UIImage(systemName: data.icon)
//        iconBackground.backgroundColor = data.color
//        titleLabel.text = data.title
//        subtitleLabel.text = data.subtitle
//        
//        // 设置卡片边框和阴影颜色
//        cardView.layer.borderColor = data.color.withAlphaComponent(0.3).cgColor
//        cardView.layer.shadowColor = data.color.withAlphaComponent(0.4).cgColor
//        
//        // 添加微妙的光泽效果
//        addGlossEffect()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//    @objc func cardTapped(_ sender: UIButton) {
//        switch sender.tag {
//        case 0:
//            // Handle "拍照识花" action
//            print("拍照识花 tapped")
//            shibiehua()
//        case 1:
//            // Handle "百科全书" action
//            print("百科全书 tapped")
//        case 2:
//            // Handle "我的记录" action
//            print("我的记录 tapped")
//        case 3:
//            // Handle "系统设置" action
//            print("系统设置 tapped")
//        default:
//            break
//        }
//    }
//
//
//    
//    func shibiehua(){
//        // MARK: - 使用示例
//        let userMessage = ChatRequest.Message(
//            role: "user",
//            content: [
//                .init(text: "这是什么花，并详细介绍？"),
//                .init(imageUrl: "https://qcloud.dpfile.com/pc/9Ab0mXBSM_8Ufyil3pLAzIMUZsQkV_FJjDooG4YRFjajDUMl9-x-W3-mDHL5mMtD.jpg")
//            ]
//        )
//
//        Task {
//            do {
//                let responseData = try await sendChatRequest(
//                    apiKey: "",
//                    model: "qwen-vl-plus",
//                    messages: [userMessage]
//                )
//                
//                // 打印原始响应（实际使用时需要解码）
//                if let jsonString = String(data: responseData, encoding: .utf8) {
//                    print("API Response: \(jsonString)")
//                }
//            } catch {
//                print("Request failed: \(error)")
//            }
//        }
//    }


