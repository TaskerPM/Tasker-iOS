//
//  LoginModel.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

struct SMSSendResponse: Decodable {
    let value: String
    let message: String?
}

struct SMSSendRequest: Encodable {
    let phoneNum: String
}
