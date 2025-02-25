//
//  PZShiBieManager.swift
//  PaiZhaoShiHua
//
//  Created by NorthCityDevMac on 2025/2/25.
//  Copyright © 2025 com.beicheng. All rights reserved.
//

import Foundation
import SVProgressHUD
import AliyunOSSiOS

// MARK: - 数据结构定义
struct ChatRequest: Codable {
    let model: String
    let messages: [Message]
    
    struct Message: Codable {
        let role: String
        let content: [Content]
        
        struct Content: Codable {
            let type: String
            let text: String?
            let image_url: ImageURL?
            
            struct ImageURL: Codable {
                let url: String
            }
            
            // 文本内容初始化
            init(text: String) {
                self.type = "text"
                self.text = text
                self.image_url = nil
            }
            
            // 图片内容初始化
            init(imageUrl: String) {
                self.type = "image_url"
                self.text = nil
                self.image_url = ImageURL(url: imageUrl)
            }
        }
    }
}

// MARK: - API 请求方法
func sendChatRequest(
    apiKey: String,
    model: String,
    messages: [ChatRequest.Message]
) async throws -> Data {
    let endpoint = URL(string: "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions")!
    
    var request = URLRequest(url: endpoint)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody = ChatRequest(model: model, messages: messages)
    request.httpBody = try JSONEncoder().encode(requestBody)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    return data
}




