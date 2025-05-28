//
//  AIInsightView.swift
//  CryptoSage
//
//  Created by DM on 5/28/25.
//

import SwiftUI

struct AIInsightView: View {
    @StateObject private var vm = AIInsightViewModel()
    @EnvironmentObject var portfolioVM: PortfolioViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.headline)
                    .foregroundColor(.yellow)
                Text("AI Insight")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button {
                    Task { await vm.refresh(using: portfolioVM.portfolio) }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 24, height: 24)
                            .padding(8)
                            .background(Circle().fill(Color(uiColor: .secondarySystemBackground)))
                    } else {
                        Image(systemName: vm.remainingRefreshes > 0 ? "arrow.clockwise" : "lock")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color(uiColor: .secondarySystemBackground)))
                    }
                }
                .disabled(vm.isLoading || vm.remainingRefreshes == 0)
                .help(vm.remainingRefreshes > 0 ?
                      "\(vm.remainingRefreshes) refreshes left today" :
                      "Upgrade for unlimited insights")
            }

            Divider()
                .background(Color.white.opacity(0.3))

            if let text = vm.insight?.text {
                Text(text)
                    .font(.body)
            } else {
                Text("Tap 🔄 to generate your first insight...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if let timestamp = vm.insight?.timestamp {
                Text("Updated \(timestamp, style: .time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onAppear {
            if vm.insight == nil {
                Task { await vm.refresh(using: portfolioVM.portfolio) }
            }
        }
    }
}
