//
//  Extension.swift
//  dollarbit
//
//  Created by Andrey Posnov on 22.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import Foundation

extension Encodable {
    func toString() -> String {
        guard let data = try? JSONEncoder().encode(self) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func encodeSorted(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        encoder.outputFormatting = .sortedKeys
        return try encoder.encode(self)
    }
}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self? {
        do {
            let newdata = try decoder.decode(Self.self, from: data)
            return newdata
        } catch {
            print("decodable model error", error.localizedDescription)
            return nil
        }
    }
    static func decodeArray(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> [Self]{
        do {
            let newdata = try decoder.decode([Self].self, from: data)
            return newdata
        } catch {
            print("decodable model error", error.localizedDescription)
            return []
        }
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
