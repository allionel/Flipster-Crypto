//
//  RecentTradeViewModel.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/8/23.
//

import Combine

final class RecentTradeViewModel: ObservableObject, CancellableBagHolder {
    
    var canellables: Set<AnyCancellable> = .init()
}
