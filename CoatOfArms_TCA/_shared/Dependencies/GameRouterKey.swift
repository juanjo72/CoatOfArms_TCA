//
//  GameRouterKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture

private enum GameRouterKey: DependencyKey {
    static var liveValue: any GameRouterProtocol {
        GameRouterProtocolMock()
    }
    
    static var testValue: any GameRouterProtocol {
        GameRouterProtocolMock()
    }
}

extension DependencyValues {
    var gameRouter: any GameRouterProtocol {
        get { self[GameRouterKey.self] }
        set { self[GameRouterKey.self] = newValue }
    }
}
