//
//  PZShiBieManager.swift
//  PaiZhaoShiHua
//
//  Created by NorthCityDevMac on 2025/2/25.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
import AVFoundation
 
class VisionCameraVC: UIViewController, @preconcurrency AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 拍照按钮
    private let captureButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white.withAlphaComponent(0.9)
        btn.layer.cornerRadius = 40
        btn.layer.borderWidth = 6
        btn.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 8
        btn.layer.shadowOpacity = 0.2
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 内部圆形指示器
    private let innerCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0)
        view.layer.cornerRadius = 28
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 相册按钮
    private let galleryButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        btn.layer.cornerRadius = 24
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 4
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "photo.stack", withConfiguration: config)
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 闪光灯按钮
    private let flashButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        btn.layer.cornerRadius = 24
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 4
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "bolt.slash.fill", withConfiguration: config)
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.orange
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 对焦指示器
    private let focusIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 40
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 植物引导覆盖层
    private let plantGuideOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 相机反馈视图（拍照闪光效果）
    private let captureFeedbackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 相机预览层
    private var previewLayer: AVCaptureVideoPreviewLayer!
    // 相机会话
    private let session = AVCaptureSession()
    // 照片输出
    private let photoOutput = AVCapturePhotoOutput()
    
    // 图片捕获回调
    var onImageCaptured: ((UIImage) -> Void)?
    
    private let sessionQueue = DispatchQueue(label: "com.zl.camera.sessionQueue")

    // 闪光灯状态
    private var isFlashOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermissions()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateInterfaceElements()
        
