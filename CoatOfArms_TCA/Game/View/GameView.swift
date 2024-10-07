//
//  GameView.swift
//  CoatOfArms_TCA
//
//  Created on 6/10/24.
//

import ComposableArchitecture
import SwiftUI

struct GameView: View {
    let store: StoreOf<GameFeature>
    
    var body: some View {
        VStack(
            spacing: 30
        ) {
            if let childStore = store.scope(state: \.question, action: \.question) {
                QuestionView(store: childStore)
                    .id(childStore.state.id)
            }
            
            if let childStore = store.scope(state: \.remainingLives, action: \.remainingLives) {
                RemainingLivesView(store: childStore)
                    .id(childStore.state.id)
            }
        }
        .padding()
        .onAppear {
            store.send(.viewWillAppear)
        }
    }
}
