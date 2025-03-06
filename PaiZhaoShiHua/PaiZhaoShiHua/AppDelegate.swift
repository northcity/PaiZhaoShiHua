//
//  AppDelegate.swift
//  PaiZhaoShiHua
//
//  Created by NorthCityDevMac on 2024/11/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = HomeViewController()
        window?.backgroundColor = .white;
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
                
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
}

