//
//  CoatOfArms_TCAApp.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct CoatOfArms_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            QuestionView(
                store: Store(
                    initialState: QuestionFeature.State(
                        id: Question.ID(
                            gameStamp: Date(timeIntervalSince1970: 0),
                            countryCode: "ES"
                        )
                    ),
                    reducer: {
                        QuestionFeature()
                    }
                )
            )
            .padding()
            
            RemainingLivesView(
                store: Store(
                    initialState: RemainingLivesFeature.State(
                        id: Question.ID(
                            gameStamp: Date(timeIntervalSince1970: 0),
                            countryCode: "ES"
                        )
                    ),
                    reducer: { RemainingLivesFeature() }
                )
            )
        }
    }
}
