//
//  Home.swift
//  
//

import ComposableArchitecture
import TogetherCore

public struct Home: ReducerProtocol {
    public struct State: Equatable {
        var pageSize: Int = 10
        var currentPage: Int = 1

        @BindingState var petList: [PetResponse]?

        var alert: AlertState<Action>?

        public init() { }
    }
    
    public enum Action: Equatable {
        case fetchPetList
        case petListResponse(TaskResult<PetListResponse>)
        case alertDismissed
    }
    
    public init() { }

    @Dependency(\.petAPI.list) var petList
    private enum PetListCancelID { }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchPetList:
            state.alert = nil

            return .task { [pageSize = state.pageSize,
                            currentPage = state.currentPage] in
                await .petListResponse(
                    TaskResult {
                        try await petList(pageSize, currentPage, nil)
                    }
                )
            }
            .cancellable(id: PetListCancelID.self)

        case let .petListResponse(.success(response)):
            state.currentPage = response.currentPage
            state.pageSize = response.totalPages
            state.petList = response.petList
            return .none

        case let .petListResponse(.failure(error)):
            print("Pet List Failure error: \(error)")
            state.alert = .init(
                title: {
                    TextState("Pet List API 실패")
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
        }
    }
    
}

