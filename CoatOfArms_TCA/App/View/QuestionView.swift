//
//  QuestionView.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import ComposableArchitecture
import Kingfisher
import SwiftUI

enum ImageSource: Equatable {
    case url(URL)
    case image(Image)
}

@ViewAction(for: QuestionFeature.self)
struct QuestionView: View {
    let store: StoreOf<QuestionFeature>
    
    var body: some View {
        VStack(
            spacing: 20
        ) {
            Spacer()
            
            if let imageSource = store.imageSource {
                Group {
                    switch imageSource {
                    case .image(let image):
                        image
                            .resizable()
                    case .url(let url):
                        KFImage(url)
                            .resizable()
                    }
                }
                .allowsHitTesting(false)
                .aspectRatio(contentMode: .fit)
                .padding()
            }
            
            VStack {
                ForEach(
                    store.scope(state: \.buttons, action: \.buttons)
                ) { childStore in
                    ChoiceButtonView(store: childStore)
                }
            }
            .layoutPriority(1)
        }
        .onAppear() {
            send(.onAppear)
        }
    }
}

#Preview {
    QuestionView(
        store: Store(
            initialState: QuestionFeature.State(
                id: Question.ID(
                    gameStamp: .now,
                    countryCode: "ES"
                )
            ),
            reducer: {
                QuestionFeature()
            }
        )
    )
    .padding()
}
