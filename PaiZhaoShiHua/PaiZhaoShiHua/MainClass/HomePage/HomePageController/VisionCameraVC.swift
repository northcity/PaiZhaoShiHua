//
//  File.swift
//  PaiZhaoShiHua
//
//  Created by NorthCityDevMac on 2025/2/25.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
import AVFoundation

protocol ImageProcessor: AnyObject {
    func processImage(_ image: UIImage)
}

class VisionCameraVC: UIViewController {
    
    // MARK: - UI Components
    private let captureButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white.withAlphaComponent(0.9)
        btn.layer.cornerRadius = 40
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 8
        btn.layer.shadowOpacity = 0.2
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let galleryButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "photo.stack"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let session = AVCaptureSession()
    weak var delegate: ImageProcessor?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCameraPermissions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        view.addSubview(captureButton)
        view.addSubview(galleryButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant: 80),
            captureButton.heightAnchor.constraint(equalTo: captureButton.widthAnchor),
            
            galleryButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            galleryButton.widthAnchor.constraint(equalToConstant: 44),
            galleryButton.heightAnchor.constraint(equalTo: galleryButton.widthAnchor)
        ])
    }
    
    // MARK: - Camera Setup
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    // MARK: - Interaction
    private func setupGestures() {
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
    }
    
    @objc private func captureImage() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType]
        settings.previewPhotoFormat = previewFormat
        
        // 拍照逻辑...
    }
    
    @objc private func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // MARK: - Success Animation
    private func playSuccessAnimation() {
        UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.6) {
            self.captureButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.captureButton.backgroundColor = .systemGreen.withAlphaComponent(0.9)
        }.startAnimation()
        
        UIView.animate(withDuration: 0.4, delay: 0.5, options: []) {
            self.captureButton.transform = .identity
            self.captureButton.backgroundColor = .white.withAlphaComponent(0.9)
        }
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.global(qos: .userInitiated).async {
//                self.session.startRunning()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.global(qos: .userInitiated).async {
//                        self.session.startRunning()
                    }
                }
            }
        default:
            showPermissionAlert()
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(title: "需要相机权限", message: "请在设置中开启相机权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        present(alert, animated: true)
    }
}

// MARK: - Image Picker Delegate
extension VisionCameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        delegate?.processImage(image)
        playSuccessAnimation()
    }
}

// MARK: - Camera Permissions
extension VisionCameraVC {
   
}

