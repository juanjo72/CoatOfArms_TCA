//
//  RemainingLivesView.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture
import SwiftUI

struct RemainingLivesView: View {
    let store: StoreOf<RemainingLivesFeature>
    
    var body: some View {
        HStack {
            ForEach(0..<self.store.totalLives, id:\.self) { i in
                Circle()
                    .stroke(Color.gray)
                    .fill(i < self.store.remainingLives ? Color.gray : Color.clear)
                    .frame(
                        width: 10,
                        height: 10
                    )
                    .animation(.easeOut, value: self.store.remainingLives)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityValue("You have \(self.store.remainingLives) lives left")
        .onAppear() {
            store.send(.viewWillAppear)
        }
    }
}

#Preview {
    RemainingLivesView(
        store: Store(
            initialState: RemainingLivesFeature.State(
                id: Question.ID(
                    gameStamp: .now,
                    countryCode: "ES"
                ),
                remainingLives: 3,
                totalLives: 3
            ),
            reducer: {
                RemainingLivesFeature()
            }
        )
    )
}
