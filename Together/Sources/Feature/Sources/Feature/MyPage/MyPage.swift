//
//  MyPage.swift
//  
//
//  Created by denny on 2023/01/19.
//

import ComposableArchitecture
import TogetherCore

public struct MyPage: ReducerProtocol {
    public struct State: Equatable {
        var alert: AlertState<Action>?

        var myPageSetting: Setting.State?
        var feedRegister: OnboardingFeedRegister.State?
//        var onboarding: Onboarding.State?
        var postDetail: PostDetail.State?

        @BindingState var myPets: [PetResponse]?

        public init(
            myPageSetting: Setting.State? = nil,
            feedRegister: OnboardingFeedRegister.State? = nil,
            postDetail: PostDetail.State? = nil
        ) {
            self.myPageSetting = myPageSetting
            self.feedRegister = feedRegister
            self.postDetail = postDetail
        }
    }

    public enum Action: Equatable {
        case fetchMyPetList
        case myPetListResponse(TaskResult<MyPetResponse>)
        case alertDismissed

        case myPageSetting(Setting.Action)
        case feedRegister(OnboardingFeedRegister.Action)
        case postDetail(PostDetail.Action)
        case didTapCreate
        case didTapSetting
//        case didTapModifyInfo(Onboarding.Action)
//        case didTapAddInfo(Onboarding.Action)
        case didTapPost
    }

    public init() { }

    @Dependency(\.memberAPI.myPets) var myPetList
    private enum MyPetsCancelID { }

    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
            .ifLet(\.myPageSetting, action: /Action.myPageSetting) {
                Setting()
            }
            .ifLet(\.feedRegister, action: /Action.feedRegister) { 
                OnboardingFeedRegister()
            }
            .ifLet(\.postDetail, action: /Action.postDetail) {
                PostDetail()
            }
//            .ifLet(\.onboarding, action: /Action.didTapModifyInfo) {
//                Onboarding()
//            }
//            .ifLet(\.onboarding, action: /Action.didTapAddInfo) {
//                Onboarding()
//            }
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchMyPetList:
            state.alert = nil

            return .none
//            return .task {
//                await .myPetListResponse(
//                    TaskResult {
//                        try await myPetList()
//                    }
//                )
//            }
//            .cancellable(id: MyPetsCancelID.self)

        case let .myPetListResponse(.success(response)):
            print("My Pet List Success TotalCount: \(response.pets.count)")
            state.myPets = response.pets
            return .none

        case let .myPetListResponse(.failure(error)):
            print("My Pet List Failure error: \(error)")
            state.alert = .init(
                title: {
                    TextState("My Pet List API 실패")
                },
                actions: {
                    ButtonState(action: .alertDismissed) {
                        TextState("확인")
                    }
                }
            )
            return .none

        case .alertDismissed:
            state.alert = nil
            return .none

        case .myPageSetting(.detachChild):
            state.myPageSetting = nil
            return .none
            
        case .feedRegister(.detachChild):
            state.feedRegister = nil
            return .none
            
        case .didTapCreate:
            state.feedRegister = .init(feedRegister: .init(), navigationTitle: "게시물 등록")
            return .none
            
        case .didTapSetting:
            state.myPageSetting = .init()
            return .none

//        case .didTapModifyInfo(.detachChild):
//            state.onboarding = nil
//            return .none
//        case .didTapAddInfo(.detachChild):
//            state.onboarding = nil
//            return .none


        case .didTapPost:
            state.postDetail = .init()
            return .none
        case .postDetail(.detachChild):
            state.postDetail = nil
            return .none

        default:
            return .none
        }
    }

}
