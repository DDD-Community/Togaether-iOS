//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import Foundation
import TogetherCore
import ComposableArchitecture

public struct OnboardingSpecies: ReducerProtocol {
    public struct State: Equatable {
        let petName: String
        var selectedSpecies: String?
        var allSpecies: [SpeciesSection] = .init()
    }
    
    public enum Action: Equatable {
        case viewDidLoad
        case didTapSpecies(IndexPath)
        case didTapSkipButton
        case didTapNextButton
        case detachChild
    }
    
    public init() { }
    
    public var body: some ReducerProtocolOf<Self> {
        Reduce(core)
    }
    
    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewDidLoad:
            let groupedDictionary = Dictionary(
                grouping: mockData, 
                by: { name in 
                    let firstAlpabet = String(name.prefix(1).decomposedStringWithCompatibilityMapping.unicodeScalars.prefix(1))
                    return firstAlpabet
                }
            )
            let groupKeys = groupedDictionary.keys.sorted()
            let allSpecies = groupKeys.map { 
                return SpeciesSection(
                    id: $0, 
                    names: groupedDictionary[$0]?.sorted() ?? .init()
                ) 
            }
            state.allSpecies = allSpecies
            return .none
            
        case let .didTapSpecies(index):
            guard let selectedSection = state.allSpecies[safe: index.section],
                  let selectedSpecies = selectedSection.names[safe: index.row]
            else { return .none }
            state.selectedSpecies = selectedSpecies
            return .none
            
        case .didTapSkipButton, .didTapNextButton, .detachChild:
            return .none
        }
    }
    
}

