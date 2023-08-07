//
//  Singleton.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation

public protocol Singleton {
    static var shared: Self { get }
}
