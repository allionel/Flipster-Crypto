//
//  CancellableBagHolder.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Combine

public protocol CancellableBagHolder {
    var canellables: Set<AnyCancellable> { get }
}
