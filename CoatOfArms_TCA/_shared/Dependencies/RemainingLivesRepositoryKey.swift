//
//  RemainingLivesRepositoryKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//


import Combine
import ComposableArchitecture

private enum RemainingLivesRepositoryKey: DependencyKey {
    static var liveValue: any RemainingLivesRepositoryProtocol {
        @Dependency(\.game) var game
        @Dependency(\.sourceOfTruth) var sourceOfTruth
        
        let repository = RemainingLivesRepository(
            gameStamp: game,
            store: sourceOfTruth
        )
        
        return repository
    }
    
    static var testValue: any RemainingLivesRepositoryProtocol {
        let mock = RemainingLivesRepositoryProtocolMock()
        mock.wrongAnswers = Just([]).eraseToAnyPublisher()
        return mock
    }
    
    static var previewValue: any RemainingLivesRepositoryProtocol {
        let mock = RemainingLivesRepositoryProtocolMock()
        mock.wrongAnswers = Just(
            [
                UserChoice(
                    id: Question.ID(
                        gameStamp: .now,
                        countryCode: "ES"
                    ),
                    pickedCountryCode: "IT"
                )
            ]
        ).eraseToAnyPublisher()
        return mock
    }
}

extension DependencyValues {
    var remainingLivesRepository: any RemainingLivesRepositoryProtocol {
        get { self[RemainingLivesRepositoryKey.self] }
        set { self[RemainingLivesRepositoryKey.self] = newValue }
    }
}
