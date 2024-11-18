//
//  Question+make.swift
//  CoatOfArms
//
//  Created on 22/9/24.
//

@testable import CoatOfArms_TCA
import Foundation

extension Question {
    static func make(
        gameStamp: GameStamp = Date(timeIntervalSince1970: 0),
        countryCode: CountryCode = "ES",
        coatOfArms: ImageSource = .url(URL(string: "https://mainfacts.com/media/images/coats_of_arms/es.png")!),
        otherChoices: [CountryCode] = ["IT", "AR", "US"],
        rightChoicePosition: Int = 0
    ) -> Self {
        Question(
            id: Question.ID(gameStamp: .init(timeIntervalSince1970: 0), countryCode: "ES"),
            coatOfArms: coatOfArms,
            otherChoices: otherChoices,
            rightChoicePosition: rightChoicePosition
        )
    }
}

extension Question.ID {
    static func make(
        gameStamp: GameStamp = Date(timeIntervalSince1970: 0),
        countryCode: CountryCode = "ES"
    ) -> Self {
        Question.ID(
            gameStamp: gameStamp,
            countryCode: countryCode
        )
    }
}
