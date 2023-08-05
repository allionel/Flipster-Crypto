//
//  String+Extension.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation

extension String {
    public var titleCase: String {
        unicodeScalars.reduce("") {
            guard CharacterSet.uppercaseLetters.contains($1),
                  $0.count > .zero
            else { return ($0 + String($1)).lowercased() }
            return ($0 + " " + String($1)).lowercased()
        }
    }
}
