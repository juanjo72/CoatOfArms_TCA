//
//  ChoiceButtonRepositoryKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import Combine
import ComposableArchitecture

private enum ChoiceButtonRepositoryKey: DependencyKey {
    static var liveValue: any ChoiceButtonRepositoryProtocol {
        @Dependency(\.buttonCountry) var buttonCountry
        @Dependency(\.game) var game
        @Dependency(\.questionCountry) var questionCountry
        @Dependency(\.sourceOfTruth) var sourceOfTruth
        
        let repository = ChoiceButtonRepository(
            buttonCode: buttonCountry,
            questionId: Question.ID(
                gameStamp: game,
                countryCode: questionCountry
            ),
            store: sourceOfTruth
        )
        
        return repository
    }
    
    static var testValue: any ChoiceButtonRepositoryProtocol {
        let mock = ChoiceButtonRepositoryProtocolMock()
        mock.userChoiceObservable = Just<UserChoice?>(nil).eraseToAnyPublisher()
        mock.markAsChoiceReturnValue = UserChoice(
            id: Question.ID(gameStamp: .now, countryCode: "E"),
            pickedCountryCode: "ES"
        )
        return mock
    }
}

extension DependencyValues {
    var choiceButtonRepository: ChoiceButtonRepositoryProtocol {
        get { self[ChoiceButtonRepositoryKey.self] }
        set { self[ChoiceButtonRepositoryKey.self] = newValue }
    }
}
