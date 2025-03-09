//
//  File.swift
//  PaiZhaoShiHua
//
//  Created by 陈希 on 2025/3/8.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import UIKit

final class DashScopeAPI: NSObject {
    static let shared = DashScopeAPI()
    
    private let apiKey = ""
    private let baseURL = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions"
    
    private var hasReceivedFirstData = false // 记录是否收到首条数据
    
    func sendMessage(withText text: String, imageURL: String?, isStreaming: Bool = true) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var content: [[String: Any]] = [["type": "text", "text": text]]
        if let imageURL = imageURL {
            content.append(["type": "image_url", "image_url": ["url": imageURL]])
        }
        
        let requestBody: [String: Any] = [
            "model": "qwen-vl-max",
            "messages": [["role": "user", "content": content]],
            "stream": isStreaming
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
    }
  
}

// MARK: - URLSessionDataDelegate
extension DashScopeAPI: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let jsonString = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.processStreamingData(jsonString)
//                print(jsonString)
            }
        }
    }

    private func processStreamingData(_ jsonString: String) {
        let lines = jsonString.split(separator: "\n") // 按行拆分
        
        for line in lines {
            let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines) // 去除空格和换行
            
            // 终止解析的判断
            if cleanLine == "data: [DONE]" {
                print("流式数据接收完毕")
                NotificationCenter.default.post(name: NSNotification.Name("StreamComplete"),
                                              object: nil)
                self.hasReceivedFirstData = false // 重置状态

                isPushed = false
                return
            }
            
            let jsonStr = cleanLine.replacingOccurrences(of: "data: ", with: "") // 移除前缀
            guard let jsonData = jsonStr.data(using: .utf8) else { continue }
            
            do {
                let response = try JSONDecoder().decode(DashScopeResponse.self, from: jsonData)
                if let content = response.choices.first?.delta.content {
                    print("解析出的内容: \(content)")
                    if !hasReceivedFirstData {
                        hasReceivedFirstData = true
                        // 发送首条数据的通知
                        NotificationCenter.default.post(name: NSNotification.Name("FirstDataReceived"), object: content)
//                        NotificationCenter.default.post(name: NSNotification.Name("StreamingUpdate"), object: content)

                    } else {
                        // 发送后续数据的通知
                        NotificationCenter.default.post(name: NSNotification.Name("StreamingUpdate"), object: content)
                    }                }
            } catch {
                // 忽略错误，继续解析后续数据
                print("JSON 解析错误: \(error.localizedDescription)")
            }
        }
    }
}





import Foundation

// 顶层 JSON 结构
struct DashScopeResponse: Decodable {
    let choices: [Choice]
}

// `choices` 数组的结构
struct Choice: Decodable {
    let delta: Delta
}

// `delta` 字段的结构
struct Delta: Decodable {
    let content: String?
}
