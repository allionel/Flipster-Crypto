//
//  Debugger.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

public struct Debugger {
    public enum PrintType: String {
        case info
        case warning
        case error
        
        var text: String {
            rawValue.uppercased()
        }
    }
    
    public static func print(_ arg: Any..., type: PrintType = .info) {
    #if DEBUG
        let stringLiteral = arg.reduce("") { $0 + " \($1)" }
        Swift.debugPrint("@@@ \(type.text): -->\(stringLiteral)")
    #endif
    }
}

public func tryWithError(_ arg: () throws -> Void) {
    do {
        try arg()
    } catch {
        let error = (error as? WebSocketStreamError)?.description ?? error.localizedDescription
        Debugger.print(error, type: .error)
    }
}

