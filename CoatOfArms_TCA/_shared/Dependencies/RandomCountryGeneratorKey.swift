//
//  RandomCountryGeneratorKEy.swift
//  CoatOfArms_TCA
//
//  Created on 3/10/24.
//

import Combine
import ComposableArchitecture

private enum RandomCountryGeneratorKey: DependencyKey {
    static var liveValue: any RandomCountryCodeProviderProtocol {
        RandomCountryCodeProvider()
    }
    
    static var testValue: any RandomCountryCodeProviderProtocol {
        RandomCountryCodeProviderProtocolMock()
    }
}

extension DependencyValues {
    var randomCountryGenerator: any RandomCountryCodeProviderProtocol {
        get { self[RandomCountryGeneratorKey.self] }
        set { self[RandomCountryGeneratorKey.self] = newValue }
    }
}
