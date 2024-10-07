//
//  ChoiceButtonView.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import ComposableArchitecture
import SwiftUI

struct ChoiceButtonView: View {
    let store: StoreOf<ChoiceButtonFeature>
    
    var body: some View {
        Button(
            action: {
                store.send(.userDidTap)
            },
            label: {
                Text(store.label)
                    .font(.title2)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(store.tint)
        .clipShape(Capsule())
        .onAppear() {
            store.send(.viewWillAppear)
        }
    }
}

#Preview {
    ChoiceButtonView(
        store: Store(
            initialState: ChoiceButtonFeature.State(
                id: "ES",
                questionId: Question.ID(
                    gameStamp: .now,
                    countryCode: "ES"
                )
            ),
            reducer: {
                ChoiceButtonFeature()
            }
        )
    )
    .padding()
}
