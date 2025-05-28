//
//  AIInsightViewModel.swift
//  CryptoSage
//
//  Created by DM on 5/28/25.
//


import Foundation
import Combine

/// ViewModel for managing the AI Insight section
final class AIInsightViewModel: ObservableObject {
    @Published var insight: AIInsight?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var remainingRefreshes: Int

    private let maxFreeRefreshes = 3
    private let refreshKey = "AIInsightUsesToday"
    private var usesToday: Int {
        get {
            UserDefaults.standard.integer(forKey: refreshKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: refreshKey)
        }
    }

    init() {
        let defaults = UserDefaults.standard
        let dateKey = refreshKey + "_date"

        // Read last reset date and stored uses count
        let lastDate = defaults.object(forKey: dateKey) as? Date
        var storedUses = defaults.integer(forKey: refreshKey)

        // Reset daily counter if the date has changed
        if let lastDate = lastDate, !Calendar.current.isDateInToday(lastDate) {
            storedUses = 0
            defaults.set(0, forKey: refreshKey)
        }

        // Store today's date for future resets
        defaults.set(Date(), forKey: dateKey)

        // Initialize remaining refreshes based on storedUses
        self.remainingRefreshes = max(maxFreeRefreshes - storedUses, 0)
    }

    /// Refreshes the AI insight, enforcing free-tier limits
    /// - Parameter portfolio: An Encodable model of the user's portfolio
    @MainActor
    func refresh<T: Encodable>(using portfolio: T) async {
        // Enforce free tier limits
        guard remainingRefreshes > 0 else {
            errorMessage = "Free insight limit reached. Upgrade for unlimited use."
            return
        }

        isLoading = true
        errorMessage = nil
        do {
            let newInsight = try await AIInsightService.shared.fetchInsight(for: portfolio)
            insight = newInsight
            // Update usage count
            usesToday += 1
            remainingRefreshes = maxFreeRefreshes - usesToday
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
