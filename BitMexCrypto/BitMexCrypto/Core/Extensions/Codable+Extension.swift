//
//  Codable+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

extension Encodable {
    public func jsonString() throws -> String {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .withoutEscapingSlashes
        encoder.dateEncodingStrategy = .iso8601withFractionalSeconds
        do {
            let encoded = try encoder.encode(self)
            guard let json = String(data: encoded, encoding: .utf8) else {
                throw WebSocketError.stringToDataConvertingFailed
            }
            return json
        } catch {
            throw error
        }
    }
}

extension String {
    public func modelObject<T: Decodable>() throws -> T {
        let decoder: JSONDecoder = .init()
        decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
        guard let data = data(using: .utf8) else {
            throw WebSocketError.dataToStringConvertingFailed
        }
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}
