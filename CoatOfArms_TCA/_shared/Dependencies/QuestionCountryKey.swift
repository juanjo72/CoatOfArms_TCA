//
//  QuestionCountryKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture

private enum QuestionCountryKey: DependencyKey {
    static var liveValue: CountryCode {
        "ES"
    }
}

extension DependencyValues {
    var questionCountry: CountryCode {
        get { self[QuestionCountryKey.self] }
        set { self[QuestionCountryKey.self] = newValue }
    }
}
