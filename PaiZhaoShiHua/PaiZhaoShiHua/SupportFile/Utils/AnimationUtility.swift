//
//  AnimationUtility.h
//  shijianjiaonang
//
//  Created by chenxi on 2025/3/7.
//  Copyright © 2025 chenxi. All rights reserved.
//

import UIKit
class AnimationUtility {
    
    // MARK: - 触觉反馈
    
    @MainActor
    static func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    @MainActor
    static func triggerSelectionHaptic() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    // MARK: - 视图动画
    
    /// 弹性入场动画
    @MainActor
    static func springInAnimation(for view: UIView, delay: TimeInterval = 0, damping: CGFloat = 0.7) {
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: damping) {
            view.transform = .identity
            view.alpha = 1
        }
        
        animator.startAnimation(afterDelay: delay)
    }
    
    /// 顺序动画
    @MainActor
    static func sequentialAnimation(for views: [UIView], initialDelay: TimeInterval = 0.1, interval: TimeInterval = 0.08) {
        for (index, view) in views.enumerated() {
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: 0, y: 20)
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.4,
                delay: initialDelay + Double(index) * interval,
                options: [],
                animations: {
                    view.alpha = 1
                    view.transform = .identity
                }
            )
        }
    }
    
    /// 按压效果动画
    @MainActor
    static func pressAnimation(for view: UIView, scale: CGFloat = 0.92, completion: ((Bool) -> Void)? = nil) {
        let pressAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        pressAnimator.addCompletion { position in
            if position == .end {
                completion?(true)
            }
        }
        
        pressAnimator.startAnimation()
    }
    
    /// 释放效果动画
    @MainActor
    static func releaseAnimation(for view: UIView, completion: ((Bool) -> Void)? = nil) {
        let releaseAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.6) {
            view.transform = .identity
        }
        
        releaseAnimator.addCompletion { position in
            if position == .end {
                completion?(true)
            }
        }
        
        releaseAnimator.startAnimation()
    }
    
    /// 呼吸动画
    @MainActor
    static func addBreathingAnimation(to view: UIView, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                
                // 关键帧时间点（0.0 - 1.0）
                scaleAnimation.keyTimes = [0.0, 0.25, 0.75, 1.0]
                
                // 对应时间点的缩放值
                scaleAnimation.values = [
                    1.0,   // 起始点
                    1.15,  // 放大到115%
                    0.95,  // 缩小到95%
                    1.0    // 恢复原状
                ]
                
                // 更自然的缓动曲线
                scaleAnimation.timingFunctions = [
                    CAMediaTimingFunction(name: .easeOut),
                    CAMediaTimingFunction(name: .easeInEaseOut),
                    CAMediaTimingFunction(name: .easeIn)
                ]
                
                // 动画参数配置
                scaleAnimation.duration = duration
                scaleAnimation.repeatCount = .infinity
                scaleAnimation.autoreverses = false  // 禁用自动反转
                
                // 透明度动画保持原有
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = 1.0
                opacityAnimation.toValue = 0.85
                opacityAnimation.autoreverses = true
                
                // 组合动画
                let group = CAAnimationGroup()
                group.animations = [scaleAnimation, opacityAnimation]
                group.duration = duration * 1.2  // 延长总时长
                group.repeatCount = .infinity
                
                // 保持动画结束状态
                group.isRemovedOnCompletion = false
                group.fillMode = .forwards
                
                view.layer.add(group, forKey: "waveBreathing")
        }
    }
}
