//
//  GameRouter.swift
//  CoatOfArms
//
//  Created on 19/9/24.
//

import Combine

protocol GameRouterProtocol {
    func gotNextQuestion() async
}

// MARK: - GameRouterProtocolMock -

final class GameRouterProtocolMock: GameRouterProtocol {
    
   // MARK: - gotNextQuestion

    var gotNextQuestionCallsCount = 0
    var gotNextQuestionCalled: Bool {
        gotNextQuestionCallsCount > 0
    }
    var gotNextQuestionClosure: (() -> Void)?

    func gotNextQuestion() {
        gotNextQuestionCallsCount += 1
        gotNextQuestionClosure?()
    }
}
