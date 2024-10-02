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
                self.store.send(.userDidTap)
            },
            label: {
                Text(self.store.label)
                    .font(.title2)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(self.store.tint)
        .clipShape(Capsule())
        .onAppear() {
            self.store.send(.viewWillAppear)
        }
    }
}

#Preview {
    ChoiceButtonView(
        store: Store(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                dependencies.game = .now
                dependencies.buttonCountry = "ES"
                dependencies.questionCountry = "IT"
            }
        )
    )
    .padding()
}
