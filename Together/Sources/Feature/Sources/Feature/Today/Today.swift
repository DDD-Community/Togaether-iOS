//
//  Today.swift
//  
//
//  Created by denny on 2023/01/18.
//

import ComposableArchitecture
import TogetherCore

public struct Today: ReducerProtocol {
    public struct State: Equatable {
        var pageSize: Int = 10
        var currentPage: Int = 1
        var petOrderBy: String = "FOLLOWER_COUNT_DESC"

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
                            currentPage = state.currentPage,
                            petOrderBy = state.petOrderBy] in
                await .petListResponse(
                    TaskResult {
                        try await petList(pageSize, currentPage, petOrderBy)
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
                    TextState("Today Pet List API 실패")
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
