//
//  LoginService.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

import Foundation

struct LoginService {
    let loginRequest: LoginRequest = LoginRequest()
    let urlSession: URLSession = URLSession.shared
    
    func login(phoneNumber: String, completion: @escaping (Result<LoginResponse, URLSessionError>) -> Void) {
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
            
            guard let data, let jsonData = JSONParser.decodeData(of: data, type: LoginResponse.self) else {
                completion(.failure(.invaildData))
                return
            }
            
            completion(.success(jsonData))
        }
        
    }
}

struct LoginRequest: NetworkRequest {
    typealias ResponseType = LoginResponse
    
    let httpMethod: HttpMethod = .post
    let urlHost: String = "https://dev.taskerpm.shop/"
    var urlPath: String = "v1/sms/send"
    var queryParameters: [String : String] = [:]
    var httpHeader: [String : String]?
    var httpBody: Data?
}
