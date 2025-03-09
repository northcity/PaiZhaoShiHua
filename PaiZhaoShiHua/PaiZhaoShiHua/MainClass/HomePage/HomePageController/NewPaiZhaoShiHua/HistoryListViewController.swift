//
//  HistoryListViewController.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class HistoryListViewController: UIViewController {
    private var records: [HistoryRecord] = []
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = AppColor.background
        tv.separatorStyle = .none
        tv.register(HistoryCell.self, forCellReuseIdentifier: "cell")
        tv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        let imageView = UIImageView(image: UIImage(systemName: "photo.on.rectangle.angled"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColor.accent.withAlphaComponent(0.5)
        
        let label = UILabel()
        label.text = "还没有识别记录哦~\n拍张花花试试吧！"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Chalkboard SE", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textColor = AppColor.secondaryText
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.size.equalTo(100)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.background
        title = "识别历史"
        
        // 配置导航栏
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = AppColor.background.withAlphaComponent(0.8)
        appearance.titleTextAttributes = [
            .foregroundColor: AppColor.primaryText,
            .font: UIFont(name: "Chalkboard SE", size: 17) ?? UIFont.systemFont(ofSize: 17)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppColor.primaryText,
            .font: UIFont(name: "Chalkboard SE", size: 34) ?? UIFont.systemFont(ofSize: 34)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColor.accent
        
        // 添加空状态视图
        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 配置表格视图
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
            
            // 更新空状态视图
            emptyStateView.isHidden = !records.isEmpty
            tableView.isHidden = records.isEmpty
        } catch {
            print("数据加载失败: \(error)")
        }
    }
    
    private func deleteRecord(at indexPath: IndexPath) {
        let record = records.remove(at: indexPath.row)
        
        // 添加删除动画
        let cell = tableView.cellForRow(at: indexPath) as? HistoryCell
        UIView.animate(withDuration: 0.3, animations: {
            cell?.contentView.alpha = 0
            cell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            // 删除文件
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(record.imagePath ?? "")
            try? FileManager.default.removeItem(at: fileURL)
            
            // 删除数据库记录
            CoreDataManager.shared.context.delete(record)
            CoreDataManager.shared.saveContext()
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // 检查是否需要显示空状态
            self.emptyStateView.isHidden = !self.records.isEmpty
            self.tableView.isHidden = self.records.isEmpty
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
        // 添加选中动画
        if let cell = tableView.cellForRow(at: indexPath) as? HistoryCell {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = CGAffineTransform.identity
                }) { _ in
                    let detailVC = DisplayViewController()
                    detailVC.record = self.records[indexPath.row]
                    self.present(detailVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] _, _, completion in
            self?.deleteRecord(at: indexPath)
            completion(true)
        }
        
        // 自定义删除按钮样式
        deleteAction.backgroundColor = AppColor.accent
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
