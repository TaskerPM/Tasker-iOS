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
            
            // 리스폰스에 어떤 데이터가 넘어오는지 체크해봐야함. 데이터를 LoginResponse로 변환하는 로직
            completion(.success(LoginResponse(value: "temp", message: "임시 데이터")))
        }
        
    }
}

struct LoginRequest: NetworkRequest {
    typealias ResponseType = LoginResponse
    
    let httpMethod: HttpMethod = .post
    let urlHost: String = "https://dev.taskerpm.shop/v1"
    var urlPath: String = "/sms/send"
    var queryParameters: [String : String] = [:]
    var httpHeader: [String : String]?
    var httpBody: Data?
}
