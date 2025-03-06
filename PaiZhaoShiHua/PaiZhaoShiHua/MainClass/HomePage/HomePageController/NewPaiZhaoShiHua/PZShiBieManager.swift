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

struct ChatRequest: Codable {
    let model: String
    let messages: [Message]
    let stream: Bool  // 新增的流式输出开关
    
    // 更新初始化方法（可选，根据实际需要）
    init(model: String, messages: [Message], stream: Bool = false) {
        self.model = model
        self.messages = messages
        self.stream = stream
    }
    
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
            
            init(text: String) {
                self.type = "text"
                self.text = text
                self.image_url = nil
            }
            
            init(imageUrl: String) {
                self.type = "image_url"
                self.text = nil
                self.image_url = ImageURL(url: imageUrl)
            }
        }
    }
}

struct ResponseModel: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

// MARK: - API 请求方法
func sendChatRequest(
    apiKey: String,
    model: String,
    messages: [ChatRequest.Message],
    stream: Bool = false  // 添加 stream 参数（默认 false）
) async throws -> Data {
    let endpoint = URL(string: "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions")!
    
    var request = URLRequest(url: endpoint)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody = ChatRequest(model: model, messages: messages,stream: false)
    request.httpBody = try JSONEncoder().encode(requestBody)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    return data
}




