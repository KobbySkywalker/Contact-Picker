//
//  Encodable.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        var param: [String: Any] = [: ]
        do {
            let param1 = try DictionaryEncoder().encode(self)
            param = param1 as! [String: Any]
        } catch {
            print("Couldnt parse parameter")
        }
        return param
    }
}

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
