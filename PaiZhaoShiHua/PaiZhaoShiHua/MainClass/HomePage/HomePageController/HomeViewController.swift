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

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置基础视图
        configureBaseView()
        // 创建标题
        setupTitle()
        // 创建搜索栏
        setupModernSearch()
        // 创建卡片网格
        setupCardGrid()
    }
    
    private func configureBaseView() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setupTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "FloraVision"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupModernSearch() {
        let searchContainer = UISearchBar()
        searchContainer.searchBarStyle = .minimal
        searchContainer.placeholder = "Search flower species"
        searchContainer.searchTextField.font = .preferredFont(forTextStyle: .body)
        searchContainer.searchTextField.backgroundColor = .quaternarySystemFill
        searchContainer.searchTextField.layer.cornerRadius = 14
        searchContainer.searchTextField.layer.cornerCurve = .continuous
        searchContainer.searchTextField.tintColor = .systemTeal
        
        view.addSubview(searchContainer)
        searchContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(72)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupCardGrid() {
        let items = [
            ("camera.aperture", "拍照识花", "AI智能识别植物种类", UIColor.systemTeal),
            ("books.vertical", "植物百科", "十万种植物资料库", UIColor.systemIndigo),
            ("doc.text.image", "识别记录", "您的植物发现历程", UIColor.systemOrange),
            ("gearshape", "偏好设置", "个性化您的体验", UIColor.systemGray)
        ]
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionLayout()
        )
        
        collectionView.backgroundColor = .clear
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    func shibiehua(imageUrl:String){
        // MARK: - 使用示例
        let userMessage = ChatRequest.Message(
            role: "user",
            content: [
                .init(text: "这是什么花，并详细介绍？给出明确种类"),
                .init(imageUrl:imageUrl)
            ]
        )
        
        Task {
            do {
                let responseData = try await sendChatRequest(
                    apiKey: "",
                    model: "qwen-vl-plus",
                    messages: [userMessage]
                )
                
                // 打印原始响应（实际使用时需要解码）
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    print("API Response: \(jsonString)")
                
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                    // 主线程执行UI操作
                        DispatchQueue.main.async  {
                            let displayVC = DisplayViewController()
                            displayVC.responseText  = jsonString
                            
                            // 通过导航控制器跳转（需确保当前控制器已嵌入导航栈）
//                            self.navigationController?.pushViewController(displayVC,  animated: true)
                            
                            // 如果无导航控制器，改用模态呈现（需手动添加返回按钮）
                             let nav = UINavigationController(rootViewController: displayVC)
                             self.present(nav,  animated: true)
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
                self.shibiehua(imageUrl: obj)
            }
        }
        
    }
    
}

    // MARK: - CollectionView DataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        let items = [
            ("camera.aperture", "拍照识花", "AI智能识别植物种类", UIColor.systemTeal),
            ("books.vertical", "植物百科", "十万种植物资料库", UIColor.systemIndigo),
            ("doc.text.image", "识别记录", "您的植物发现历程", UIColor.systemOrange),
            ("gearshape", "偏好设置", "个性化您的体验", UIColor.systemGray)
        ]
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    // 在 collectionView 的代理方法中补充：
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // 触觉反馈增强用户体验
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        
        switch indexPath.row {
        case 0:
            let cameraVC = VisionCameraVC()
//                cameraVC.delegate = self
            cameraVC.onImageCaptured = { image in
                self.uplodaImage(uiImage: image)
            }
                present(cameraVC, animated: true)
            print("拍照识别")
//            let cameraVC = CameraViewController()
//            cameraVC.modalPresentationStyle = .fullScreen
//            present(cameraVC, animated: true)
        case 1:
            print("1")
//            let encyclopediaVC = EncyclopediaViewController()
//            navigationController?.pushViewController(encyclopediaVC, animated: true)
        case 2:
            print("1")
//            let historyVC = HistoryViewController()
//            showDetailViewController(historyVC, sender: self)
        case 3:
            print("1")
//            let settingsVC = SettingsViewController()
//            settingsVC.modalPresentationStyle = .formSheet
//            present(settingsVC, animated: true)
        default:
            break
        }
        
        // 添加优雅的过渡动画
        UIView.animate(withDuration: 0.3) {
            collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                collectionView.cellForItem(at: indexPath)?.transform = .identity
            }
        }
    }
    
    
}

//extension HomeViewController: ImageProcessor {
//    nonisolated func processImage(_ image: UIImage) {
//        // 在这里实现您的图像识别逻辑
//        // 识别成功后会自动触发交互动画
////        Task { @MainActor in
//            uplodaImage(uiImage: image)
////        }
//    }
//}

    // MARK: - Custom Card Cell
class CardCell: UICollectionViewCell {
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 24
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.preferredSymbolConfiguration = .init(pointSize: 32, weight: .medium)
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
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
        cardView.addSubview(iconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func setupInteractions() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        longPress.minimumPressDuration = 0.1  // 关键修改：增加最小按压时间
        longPress.cancelsTouchesInView = false  // 允许事件继续传递[1](@ref)
        addGestureRecognizer(longPress)
    }
    
    @objc private func handlePress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            animateScale(0.96)
        case .ended, .cancelled:
            animateScale(1.0)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        default: break
        }
    }
    
    private func animateScale(_ scale: CGFloat) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction, .curveEaseInOut],
                       animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.cardView.layer.shadowOpacity = scale < 1 ? 0.1 : 0.05
        })
    }
    
    func configure(with data: (icon: String, title: String, subtitle: String, color: UIColor)) {
        if #available(iOS 15.0, *) {
            iconView.image = UIImage(systemName: data.icon)?
                .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [data.color]))
        } else {
            // Fallback on earlier versions
        }
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
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

