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
        btn.backgroundColor  = .white.withAlphaComponent(0.9)
        btn.layer.cornerRadius  = 40
        btn.layer.shadowColor  = UIColor.black.cgColor
        btn.layer.shadowRadius  = 8
        btn.layer.shadowOpacity  = 0.2
        btn.translatesAutoresizingMaskIntoConstraints  = false
        return btn
    }()
    
    // 相册按钮
    private let galleryButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName:  "photo.stack"),  for:.normal)
        btn.tintColor  = .white
        btn.translatesAutoresizingMaskIntoConstraints  = false
        return btn
    }()
    
    // 相机预览层
    private var previewLayer: AVCaptureVideoPreviewLayer!
    // 相机会话
    private let session = AVCaptureSession()
    // 照片输出
    private let photoOutput = AVCapturePhotoOutput()
    
    // 图片捕获回调
    var onImageCaptured: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCameraPermissions()
    }
    
    // 设置手势
    private func setupGestures() {
        captureButton.addTarget(self,  action: #selector(captureImage), for:.touchUpInside)
        galleryButton.addTarget(self,  action: #selector(openGallery), for:.touchUpInside)
    }
    
    // 拍照方法
    @objc private func captureImage() {
        let settings = AVCapturePhotoSettings()
        if let firstPixelFormat = photoOutput.availablePhotoPixelFormatTypes.first  {
            settings.previewPhotoFormat  = [kCVPixelBufferPixelFormatTypeKey as String: firstPixelFormat]
        }
        photoOutput.capturePhoto(with:  settings, delegate: self)
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
        
        DispatchQueue.main.async  {
            self.onImageCaptured?(image)
            self.dismiss(animated: true)
        }
    }
    
    // 打开相册方法
    @objc private func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate  = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // 设置界面布局
    private func setupUI() {
        view.backgroundColor = .black
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style:.systemThinMaterial))
        blurView.frame  = view.bounds
//        view.insertSubview(blurView,  at: 0)
        
        view.addSubview(captureButton)
        view.addSubview(galleryButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo:  view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor,  constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant:  80),
            captureButton.heightAnchor.constraint(equalTo:  captureButton.widthAnchor),
            
            galleryButton.centerYAnchor.constraint(equalTo:  captureButton.centerYAnchor),
            galleryButton.trailingAnchor.constraint(equalTo:  view.trailingAnchor,  constant: -40),
            galleryButton.widthAnchor.constraint(equalToConstant:  44),
            galleryButton.heightAnchor.constraint(equalTo:  galleryButton.widthAnchor)
        ])
    }
    
    // 设置相机
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,  for:.video, position:.back) else {
            print("无法获取摄像头设备")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input)  {
                session.addInput(input)
            }
        } catch {
            print("无法创建摄像头输入: \(error.localizedDescription)")
            return
        }
        
        if session.canAddOutput(photoOutput)  {
            session.addOutput(photoOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame  = view.layer.bounds
        previewLayer.videoGravity  = .resizeAspectFill
        view.layer.insertSublayer(previewLayer,  at: 0)
        
        DispatchQueue.main.async  {
            self.session.startRunning()
        }
    }
    
    // 检查相机权限
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for:.video)  {
        case.authorized:
            DispatchQueue.main.async  {
                self.session.startRunning()
            }
        case.notDetermined:
            AVCaptureDevice.requestAccess(for:.video)  { granted in
                if granted {
                    DispatchQueue.main.async  {
                        self.session.startRunning()
                    }
                }
            }
        default:
            DispatchQueue.main.async  {
                self.showPermissionAlert()
            }
        }
    }
    
    // 显示权限提示框
    private func showPermissionAlert() {
        let alert = UIAlertController(title: "需要相机权限", message: "请在设置中开启相机权限", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:  "去设置", style:.default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString)  {
                UIApplication.shared.open(settingsURL)
            }
        })
        present(alert, animated: true)
    }
    
    // 实现 UIImagePickerControllerDelegate 协议方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated:  true)
        if let image = info[.originalImage] as? UIImage {
            onImageCaptured?(image)
            self.dismiss(animated: true)

        }
    }
}
 
 
