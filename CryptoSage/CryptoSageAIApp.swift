import SwiftUI
import UIKit
import Combine

@main
struct CryptoSageAIApp: App {
    @StateObject private var appState: AppState
    @StateObject private var marketVM: MarketViewModel
    @StateObject private var portfolioVM: PortfolioViewModel
    @StateObject private var newsVM: CryptoNewsFeedViewModel
    @StateObject private var segmentVM: MarketSegmentViewModel
    @StateObject private var dataModeManager: DataModeManager

    init() {
        let appState = AppState()
        let marketVM = MarketViewModel.shared
        let dm = DataModeManager()
        _appState = StateObject(wrappedValue: appState)
        _marketVM = StateObject(wrappedValue: marketVM)
        _dataModeManager = StateObject(wrappedValue: dm)
        // Demo: seed mock transaction history
        let mockTransactions: [Transaction] = [
            Transaction(
                id: UUID(),
                coinSymbol: "BTC",
                quantity: 10,
                pricePerUnit: 50_000,
                date: Calendar.current.date(byAdding: .month, value: -12, to: Date())!,
                isBuy: true
            ),
            Transaction(
                id: UUID(),
                coinSymbol: "ETH",
                quantity: 200,
                pricePerUnit: 2_000,
                date: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
                isBuy: true
            ),
            Transaction(
                id: UUID(),
                coinSymbol: "SOL",
                quantity: 5_000,
                pricePerUnit: 100,
                date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
                isBuy: true
            ),
            Transaction(
                id: UUID(),
                coinSymbol: "XRP",
                quantity: 1_000_000,
                pricePerUnit: 0.5,
                date: Calendar.current.date(byAdding: .month, value: -18, to: Date())!,
                isBuy: true
            )
        ]
        // Initialize PortfolioViewModel with mock or live data service based on dataModeManager.mode
        let portfolioService: PortfolioDataService = {
            switch dm.mode {
            case .live:
                return LivePortfolioDataService()
            case .mock:
                return MockPortfolioDataService(initialHoldings: [], initialTransactions: mockTransactions)
            }
        }()
        let priceService = CoinGeckoPriceService()
        _portfolioVM = StateObject(wrappedValue:
            PortfolioViewModel(service: portfolioService,
                               priceService: priceService)
        )
        _newsVM = StateObject(wrappedValue: CryptoNewsFeedViewModel())
        _segmentVM = StateObject(wrappedValue: MarketSegmentViewModel())
        // Global navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .white
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    Group {
                        switch appState.selectedTab {
                        case .home:
                            HomeView()
                        case .market:
                            MarketView()
                        case .trade:
                            TradeView()
                        case .portfolio:
                            PortfolioView()
                        case .ai:
                            AITabView()
                        }
                    }

                    VStack {
                        Spacer()
                        CustomTabBar(selectedTab: $appState.selectedTab)
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(marketVM)
            .environmentObject(portfolioVM)
            .environmentObject(newsVM)
            .environmentObject(segmentVM)
            .environmentObject(dataModeManager)
            .preferredColorScheme(appState.isDarkMode ? .dark : .light)
        }
    }
}

class AppState: ObservableObject {
    @Published var selectedTab: CustomTab = .home
    @Published var isDarkMode: Bool = true
}
