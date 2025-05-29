//
//  MockPortfolioDataService.swift
//  CryptoSage
//
//  Created by DM on 5/28/25.
//


import Combine

final class MockPortfolioDataService: PortfolioDataService {
  @Published private var _holdings: [Holding]
  @Published private var _transactions: [Transaction] = []

  var holdingsPublisher: AnyPublisher<[Holding], Never> {
    $_holdings.eraseToAnyPublisher()
  }
  var transactionsPublisher: AnyPublisher<[Transaction], Never> {
    $_transactions.eraseToAnyPublisher()
  }

  init(initialHoldings: [Holding]) {
    self._holdings = initialHoldings
  }

  func addTransaction(_ tx: Transaction) {
    _transactions.append(tx)
    rebuildHoldingsFromTransactions()
  }
  func updateTransaction(_ old: Transaction, with new: Transaction) {
    if let idx = _transactions.firstIndex(where:{ $0.id==old.id }) {
      _transactions[idx] = new
      rebuildHoldingsFromTransactions()
    }
  }
  func deleteTransaction(_ tx: Transaction) {
    _transactions.removeAll(where:{ $0.id==tx.id })
    rebuildHoldingsFromTransactions()
  }

  private func rebuildHoldingsFromTransactions() {
    // Exactly your existing recalcHoldingsFromAllTransactions logic:
    // apply each tx to build holdings
    var newHoldings: [Holding] = []
    // … fill newHoldings …
    _holdings = newHoldings
  }
}