let mockData = ["고든 세터",
"꼬똥 드 툴레아",
"골든두들",
"골든 리트리버",
"그레이트 데인",
"그레이트 스위스 마운틴 도그",
"그레이트 피레니즈",
"그레이하운드",
"그린란드견",
"글렌 오브 이말 테리어",
"기슈견",
"나폴리탄 마스티프",
"노르웨지안 부훈트",
"노르웨이 엘크 하운드",
"노리치 테리어",
"노바 스코셔 덕 톨링 레트리버",
"노퍽 테리어",
"뉴펀들랜드",
"닥스훈트",
"달마시안",
"댄디 딘몬트 테리어",
"도고 까나리오",
"도고 아르헨티노",
"도그 드 보르도",
"도베르만 핀셔",
"도사견",
"동경이",
"라고토 로마뇰로",
"라사압소",
"라페이로 도 알렌테조",
"라포니안 허더",
"래브라도 리트리버",
"레온베르거",
"레이크랜드 테리어",
"로디지아 리지백",
"로첸",
"로트와일러",
"마스티프",
"맨체스터 테리어",
"말티즈",
"미니어처 불 테리어",
"미니어처 슈나우저",
"미니어처 핀셔",
"말티푸",
"바센지",
"바셋 하운드",
"버니즈 마운틴 도그",
"베들링턴 테리어",
"발바리",
"벨기에 말리노이즈",
"벨기에 테뷰런",
"벨지안 그리펀",
"벨지언 쉽독 (벨지언 셰퍼드)",
"보더콜리",
"보더 테리어",
"보르도 마스티프",
"보르조이",
"보비에 드 플랜더스",
"보스롱",
"보스턴 테리어",
"복서",
"볼로네즈",
"불개",
"불도그",
"불리 쿠타",
"불 마스티프",
"불 테리어",
"브뤼셀 그리펀",
"브리어드",
"브리타니",
"블랙 러시안 테리어",
"블랙 앤드 탄 쿤하운드",
"블러드 하운드",
"비글",
"비숑 프리제",
"비어디드 콜리",
"비즐라",
"빠삐용",
"사모예드",
"사플라니낙",
"살루키",
"삽살개",
"샤페이",
"서식스 스패니얼",
"세인트 버나드",
"셰틀랜드 쉽독",
"소프트 코티드 휘튼 테리어",
"솔로이츠 쿠인틀레",
"스무드 폭스 테리어",
"스웨디쉬 발훈트",
"스카이 테리어",
"스코티시 디어하운드",
"스코티시 테리어",
"스키퍼키",
"스태퍼드셔 불 테리어",
"스탠더드 슈나우저",
"스패니쉬 그레이 하운드",
"스패니쉬 마스티프",
"스피노네 이탈리아노",
"스피츠",
"시고르자브종",
"시바 이누",
"시베리언 허스키",
"시추",
"시코쿠견",
"실리엄 테리어",
"실키 테리어",
"아나톨리아 셰퍼드",
"아메리칸 불도그",
"아메리칸 불리",
"아메리칸 스태퍼드셔 테리어",
"아메리칸 아키다",
"아메리칸 에스키모 도그",
"아메리칸 워터 스패니얼",
"아메리칸 코커 스패니얼",
"아메리칸 폭스하운드",
"아이디",
"아이리시 소프트코티드 휘튼 테리어",
"아이리시 레드 앤드 화이트 세터",
"아이리시 세터",
"아이리시 울프 하운드",
"아이리시 워터 스패니얼",
"아이리시 테리어",
"아키타",
"아펜핀셔",
"아프간 하운드",
"알래스칸 맬러뮤트",
"알래스칸 클리카이",
"에스트렐라 마운틴 독",
"에어데일 테리어",
"오브차카",
"오스트레일리안 실키 테리어",
"오스트레일리안 켈피",
"오스트레일리언 셰퍼드",
"오스트레일리언 캐틀 도그",
"오스트레일리언 테리어",
"오터 하운드",
"올드 잉글리시 쉽독",
"와이머라너",
"와이어 폭스 테리어",
"와이어헤어드 포인팅 그리펀",
"야쿠탄 라이카",
"요크셔 테리어",
"웨스트 하이랜드 화이트테리어",
"웰시 스프링어 스패니얼",
"웰시 코기",
"웰시 테리어",
"이비전 하운드",
"이탤리언 그레이하운드",
"잉글리시 세터",
"잉글리시 스프링어 스패니얼",
"잉글리시 코커 스패니얼",
"잉글리시 토이 스패니얼",
"잉글리시 폭스하운드",
"자이언트 슈나우저",
"재패니즈 친",
"재패니즈 스피츠",
"잭 러셀 테리어",
"저먼 셰퍼드",
"저먼 쇼트헤어드 포인터",
"저먼 와이어헤어드 포인터",
"저먼 핀셔",
"저먼 헌팅 테리어",
"제주개",
"진돗개",
"차우차우",
"차이니즈 샤페이",
"차이니즈 크레스티드",
"체서피크 베이 레트리버",
"체코슬로바키아 늑대개",
"치와와",
"카네 코르소",
"카디건 웰시 코기",
"카발리에 킹 찰스 스파니엘",
"캉갈",
"컬리코티드 레트리버",
"케리 블루 테리어",
"케언 테리어",
"케이넌 도그",
"케이스혼트",
"코리안 마스티프",
"코몬도르",
"코커 스패니얼",
"콜리",
"쿠바스",
"쿠이커혼제",
"클럼버 스패니얼",
"토이 폭스 테리어",
"티베탄 마스티프",
"티베탄 스패니얼",
"티베탄 테리어",
"파라오 하운드",
"파슨 러셀 테리어",
"파피용",
"패터데일 테리어",
"퍼그",
"페키니즈",
"펨브록 웰시 코기",
"포르투기즈 워터 도그",
"포메라니안",
"포인터",
"폭스 테리어",
"폴리시 롤런드 시프도그",
"폼피츠",
"푸들",
"푸미",
"풀리",
"풍산개",
"프렌치 불도그",
"프티 바세 그리퐁 방댕",
"플랫코티드 레트리버",
"플롯 하운드",
"피니시 스피츠",
"피레니안 마스티프",
"피레니안 쉽독",
"피레니언 셰퍼드",
"필드 스패니얼",
"필라 브라질레이로",
"핏 불 테리어",
"해리어",
"하바니즈",
"홋카이도 이누",
"휘핏"]
