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
            ChoiceButtonView(
                store: Store(
                    initialState: ChoiceButtonFeature.State(),
                    reducer: {
                        ChoiceButtonFeature()
                    },
                    withDependencies: { dependencies in
                        //
                    }
                )
            )
            .padding()
        }
    }
}
