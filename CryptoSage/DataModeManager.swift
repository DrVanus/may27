//
//  DataMode.swift
//  CryptoSage
//
//  Created by DM on 5/28/25.
//


import SwiftUI
import Combine

/// Switch between .live and .mock at runtime (stored in UserDefaults)
enum DataMode: String {
  case live, mock
}

/// Observable manager for the current data mode
final class DataModeManager: ObservableObject {
  @AppStorage("dataMode") private var storedModeRaw: String = DataMode.live.rawValue
  @Published var mode: DataMode = .live {
    didSet { storedModeRaw = mode.rawValue }
  }

  init() {
    // Read saved raw value and set mode once
    mode = DataMode(rawValue: storedModeRaw) ?? .live
  }
}
