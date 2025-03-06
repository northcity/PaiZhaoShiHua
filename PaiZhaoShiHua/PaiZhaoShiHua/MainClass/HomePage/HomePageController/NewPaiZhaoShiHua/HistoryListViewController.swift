//
//  File.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import Foundation
import CoreData
class HistoryListViewController: UIViewController {
    private var records: [HistoryRecord] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func setupUI() {
           view.backgroundColor = .systemGroupedBackground
           title = "识别历史"
           
           // 配置导航栏
           navigationController?.navigationBar.prefersLargeTitles = true
           navigationItem.largeTitleDisplayMode = .always
           
           // 配置表格视图
           tableView.separatorStyle = .none
           tableView.backgroundColor = .clear
           tableView.register(HistoryCell.self, forCellReuseIdentifier: "cell")
           tableView.dataSource = self
           tableView.delegate = self
           tableView.rowHeight = UITableView.automaticDimension
           tableView.estimatedRowHeight = 100
           
           view.addSubview(tableView)
           tableView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
           }
       }
    
    private func loadData() {
        let request: NSFetchRequest<HistoryRecord> = HistoryRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]
        
        do {
            records = try CoreDataManager.shared.context.fetch(request)
            tableView.reloadData()
        } catch {
            print("数据加载失败: \(error)")
        }
    }
}

extension HistoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryCell
        cell.configure(with: records[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DisplayViewController()
        detailVC.record = records[indexPath.row]
        self.present(detailVC, animated: true)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecord(at: indexPath)
        }
    }
    
    private func deleteRecord(at indexPath: IndexPath) {
        let record = records.remove(at: indexPath.row)
        
        // 删除文件
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(record.imagePath ?? "")
        try? FileManager.default.removeItem(at: fileURL)
        
        // 删除数据库记录
        CoreDataManager.shared.context.delete(record)
        CoreDataManager.shared.saveContext()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