//        self.session.startRunning()
    }
       
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           previewLayer?.frame = cameraView.bounds
       }

       // MARK: - 权限检查
       private func checkCameraPermissions() {
           switch AVCaptureDevice.authorizationStatus(for: .video) {
           case .authorized:
               setupCamera()
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                   guard let self = self else { return }
                   if granted {
                       self.setupCamera()
                   } else {
                       self.showPermissionAlert()
                   }
               }
           default:
               showPermissionAlert()
           }
       }


    private func setupPreviewLayer() {
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = cameraView.bounds
            previewLayer.cornerRadius = 24
            cameraView.layer.insertSublayer(previewLayer, at: 0)
        }
    
    // 设置手势
    private func setupGestures() {
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        
        // 添加点击对焦手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFocus(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // 添加按压交互到拍摄按钮
        addPressInteraction(to: captureButton)
        addPressInteraction(to: galleryButton)
        addPressInteraction(to: flashButton)
    }
    
    private func addPressInteraction(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        AnimationUtility.triggerHaptic(style: .light)
        UIView.animate(withDuration: 0.15) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
            sender.transform = .identity
        })
    }
    
    // 拍照方法
    @objc private func captureImage() {
        // 触发拍照触觉反馈
        AnimationUtility.triggerHaptic(style: .medium)
        
        // 闪光效果
        UIView.animate(withDuration: 0.1, animations: {
            self.captureFeedbackView.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.captureFeedbackView.alpha = 0
            }
        }
        
        let settings = AVCapturePhotoSettings()
        
        // 设置闪光灯
        if let device = AVCaptureDevice.default(for: .video), 
           device.hasTorch && device.isTorchAvailable {
            settings.flashMode = isFlashOn ? .on : .off
        }
        
        if let firstPixelFormat = photoOutput.availablePhotoPixelFormatTypes.first {
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstPixelFormat]
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // 切换闪光灯
    @objc private func toggleFlash() {
        isFlashOn = !isFlashOn
        
        // 更新UI
        let imageName = isFlashOn ? "bolt.fill" : "bolt.slash.fill"
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        flashButton.setImage(UIImage(systemName: imageName, withConfiguration: configuration), for: .normal)
        
        // 触觉反馈
        AnimationUtility.triggerSelectionHaptic()
        
        // 尝试设置设备闪光灯状态
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch && device.isTorchAvailable else { return }
        
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: isFlashOn ? 1.0 : 0.0)
            device.unlockForConfiguration()
        } catch {
            print("无法设置闪光灯: \(error)")
        }
    }
    
    // 对焦处理
    @objc private func handleFocus(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        
        // 防止点击UI控件区域
        if location.y > view.bounds.height - 140 {
            return
        }
        
        // 转换坐标到预览层
        guard let previewLayer = self.previewLayer else { return }
        let devicePoint = previewLayer.captureDevicePointConverted(fromLayerPoint: location)
        
        // 设置对焦动画位置
        focusIndicator.center = location
        
        // 执行对焦动画
        focusIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        focusIndicator.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.focusIndicator.transform = CGAffineTransform.identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
                self.focusIndicator.alpha = 0
            })
        }
        
        // 配置相机对焦
        do {
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            
            try device.lockForConfiguration()
            
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
                device.focusPointOfInterest = devicePoint
                device.focusMode = .autoFocus
            }
            
            if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.autoExpose) {
                device.exposurePointOfInterest = devicePoint
                device.exposureMode = .autoExpose
            }
            
            device.unlockForConfiguration()
            
            // 触觉反馈
            AnimationUtility.triggerSelectionHaptic()
        } catch {
            print("无法设置对焦: \(error)")
        }
    }
    
    // 打开相册方法
    @objc private func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    let cameraView = UIView()

    
    // 设置界面布局
    private func setupUI() {
        view.backgroundColor = .black
        
        // 创建相机视图容器
        cameraView.backgroundColor = .black
        cameraView.layer.cornerRadius = 24
        cameraView.layer.masksToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加UI元素
        view.addSubview(cameraView)
        cameraView.addSubview(captureFeedbackView)
        view.addSubview(captureButton)
        captureButton.addSubview(innerCircle)
        view.addSubview(galleryButton)
        view.addSubview(flashButton)
        view.addSubview(focusIndicator)
        view.addSubview(plantGuideOverlay)
        
        // 设置约束
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            
            captureFeedbackView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            captureFeedbackView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            captureFeedbackView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            captureFeedbackView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
            
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant: 80),
            captureButton.heightAnchor.constraint(equalToConstant: 80),
            
            innerCircle.centerXAnchor.constraint(equalTo: captureButton.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 56),
            innerCircle.heightAnchor.constraint(equalToConstant: 56),
            
            galleryButton.trailingAnchor.constraint(equalTo: captureButton.leadingAnchor, constant: -40),
            galleryButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            galleryButton.widthAnchor.constraint(equalToConstant: 48),
            galleryButton.heightAnchor.constraint(equalToConstant: 48),
            
            flashButton.leadingAnchor.constraint(equalTo: captureButton.trailingAnchor, constant: 40),
            flashButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            flashButton.widthAnchor.constraint(equalToConstant: 48),
            flashButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        // 设置植物引导图标
        let plantOutline = UIImageView(image: UIImage(systemName: "leaf.fill"))
        plantOutline.tintColor = UIColor.white.withAlphaComponent(0.3)
        plantOutline.contentMode = .scaleAspectFit
        plantOutline.translatesAutoresizingMaskIntoConstraints = false
        
        plantGuideOverlay.addSubview(plantOutline)
        
        NSLayoutConstraint.activate([
            plantGuideOverlay.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            plantGuideOverlay.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            plantGuideOverlay.widthAnchor.constraint(equalTo: cameraView.widthAnchor),
            plantGuideOverlay.heightAnchor.constraint(equalTo: cameraView.heightAnchor),
            
            plantOutline.centerXAnchor.constraint(equalTo: plantGuideOverlay.centerXAnchor),
            plantOutline.centerYAnchor.constraint(equalTo: plantGuideOverlay.centerYAnchor),
            plantOutline.widthAnchor.constraint(equalToConstant: 120),
            plantOutline.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // 动画入场效果
    private func animateInterfaceElements() {
        // 初始状态
        [captureButton, galleryButton, flashButton].forEach { button in
            button.alpha = 0
            button.transform = CGAffineTransform(translationX: 0, y: 20)
        }
        
        // 序列动画
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.1,
            options: [],
            animations: {
                self.captureButton.alpha = 1
                self.captureButton.transform = .identity
            }
        )
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.2,
            options: [],
            animations: {
                self.galleryButton.alpha = 1
                self.galleryButton.transform = .identity
            }
        )
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0.3,
            options: [],
            animations: {
                self.flashButton.alpha = 1
                self.flashButton.transform = .identity
            }
        )
        
        // 添加呼吸动画到拍照按钮
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.innerCircle.isUserInteractionEnabled = false
            assert(Thread.isMainThread, "必须在主线程执行")
            print("开始添加动画")
            AnimationUtility.addBreathingAnimation(to: self.innerCircle, duration: 2.5)
            
            // 检查动画是否成功添加
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let hasAnimation = self.innerCircle.layer.animation(forKey: "breathing") != nil
                print("动画存在性: \(hasAnimation ? "存在" : "缺失")")
            }
        }
    }
    
    // 设置相机
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("无法获取摄像头设备")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
                
                // 设置高质量照片捕获
                session.sessionPreset = .photo
            }
            
            
            // 启动会话
//            sessionQueue.async {
                if !self.session.isRunning {
                    self.session.startRunning()
                }
//            }

            // 配置相机预览
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            
            // 找到相机视图容器
            if let cameraView = view.subviews.first(where: { $0.backgroundColor == .black && $0.layer.cornerRadius == 24 }) {
                previewLayer.frame = cameraView.bounds
                cameraView.layer.insertSublayer(previewLayer, at: 0)
                
                // 设置预览层边界
                previewLayer.cornerRadius = 24
                previewLayer.masksToBounds = true
            }
        } catch {
            print("相机设置错误: \(error)")
        }
    }
    
    var hasPermission = false
    
    // 显示权限提示框
    private func showPermissionAlert() {
        let alert = UIAlertController(title: "需要相机权限", message: "请在设置中开启相机权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    // 实现 AVCapturePhotoCaptureDelegate 协议方法
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("拍照失败: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("无法获取图片数据")
            return
        }
        
        // 拍照成功触觉反馈
        AnimationUtility.triggerHaptic(style: .heavy)
        
        // 使用转场动画
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.8
            self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            DispatchQueue.main.async {
                self.onImageCaptured?(image)
                self.dismiss(animated: false)
            }
        }
    }
    
    // 实现 UIImagePickerControllerDelegate 协议方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // 触觉反馈
        AnimationUtility.triggerHaptic(style: .medium)
        
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.onImageCaptured?(image)
                self.dismiss(animated: true)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
 
 
