//
//  ButtonCountryKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture

private enum ButtonCountryKey: DependencyKey {
    static var liveValue: CountryCode {
        "ES"
    }
    
    static var testValue: String {
        "ES"
    }
}

extension DependencyValues {
    var buttonCountry: CountryCode {
        get { self[ButtonCountryKey.self] }
        set { self[ButtonCountryKey.self] = newValue }
    }
}
