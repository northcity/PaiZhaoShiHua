//
//  UIViewController+TDCategory.swift
//  ToDoList
//
//  Created by NorthCityDevMac on 2022/6/21.
//

import UIKit.UIViewController
import MessageUI
//import Kingfisher
//import KingfisherWebP
import SVProgressHUD

//extension MFMailComposeViewControllerDelegate{
//    
//}

extension UIViewController: @preconcurrency MFMailComposeViewControllerDelegate {
    @MainActor  // 添加此标记
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // 方法实现
    }

//    反馈建议，发送邮件
    public func feedBackUseMail(content: String = "",
                               toRecipients:[String]? = ["50634391@qq.com"],
                               attachmentArray:[[String:Any]]? = nil) {
        if !MFMailComposeViewController.canSendMail() {
//            AppMacro.openURLForString("mailto://")
            if let url = URL(string: "mailto://") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        }
        let mailVc = MFMailComposeViewController()
        mailVc.mailComposeDelegate = self
        
        let appName = "[拍照识花 iOS]-feedback"
        guard let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] else {
            return
        }
        
        
        
        let systemVersion = UIDevice.current.systemVersion

        var systemInfo = utsname()
                uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
                       return String(cString: ptr)
                   }
                
        let sendString = "\(appName)" + " (" + "\(appVersion)" + "," + "\(systemVersion)" + "," + "\(platform)" + ")"
        
        
        mailVc.setSubject(sendString)
        mailVc.setToRecipients(toRecipients)
        mailVc.setMessageBody(content, isHTML: false)
        
        if let attachmentArray = attachmentArray {
            for attachment in attachmentArray {
                let data = attachment["data"] as! Data ?? Data()
                let fileName = attachment["fileName"] as? String ?? ""
                let mimeType = attachment["mimeType"] as? String ?? ""
                if data.count > 0, !fileName.isEmpty, !mimeType.isEmpty {
                    mailVc.addAttachmentData(data, mimeType: mimeType, fileName: fileName)
                }
            }
        }
        
        present(mailVc, animated: true, completion: nil)
        
    }
    
    //    反馈建议，发送邮件
        public func feedBackFaqUseMail(content: String = "",
                                   toRecipients:[String]? = ["todolist@betterapptech.com"],
                                   attachmentArray:[[String:Any]]? = nil) {
            if !MFMailComposeViewController.canSendMail() {
    //            AppMacro.openURLForString("mailto://")
                if let url = URL(string: "mailto://") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                return
            }
            let mailVc = MFMailComposeViewController()
            mailVc.mailComposeDelegate = self
            
            let appName = "[TodoList iOS]-feedback"
            guard let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] else {
                return
            }
            
            
            
            let systemVersion = UIDevice.current.systemVersion

            var systemInfo = utsname()
                    uname(&systemInfo)
            let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
                           return String(cString: ptr)
                       }
            
            let sendString = "\(appName)" + " (" + "\(appVersion)" + "," + "\(systemVersion)" + "," + "\(platform)" + ",)"
            
            
            mailVc.setSubject(sendString)
            mailVc.setToRecipients(toRecipients)
            mailVc.setMessageBody(content, isHTML: false)
            
            if let attachmentArray = attachmentArray {
                for attachment in attachmentArray {
                    let data = attachment["data"] as! Data ?? Data()
                    let fileName = attachment["fileName"] as? String ?? ""
                    let mimeType = attachment["mimeType"] as? String ?? ""
                    if data.count > 0, !fileName.isEmpty, !mimeType.isEmpty {
                        mailVc.addAttachmentData(data, mimeType: mimeType, fileName: fileName)
                    }
                }
            }
            
            present(mailVc, animated: true, completion: nil)
            
        }
    
    //    反馈建议，发送邮件
        public func feedBackFocusUseMail(content: String = "",
                                   toRecipients:[String]? = ["todolist@betterapptech.com"],
                                   attachmentArray:[[String:Any]]? = nil) {
            if !MFMailComposeViewController.canSendMail() {
    //            AppMacro.openURLForString("mailto://")
                if let url = URL(string: "mailto://") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                return
            }
            let mailVc = MFMailComposeViewController()
            mailVc.mailComposeDelegate = self
            
            let appName = "[TodoList iOS]-Focus"
            guard let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] else {
                return
            }
            
            
            
            let systemVersion = UIDevice.current.systemVersion

            var systemInfo = utsname()
                    uname(&systemInfo)
            let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
                           return String(cString: ptr)
                       }
            
            let sendString = "\(appName)" + " (" + "\(appVersion)" + "," + "\(systemVersion)" + "," + "\(platform)" + ",)"

            
            mailVc.setSubject(sendString)
            mailVc.setToRecipients(toRecipients)
            mailVc.setMessageBody(content, isHTML: false)
            
            if let attachmentArray = attachmentArray {
                for attachment in attachmentArray {
                    let data = attachment["data"] as! Data ?? Data()
                    let fileName = attachment["fileName"] as? String ?? ""
                    let mimeType = attachment["mimeType"] as? String ?? ""
                    if data.count > 0, !fileName.isEmpty, !mimeType.isEmpty {
                        mailVc.addAttachmentData(data, mimeType: mimeType, fileName: fileName)
                    }
                }
            }
            
            present(mailVc, animated: true, completion: nil)
            
        }
    
    public func feedBackHabitUseMail(content: String = "",
                               toRecipients:[String]? = ["todolist@betterapptech.com"],
                               attachmentArray:[[String:Any]]? = nil) {
        if !MFMailComposeViewController.canSendMail() {
//            AppMacro.openURLForString("mailto://")
            if let url = URL(string: "mailto://") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        }
        let mailVc = MFMailComposeViewController()
        mailVc.mailComposeDelegate = self
        
        let appName = "[TodoList iOS]-habit"
        guard let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] else {
            return
        }
        
        
        
        let systemVersion = UIDevice.current.systemVersion

        var systemInfo = utsname()
                uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
                       return String(cString: ptr)
                   }
        
        let sendString = "\(appName)" + " (" + "\(appVersion)" + "," + "\(systemVersion)" + "," + "\(platform)" + ",)"

        
        mailVc.setSubject(sendString)
        mailVc.setToRecipients(toRecipients)
        mailVc.setMessageBody(content, isHTML: false)
        
        if let attachmentArray = attachmentArray {
            for attachment in attachmentArray {
                let data = attachment["data"] as! Data ?? Data()
                let fileName = attachment["fileName"] as? String ?? ""
                let mimeType = attachment["mimeType"] as? String ?? ""
                if data.count > 0, !fileName.isEmpty, !mimeType.isEmpty {
                    mailVc.addAttachmentData(data, mimeType: mimeType, fileName: fileName)
                }
            }
        }
        
        present(mailVc, animated: true, completion: nil)
        
    }
    
    public func shareAppAction(_ station:Any,sourceView: UIView? = nil) {
        let shareDes = String(format: station as! String)
        shareController(items: [shareDes + " \("# Powered by To-do List.\nTap to download:https://apps.apple.com/app/to-do-list-task-reminders/id1640609657")"],sourceView: sourceView)
//        shareController(items: ["\("https://apps.apple.com/app/to-do-list-task-reminders/id1640609657")"])

    }
    
//封装的分享
    public func shareAlertAppAction(_ station:Any,sourceView: UIView? = nil) {
        let shareDes = String(format: station as! String)
        shareController(items: [shareDes],sourceView: sourceView)
//        shareController(items: ["\("https://apps.apple.com/app/to-do-list-task-reminders/id1640609657")"])

    }
    
    public func showDocumentPickVc() {
//        let docVc = UIDocumentPickerViewController()
//        docVc.delegate = self
//        present(docVc, animated: true, completion: nil)
    }
}


// MARK: - Alert

extension UIViewController {
//    弹出默认弹窗
    public func showAppAlertController(_ title: String? = nil,
                                       msg message: String? = nil,
                                       actions:[String],
                                       style alertStyle:UIAlertController.Style = .alert,
                                       handlder:((_ alertAction: UIAlertAction) -> Void)? = nil){
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for string in actions {
            let action = UIAlertAction(title: string, style: .default) { alertAction in
                handlder?(alertAction)
            }
            alertVc.addAction(action)
        }
        present(alertVc, animated: true, completion: nil)
        
    }
//    获取当前顶层vc
    static func currentTopVc(controller:UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navVc = controller as? UINavigationController {
            return currentTopVc(controller: navVc.visibleViewController)
        }
         
        if let tabbarViewController = controller as? UITabBarController {
            if let seleted = tabbarViewController.selectedViewController {
                return currentTopVc(controller: seleted)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return currentTopVc(controller: presented)
            
        }
        return controller
    }
    
    static func currentTopNav(_ ctr: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navVc = ctr as? UINavigationController,
           let topNav = navVc.topViewController{
            return topNav
        }else if let ctr = currentSeletedTabbarCtr(ctr) {
            return currentTopNav(ctr)
        }
        return ctr
    }
    
    static func currentSeletedTabbarCtr(_ ctr: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let tabBarCtr = ctr as? UITabBarController,
           let seleteCtr = tabBarCtr.selectedViewController {
            return seleteCtr
        }
        return ctr
    }
    
    public func showShareVc(items: [Any],
                            sourceView: UIView? = nil,
                            activites:[UIActivity]? = nil,
                            hander: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        let shareVc = UIActivityViewController(activityItems: items, applicationActivities: activites)
        shareVc.completionWithItemsHandler = hander
    }

    
    public func shareController(items: [Any],
                                sourceView: UIView? = nil,
                                activities: [UIActivity]? = nil,
                                handler: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        let shareVC = UIActivityViewController(activityItems: items, applicationActivities: activities)
        shareVC.completionWithItemsHandler = handler
//        if isIPad {
//            shareVC.popoverPresentationController?.sourceView = sourceView
//            shareVC.popoverPresentationController?.sourceRect = sourceView?.bounds ?? .zero
//            shareVC.popoverPresentationController?.permittedArrowDirections = .any
//        }
        present(shareVC, animated: true, completion: nil)
    }
    
//    计算高度
    func  textHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return text.boundingRect(with:CGSize(width: width, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font:UIFont.init(name: "HelveticaNeue", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)], context:nil).size.height
    }
    
    func textTaskSubHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return text.boundingRect(with:CGSize(width: width, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font:UIFont.init(name: "HelveticaNeue-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)], context:nil).size.height
    }
}


//extension UIViewController {
//    func pushAlertNav(PanModalNavigationController:UINavigationController?,pushToVc:UIViewController,pushHeight:Int) {
//        let nav = PanModalNavigationController as! TDRepeatNavViewController
//        
//        nav.longHeight = pushHeight*Int(kAuto_width)
//        nav.panModalSetNeedsLayoutUpdate()
//        nav.panModalTransitionTo(state: .short, animated: true)
////        nav.allowsTapBackgroundToDismiss()
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            nav.pushViewController(pushToVc, animated: true)
//        }
//    }
//    
//    func pushAlertNav(PanModalNavigationController:UINavigationController?,pushToVc:UIViewController,pushHeight:Int,animation:Bool) {
//        let nav = PanModalNavigationController as! TDRepeatNavViewController
//        
//        nav.longHeight = pushHeight*Int(kAuto_width)
//        nav.panModalSetNeedsLayoutUpdate()
//        nav.panModalTransitionTo(state: .short, animated: animation)
//
////        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            nav.pushViewController(pushToVc, animated: animation)
////        }
//    }
//    
//    func popAlertNav(PanModalNavigationController:UINavigationController?,popHeight:Int) {
//        let nav = PanModalNavigationController as! TDRepeatNavViewController
//        nav.longHeight = popHeight*Int(kAuto_width)
//        nav.panModalSetNeedsLayoutUpdate()
//        nav.panModalTransitionTo(state: .short, animated: true)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            nav.popViewController(animated: true)
//        }
//    }
//    
//    func popAlertNavAppointVc(PanModalNavigationController:UINavigationController?,popHeight:Int) {
//        let nav = PanModalNavigationController as! TDRepeatNavViewController
//        nav.longHeight = popHeight*Int(kAuto_width)
//        nav.panModalSetNeedsLayoutUpdate()
//        nav.panModalTransitionTo(state: .short, animated: true)
//       
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            if nav.viewControllers.count >= 2 {
//                let vc = nav.viewControllers[nav.viewControllers.count - 2]
//                nav.popToViewController(vc, animated: false)
//            }
//        }
//    }
//    
//    
////    for (UIViewController *controllerinself.navigationController.viewControllers) {
////            if ([controllerisKindOfClass:[GetMoneyVCclass]]) {
////                GetMoneyVC *revise =(GetMoneyVC *)controller;
////                [self.navigationControllerpopToViewController:reviseanimated:YES];
////            }
////        }
////    ————————————————
////    版权声明：本文为CSDN博主「liyubao160」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
////    原文链接：https://blog.csdn.net/u011146511/article/details/78221865
//    
//    
//}


// MARK: - MFMailComposeViewControllerDelegate

//extension UIViewController: MFMailComposeViewControllerDelegate {
//    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch result {
//        case .sent: // 发送成功
//            SVProgressHUD.showInfo(withStatus: "发送成功")
//            SVProgressHUD.dismiss(withDelay: 0.5)
////            self.makeToast(text, position: postion)
////            view.showTextToast("")
//        case .failed:
//            SVProgressHUD.showInfo(withStatus: "发送失败")
//            SVProgressHUD.dismiss(withDelay: 0.5)
////            view.showTextToast("")
//            break
//        default:
//            break
//        }
//        controller.dismiss(animated: true, completion: nil)
//    }
//}

//extension UIViewController {
//    func avPlayerPlay(name:String){
//        TDLocalAvAudioPlayer.sharedAudioPlayer.stopAudio()
//        if let audioPath = Bundle.main.path(forResource:name, ofType: "mp3"){
//            TDLocalAvAudioPlayer.sharedAudioPlayer.playAudioWithPath(audioPath: audioPath)
//            TDLocalAvAudioPlayer.sharedAudioPlayer.playAudio()
//        }
//    }
//}
