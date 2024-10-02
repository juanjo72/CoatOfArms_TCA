//
//  ChoiceButtonFeatureTest.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

@testable import CoatOfArms_TCA
import ComposableArchitecture
import Testing

@Suite("ChoiceButtonFeature")
struct ChoiceButtonFeatureTest {
    @Test("Button label")
    @MainActor
    func testThat_WhenViewWillAppear_ThenLabelIsCreatedWithUseCase() async throws {
        // Given
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                let getCountryName = GetCountryNameProtocolMock()
                getCountryName.callAsFunctionForReturnValue = "Spain"
                dependencies.getCountryName = getCountryName
            }
        )
        store.exhaustivity = .off
        
        // When
        // Then
        await store.send(.viewWillAppear) { state in
            state.label = "Spain"
        }
    }
    
    @Test(
        "Button color",
        arguments: [
            nil,
            UserChoice.make(countryCode: "ES", pickedCountryCode: "IT"),
            UserChoice.make(countryCode: "IT", pickedCountryCode: "IT"),
        ]
    )
    func testThat_WhenCreated_ThenTintIsApplied(userChoice: UserChoice?) async throws {
        // Given
        let store = await TestStore(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                let getCountryName = GetCountryNameProtocolMock()
                getCountryName.callAsFunctionForReturnValue = "Spain"
                dependencies.getCountryName = getCountryName
            }
        )
        
        // When
        // Then
        await store.send(.updateCurrentChoice(userChoice)) { state in
            state.tint = userChoice.resultColor
        }
    }
    
    @Test("Setting answer")
    @MainActor
    func testThat_WhenUserDidTap_ThenAnswerIsSet() async throws {
        // Given
        let choice = UserChoice.make(countryCode: "ES", pickedCountryCode: "IT")
        let repo = ChoiceButtonRepositoryProtocolMock()
        repo.markAsChoiceReturnValue = choice
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                dependencies.choiceButtonRepository = repo
            }
        )
        store.exhaustivity = .off
        
        // When
        await store.send(.userDidTap)
        
        // Then
        #expect(repo.markAsChoiceCallsCount == 1)
    }
    
    @Test("Playing sound: correct")
    @MainActor
    func testThat_WhenUserDidTap_ThenCorrectFXSoundIsPlayed() async throws {
        // Given
        let choice = UserChoice.make(countryCode: "ES", pickedCountryCode: "ES")
        let playSound = PlaySoundProtocolMock()
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                dependencies.playSound = playSound
                let repo = ChoiceButtonRepositoryProtocolMock()
                repo.markAsChoiceReturnValue = choice
                dependencies.choiceButtonRepository = repo
            }
        )
        store.exhaustivity = .off
        
        // When
        await store.send(.userDidTap)
        
        // Then
        #expect(playSound.callAsFunctionSoundReceivedSound == .rightAnswer)
    }
    
    @Test("Playing sound: incorrect")
    @MainActor
    func testThat_WhenUserDidTap_ThenIncorrectFXSoundIsPlayed() async throws {
        // Given
        let choice = UserChoice.make(countryCode: "IT", pickedCountryCode: "ES")
        let playSound = PlaySoundProtocolMock()
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                dependencies.playSound = playSound
                let repo = ChoiceButtonRepositoryProtocolMock()
                repo.markAsChoiceReturnValue = choice
                dependencies.choiceButtonRepository = repo
            }
        )
        store.exhaustivity = .off
        
        // When
        await store.send(.userDidTap)
        
        // Then
        #expect(playSound.callAsFunctionSoundReceivedSound == .wrongAnswer)
    }
    
    @Test("Go to next question")
    @MainActor
    func testThat_WhenUserDidTap_ThenDelayIsApplied() async throws {
        // Given
        let router = GameRouterProtocolMock()
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { dependencies in
                dependencies.gameRouter = router
            }
        )
        store.exhaustivity = .off
        
        // When
        await store.send(.userDidTap)
        
        // Then
        #expect(router.gotNextQuestionCallsCount == 1)
    }
}
