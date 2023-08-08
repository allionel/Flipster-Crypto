//
//  Configuration.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/5/23.
//

import Foundation
import class UIKit.UIDevice

public final class Configuration: CustomStringConvertible {
    private init() { }
    public static let shared: Configuration = .init()
    
    public enum Environment {
        case debug
        case release
        
        static var current: Configuration.Environment {
            #if DEBUG
            return .debug
            #elseif RELEASE
            return .release
            #else
            return .debug
            #endif
        }
    }
    
    private let infoPlist: [String: Any] = {
        return Bundle.main.infoDictionary ?? [:]
    }()
    
    private let parameters: [String: String] = {
        return Bundle.main.infoDictionary?["Configuration"] as? [String: String] ?? [:]
    }()
    
    public var description: String {
        String(describing: parameters)
    }
    
    public var state: Configuration.Environment {
        return .current
    }

    public var appVersion: String {
        return infoPlist["CFBundleShortVersionString"] as? String ?? ""
    }

    public var appBuildNumber: String {
        return infoPlist["CFBundleVersion"] as? String ?? ""
    }

    public var osVersion: String {
        return UIDevice.current.systemVersion
    }

    public var appName: String {
        return parameters["APP_NAME"]!
    }

    public var bundleID: String {
        return parameters["APP_BUNDLE_ID"]!
    }

    public var appIcon: String {
        return parameters["APP_ICON"]!
    }

    public var baseURL: String {
        return parameters["BASE_URL"]!
    }
}
