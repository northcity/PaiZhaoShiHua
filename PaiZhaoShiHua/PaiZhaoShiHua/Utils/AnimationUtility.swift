import UIKit

class AnimationUtility {
    
    // MARK: - 触觉反馈
    
    static func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func triggerSelectionHaptic() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    // MARK: - 视图动画
    
    /// 弹性入场动画 - 使用 UIViewPropertyAnimator 提高性能
    static func springInAnimation(for view: UIView, delay: TimeInterval = 0, damping: CGFloat = 0.7) {
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: damping) {
            view.transform = .identity
            view.alpha = 1
        }
        
        animator.startAnimation(afterDelay: delay)
    }
    
    /// 顺序动画 - 为多个视图提供按顺序出现的动画效果
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
    
    /// 按压效果动画 - 使用 UIViewPropertyAnimator 替代 UIView.animate
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
    
    /// 释放效果动画 - 使用弹性效果
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
    
    /// 呼吸动画 - 为视图添加轻微的呼吸效果
    static func addBreathingAnimation(to view: UIView, duration: TimeInterval = 2.0) {
        let breathingAnimation = CABasicAnimation(keyPath: "transform.scale")
        breathingAnimation.fromValue = 1.0
        breathingAnimation.toValue = 1.05
        breathingAnimation.duration = duration
        breathingAnimation.autoreverses = true
        breathingAnimation.repeatCount = .infinity
        breathingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        view.layer.add(breathingAnimation, forKey: "breathing")
    }
} 