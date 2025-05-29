//
//  PriceService.swift
//  CryptoSage
//
//  Created by DM on 5/28/25.
//


import Combine
import Foundation

/// Emits a map of symbol → latest price on a timer.
protocol PriceService {
  func pricePublisher(for symbols: [String], interval: TimeInterval)
    -> AnyPublisher<[String: Double], Never>
}

/// Stub implementation—emits an empty map. Swap in CoinGecko or WebSocket logic.
final class CoinGeckoPriceService: PriceService {
  func pricePublisher(
    for symbols: [String],
    interval: TimeInterval
  ) -> AnyPublisher<[String: Double], Never> {
    Timer
      .publish(every: interval, on: .main, in: .common)
      .autoconnect()
      .map { _ in [:] }
      .eraseToAnyPublisher()
  }
}