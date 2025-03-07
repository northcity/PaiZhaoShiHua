//
//  CoreDataManager.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import CoreData

class CoreDataManager {
    nonisolated(unsafe) static let shared = CoreDataManager()
    
    // 容器名称必须与数据模型文件完全一致
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HistoryRecord")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("CoreData 初始化失败: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("保存失败: \(nsError), \(nsError.userInfo)")
        }
    }
}
