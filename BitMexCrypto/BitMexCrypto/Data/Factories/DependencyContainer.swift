//
//  DependencyContainer.swift
//  BitMexCrypto
//
//  Created by Alireza Sotoudeh on 8/7/23.
//

import Foundation

final public class DependencyContainer: Singleton {
    public static var shared: DependencyContainer = .init()
    private init() {}

    private(set) lazy var repositories = RepositoryDependencyContainer()
    private(set) lazy var useCases = UseCaseDependencyContainer(repositories: repositories)
}
