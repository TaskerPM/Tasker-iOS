//
//  LoginService.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

import Foundation

struct LoginService {
    let urlSession: URLSession = URLSession.shared
    
    func requestLogin(phoneNumber: String, completion: @escaping (Result<SMSSendResponse, URLSessionError>) -> Void) {
        let loginRequest = LoginRequest(phoneNumber: phoneNumber)
        guard let request = loginRequest.urlRequest else { return }
        
        urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completion(.failure(.responseFailed(code: response.statusCode)))
                return
            }
            
            guard let data, let jsonData = JSONParser.decodeData(of: data, type: SMSSendResponse.self) else {
                completion(.failure(.invaildData))
                return
            }
            
            completion(.success(jsonData))
        }.resume()
    }
}

struct LoginRequest: NetworkRequest {
    typealias ResponseType = SMSSendResponse
    
    let httpMethod: HttpMethod = .post
    let urlHost: String = "https://dev.taskerpm.shop/"
    var urlPath: String = "v1/sms/send"
    var queryParameters: [String : String] = [:]
    var httpHeader: [String : String]?
    var httpBody: Data?
    
    init(phoneNumber: String) {
        httpHeader = ["Content-Type": "application/json"]
        
        httpBody = JSONParser.encodeToData(with: SMSSendRequest(phoneNum: phoneNumber))
    }
}
