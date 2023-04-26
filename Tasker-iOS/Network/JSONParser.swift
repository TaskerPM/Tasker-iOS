//
//  JSONParser.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/23.
//

import Foundation

enum JSONParser {
    static func decodeData<T: Decodable>(of JSON: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        var decodedData: T?
        do {
            decodedData = try decoder.decode(type, from: JSON)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("could not find key \(key) in JSON: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("could not find type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            print("data found to be corrupted in JSON: \(context.debugDescription)")
        } catch let error as NSError {
            NSLog("Error in decodeData(of:type:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
        return decodedData
    }
    
    static func encodeToData<T: Encodable>(with modelData: T) -> Data? {
        let encoder = JSONEncoder()
        
        var data: Data?
        do {
            data = try encoder.encode(modelData)
        } catch let error as NSError {
            NSLog("Error in encodeToData(with:) domain= \(error.domain), description= \(error.localizedDescription)")
        }
        
        return data
    }
}
