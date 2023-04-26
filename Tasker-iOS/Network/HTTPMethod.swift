//
//  HTTPMethod.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

enum HttpMethod {
    case get
    case post
    case put
    case patch
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
