//
//  SearchViewController.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/1.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// MARK: - 搜索主页面
class SearchViewController: UIViewController {
    
    // MARK: 组件声明
    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: 界面配置
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 搜索输入框配置
        searchTextField.placeholder = "请输入关键词"
        searchTextField.borderStyle = .roundedRect
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        view.addSubview(searchTextField)
        
        // 搜索按钮配置
        searchButton.setTitle("搜索", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.layer.cornerRadius = 8
        searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
        view.addSubview(searchButton)
        
        // 加载指示器
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    // MARK: 布局约束
    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: 搜索操作
    @objc private func performSearch() {
        guard let query = searchTextField.text?.trimmingCharacters(in: .whitespaces), !query.isEmpty else {
//            showAlert(title: "提示", message: "请输入搜索内容")
            return
        }
        
        searchTextField.resignFirstResponder()
        activityIndicator.startAnimating()
        
        SearchService.search(query: query) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let results):
                self?.showResults(results: results)
            case .failure(let error):
                print("错误")
//                self?.showAlert(title: "错误", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: 跳转结果页
    private func showResults(results: [SearchResult]) {
        let resultsVC = SearchResultsViewController()
        resultsVC.searchResults = results
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}

// MARK: - 文本输入代理
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}

// MARK: - 搜索结果页
class SearchResultsViewController: UIViewController {
    
    var searchResults: [SearchResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    private func setupTable() {
        view.backgroundColor = .white
        title = "搜索结果"
        
        tableView.register(ResultCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - 表格数据源
extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultCell
        cell.configure(with: searchResults[indexPath.row])
        return cell
    }
}

// MARK: - 表格交互
extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 处理点击事件
    }
}

// MARK: - 搜索结果单元格
class ResultCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.textColor = .secondaryLabel
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with result: SearchResult) {
        titleLabel.text = result.title
        detailLabel.text = result.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 网络服务
struct SearchService {
    static func search(query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        // 实际项目中替换为真实API地址
        guard let url = URL(string: "https://api.example.com/search?q=\(query)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
//                    completion(.failure(error))
                }
                return
            }
            
            // 模拟数据
            let mockResults = [
                SearchResult(title: "结果1", description: "这是第一个搜索结果"),
                SearchResult(title: "结果2", description: "这是第二个搜索结果")
            ]
            
            DispatchQueue.main.async {
//                completion(.success(mockResults))
            }
        }.resume()
    }
}

// MARK: - 数据模型
struct SearchResult {
    let title: String
    let description: String
}
