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
import StoreKit

var isPushed = false

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
    
    let searchField = UITextField()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseView()
        setupTitle()
        setupModernSearch()
        setupCardGrid()
        setupBottomDecoration()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // 监听首次数据到达，跳转到新页面
        NotificationCenter.default.addObserver(self, selector: #selector(handleFirstData(_:)), name: NSNotification.Name("StreamingUpdate"), object: nil)
    }
    
    
    func checkAndRequestReview() {
          // 获取当前日期
          let currentDate = Date()
          
          // 从 UserDefaults 中获取上次弹出评论弹窗的日期
          let lastReviewRequestDate = UserDefaults.standard.object(forKey: "LastReviewRequestDate") as? Date
          
          // 如果没有记录上次日期，或者距离上次日期已经超过两天
          if lastReviewRequestDate == nil || daysBetween(lastReviewRequestDate!, and: currentDate) >= 2 {
              // 调用系统的评论弹窗
              requestReview()
              
              // 更新 UserDefaults 中存储的日期为当前日期
              UserDefaults.standard.set(currentDate, forKey: "LastReviewRequestDate")
          }
      }

      func requestReview() {
          // 检查系统版本，确保支持 SKStoreReviewController
          if #available(iOS 10.3, *) {
              // 调用系统的评论弹窗
              SKStoreReviewController.requestReview()
          } else {
              // 对于不支持的系统版本，可以提供一个替代方案，比如跳转到 App Store
              let alert = UIAlertController(title: "Rate Us", message: "Please rate us on the App Store.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      }

      func daysBetween(_ startDate: Date, and endDate: Date) -> Int {
          let calendar = Calendar.current
          let components = calendar.dateComponents([.day], from: startDate, to: endDate)
          return components.day ?? 0
      }
    
    @objc private func handleFirstData(_ notification: Notification) {
       
        if isPushed {
            return
        }
       
        isPushed = true

        self.checkAndRequestReview()
        SVProgressHUD.show(withStatus: "识别成功")
        guard let content = notification.object as? String else { return }
        
        guard let image = self.imageData else { return }
//        self.saveRecord(content: content, image: image)
        
        self.saveRecord(content: content, image: image) { [weak self] record in
            guard let self = self, let record = record else {
                SVProgressHUD.showError(withStatus: "保存失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "识别成功")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                SVProgressHUD.dismiss()
                print("收到首条数据，跳转界面")
                DispatchQueue.main.async {
                    let displayVC = DisplayViewController()
                    displayVC.markdownContent = content
                    displayVC.record = record
                    displayVC.imageData = self.imageData
                    self.present(displayVC, animated: true)
                }
            }
        }
        
        
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
    
    
   
    @objc func dismissKeyboard() {
        searchField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let encyclopediaVC = ZhiWuBaiKeViewController()
        encyclopediaVC.urlstring = textField.text
        present(encyclopediaVC, animated: true)
        return true
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
    
    var imageData:UIImage?
    
    func shibiehua(imageUrl:String,imageData:UIImage){
        
        DashScopeAPI.shared.sendMessage(withText: "识别图中的植物，并详细专业介绍所有信息？字数不少于1000字", imageURL: imageUrl, isStreaming: true)
        self.imageData = imageData
 
        
        return
        
        
        // MARK: - 使用示例
        let userMessage = ChatRequest.Message(
            role: "user",
            content: [
                .init(text: "识别途中的植物，并详细专业介绍所有信息？"),
                .init(imageUrl:imageUrl)
            ]
        )
        
        print("=========请求开始时间戳\(Date().timeIntervalSince1970)")

        Task {
            do {
                let responseData = try await sendChatRequest(
                    apiKey: "",
                    model: "qwen-vl-max",
                    messages: [userMessage]
                )
                
                print("=========请求成功时间戳\(Date().timeIntervalSince1970)")
                
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    // 解析 JSON 获取 content
                    if let jsonData = jsonString.data(using: .utf8),
                       let result = try? JSONDecoder().decode(ResponseModel.self, from: jsonData),
                       let content = result.choices.first?.message.content {
                        
                        let image = imageData
                        let content = content
//                        saveRecord(content: content, image: image)

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

        // 压缩图片到 500KB 以内
        // 先调整图片尺寸，再压缩 JPEG 质量
           guard let resizedImage = resizeImageIfNeeded(uiImage, maxFileSizeKB: 500),
                 let compressedImageData = compressImage(resizedImage, toMaxSizeKB: 500),
                 let compressedImage = UIImage(data: compressedImageData) else {
               SVProgressHUD.showError(withStatus: "图片处理失败")
               return
           }
        
        print("最终压缩后图片大小: \(compressedImageData.count / 1024) KB") // 打印最终图片大小
        
        
        AliyunOSSUpload.aliyunInit().upLoad(compressedImage) {(obj: String?) in
            if let obj = obj {
                SVProgressHUD.show(withStatus: "AI识别中...")
                self.shibiehua(imageUrl: obj, imageData: uiImage)
            }
        }
        
    }
    
    // **步骤 1：调整图片尺寸**
    func resizeImageIfNeeded(_ image: UIImage, maxFileSizeKB: Int) -> UIImage? {
        var newSize = image.size
        var scale: CGFloat = 1.0
        let maxSizeBytes = maxFileSizeKB * 1024

        // 计算初始 JPEG 质量为 0.8 时的大小
        if let data = image.jpegData(compressionQuality: 0.8), data.count > maxSizeBytes {
            scale = sqrt(CGFloat(maxSizeBytes) / CGFloat(data.count)) // 计算缩放比例
            newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        }

        // 开始缩小图片
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0) // 保持屏幕缩放比例
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        print("调整后图片尺寸: \(newSize.width) x \(newSize.height)")
        return resizedImage
    }

    // **步骤 2：JPEG 质量压缩**
    func compressImage(_ image: UIImage, toMaxSizeKB maxSizeKB: Int) -> Data? {
        let maxSize = maxSizeKB * 1024
        var compression: CGFloat = 1.0
        var min: CGFloat = 0.0
        var max: CGFloat = 1.0
        var bestData: Data?

        for _ in 0..<6 { // 进行 6 次二分搜索以找到最合适的压缩比例
            if let data = image.jpegData(compressionQuality: compression) {
                print("当前压缩比: \(compression), 图片大小: \(data.count / 1024) KB")
                if data.count < maxSize {
                    bestData = data
                    min = compression // 增加压缩质量
                } else {
                    max = compression // 降低压缩质量
                }
            }
            compression = (min + max) / 2
        }

        return bestData
    }

    
//    // 压缩图片到目标大小（单位 KB）
//    // **步骤 2：JPEG 质量压缩**
//    func compressImage(_ image: UIImage, toMaxSizeKB maxSizeKB: Int) -> Data? {
//        let maxSize = maxSizeKB * 1024
//        var compression: CGFloat = 1.0
//        var min: CGFloat = 0.0
//        var max: CGFloat = 1.0
//        var bestData: Data?
//
//        for _ in 0..<6 { // 进行 6 次二分搜索以找到最合适的压缩比例
//            if let data = image.jpegData(compressionQuality: compression) {
//                print("当前压缩比: \(compression), 图片大小: \(data.count / 1024) KB")
//                if data.count < maxSize {
//                    bestData = data
//                    min = compression // 增加压缩质量
//                } else {
//                    max = compression // 降低压缩质量
//                }
//            }
//            compression = (min + max) / 2
//        }
//
//        return bestData
//    }
    
//    func uplodaImage(uiImage: UIImage) {
//        SVProgressHUD.show(withStatus: "分析中...")
//
//        // 使用压缩方法（参数可配置）
//        guard let compressedImage = compressImageToMaxSize(uiImage,
//                                                         maxSizeKB: 512,
//                                                         maxWidth: 1024,
//                                                         maxHeight: 1024) else {
//            SVProgressHUD.showError(withStatus: "图片压缩失败")
//            return
//        }
//
//        AliyunOSSUpload.aliyunInit().upLoad(compressedImage) { (obj: String?) in
//            print("======上传成功============= \(obj ?? "")")
//            
//            if let obj = obj {
//                SVProgressHUD.show(withStatus: "识别中...")
//                self.shibiehua(imageUrl: obj, imageData: compressedImage)
//            }
//        }
//    }

    // 核心压缩方法（参数化配置）
    func compressImageToMaxSize(_ image: UIImage,
                               maxSizeKB: Int,
                               maxWidth: CGFloat,
                               maxHeight: CGFloat) -> UIImage? {
        let maxBytes = maxSizeKB * 1024
        var currentImage = image
        var currentData: Data?
        
        // 阶段1：尺寸压缩
        let originalSize = image.size
        let widthRatio = maxWidth / originalSize.width
        let heightRatio = maxHeight / originalSize.height
        let targetRatio = min(min(widthRatio, heightRatio), 1.0)
        
        if targetRatio < 1.0 {
            let newSize = CGSize(width: originalSize.width * targetRatio,
                               height: originalSize.height * targetRatio)
            UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            currentImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        // 阶段2：质量压缩
        var quality: CGFloat = 0.8
        repeat {
            currentData = currentImage.jpegData(compressionQuality: quality)
            quality -= 0.05
        } while (currentData?.count ?? Int.max) > maxBytes && quality > 0.1
        
        // 最终验证
        guard let validData = currentData, validData.count <= maxBytes else {
            return nil
        }
      
        let compressedSizeKB = Double(validData.count) / 1024.0

        
        print("压缩后图片大小：\(String(format: "%.2f", compressedSizeKB)) KB")

        
        return UIImage(data: validData)
    }
    
    
//    func saveRecord(content: String, image: UIImage) {
//        // 创建新记录
//        let newRecord = HistoryRecord(context: CoreDataManager.shared.context)
//        newRecord.id = UUID()
//        newRecord.content = content
//        newRecord.createDate = Date()
//        
//        // 保存图片到文件系统
//        let imagePath = saveImageToDisk(image: image)
////        newRecord.imagePath = imagePath
//        
//        // 在需要保存的地方调用
//        DispatchQueue.global(qos: .background).async {
//            // 通过主线程执行保存
//            DispatchQueue.main.async {
//                CoreDataManager.shared.saveContext()
//            }
//        }
//    }
    
    func saveRecord(content: String, image: UIImage, completion: @escaping (HistoryRecord?) -> Void) {
        // 确保在主线程执行 CoreData 操作
        DispatchQueue.main.async {
            // 创建记录对象
            let context = CoreDataManager.shared.context
            let newRecord = HistoryRecord(context: context)
            newRecord.id = UUID()
            newRecord.content = content
            newRecord.createDate = Date()
            
            // 保存图片（包含错误处理）
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                context.delete(newRecord)
                completion(nil)
                return
            }
            
            // 异步保存图片防止阻塞主线程
            DispatchQueue.global(qos: .utility).async {
                let imagePath: String?
                do {
                    imagePath = try self.saveImageToDisk(data: imageData)
                } catch {
                    print("图片保存失败: \(error)")
                    imagePath = nil
                }
                
                // 回到主线程处理结果
                DispatchQueue.main.async {
                    guard let validPath = imagePath else {
                        context.delete(newRecord)
                        completion(nil)
                        return
                    }
                    
                    newRecord.imagePath = validPath
                    
                    // 最终保存上下文
                    do {
                        try context.save()
                        completion(newRecord)
                    } catch {
                        print("CoreData 保存失败: \(error)")
                        context.delete(newRecord)
                        completion(nil)
                    }
                }
            }
        }
    }

    private func saveImageToDisk(data: Data) throws -> String {
        let fileName = "\(UUID().uuidString).jpg"
        guard let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "FileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "文档目录未找到"])
        }
        
        let fileURL = documentsDir.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        return fileName  // 只返回相对路径
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
        
//        AnimationUtility.triggerHaptic(style: .light)
        
//        AnimationUtility.pressAnimation(for: cell) { _ in
//            AnimationUtility.releaseAnimation(for: cell) { _ in
//                AnimationUtility.triggerHaptic(style: .rigid)
                
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
//            }
//        }
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


