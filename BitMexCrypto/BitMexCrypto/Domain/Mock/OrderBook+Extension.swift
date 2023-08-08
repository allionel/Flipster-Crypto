//
//  OrderBook+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

extension OrderBook {
    struct Mock {
        static var list: OrderBook {
            guard let url = Bundle.main.url(forResource: "OrderBooks", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else { return .empty }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                return try decoder.decode(OrderBook.self, from: data)
            } catch {
                Debugger.print("Decoding fialed")
            }
            return .empty
        }
    }
}

extension OrderBook {
    static var empty: Self = .init(table: nil, action: nil, data: [])
}
