//
//  ChoiceButtonRepository.swift
//  CoatOfArms
//
//  Created on 21/9/24.
//

import Combine

protocol ChoiceButtonRepositoryProtocol {
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> { get }
    func markAsChoice() async -> UserChoice
}

struct ChoiceButtonRepository: ChoiceButtonRepositoryProtocol {
    
    // MARK: Injected
    
    private let buttonCode: CountryCode
    private let questionId: Question.ID
    private let store: any StorageProtocol
    
    // MARK: ChoiceButtonRepositoryProtocol
    
    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        self.store.getSingleElementObservable(
            of: UserChoice.self,
            id: self.questionId
        )
        .filter { choice in
            guard let choice else { return true }
            return choice.pickedCountryCode == self.buttonCode
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: Lifecycle
    
    init(
        buttonCode: CountryCode,
        questionId: Question.ID,
        store: any StorageProtocol
    ) {
        self.buttonCode = buttonCode
        self.questionId = questionId
        self.store = store
    }
    
    // MARK: ChoiceButtonRepositoryProtocol
    
    func markAsChoice() async -> UserChoice {
        let answer = UserChoice(
            id: self.questionId,
            pickedCountryCode: self.buttonCode
        )
        await self.store.add(answer)
        return answer
    }
}

// MARK: - ChoiceButtonRepositoryProtocolMock -

final class ChoiceButtonRepositoryProtocolMock: ChoiceButtonRepositoryProtocol {
    
   // MARK: - userChoiceObservable

    var userChoiceObservable: AnyPublisher<UserChoice?, Never> {
        get { underlyingUserChoiceObservable }
        set(value) { underlyingUserChoiceObservable = value }
    }
    private var underlyingUserChoiceObservable: AnyPublisher<UserChoice?, Never>!
    
   // MARK: - markAsChoice

    var markAsChoiceCallsCount = 0
    var markAsChoiceCalled: Bool {
        markAsChoiceCallsCount > 0
    }
    var markAsChoiceReturnValue: UserChoice!
    var markAsChoiceClosure: (() -> UserChoice)?

    func markAsChoice() -> UserChoice {
        markAsChoiceCallsCount += 1
        return markAsChoiceClosure.map({ $0() }) ?? markAsChoiceReturnValue
    }
}
