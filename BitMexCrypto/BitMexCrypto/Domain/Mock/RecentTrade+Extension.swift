//
//  RecentTrade+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

extension RecentTrade {
    struct Mock {
        static var listOfAll: RecentTrade {
            guard let url = Bundle.main.url(forResource: "RecentTrades", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else { return .empty }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                return try decoder.decode(RecentTrade.self, from: data)
            } catch {
                Debugger.print("Decoding fialed")
            }
            return .empty
        }
        
        static var buyList: RecentTrade {
            .init(table: listOfAll.table,
                  action: listOfAll.action,
                  data: listOfAll.data.filter(\.side.isBuy))
        }
        
        static var sellList: RecentTrade {
            .init(table: listOfAll.table,
                  action: listOfAll.action,
                  data: listOfAll.data.filter(\.side.isSell))
        }
    }
}

extension RecentTrade {
    static var empty: Self = .init(table: nil, action: nil, data: [])
}
