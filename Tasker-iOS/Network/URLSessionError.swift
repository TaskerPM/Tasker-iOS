//
//  URLSessionError.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/04/19.
//

import Foundation

enum URLSessionError: LocalizedError {
    case invalidRequest
    case requestFailed(description: String)
    case responseFailed(code: Int)
    case invaildData
    case invaildURL
    
    var errorDescription: String {
        switch self {
        case .invalidRequest:
            return "invalidRequest"
        case .requestFailed(let description):
            return description
        case .responseFailed(let code):
            return "statusCode: \(code)"
        case .invaildData:
            return "invaildData"
        case .invaildURL:
            return "invaildURL"
        }
    }
}
