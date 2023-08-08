//
//  OrderBookListData.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Foundation

struct OrderBookListData {
    let buyList: OrderBookListType
    let sellList: OrderBookListType
}

enum OrderBookListType {
    case buy(total: Int, data: [OrderBookItem])
    case sell(total: Int, data: [OrderBookItem])
}

extension OrderBookListType {
    var data: [OrderBookItem] {
        switch self {
        case .buy(_, let data):
            return data
        case .sell(_, let data):
            return data
        }
    }
    
    var totalSize: Int {
        switch self {
        case .buy(let total, _):
            return total
        case .sell(let total, _):
            return total
        }
    }
}

extension OrderBookListType {
    var isBuy: Bool {
        guard case .buy = self else {
            return false
        }
        return true
    }
}
