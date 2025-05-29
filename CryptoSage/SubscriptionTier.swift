import SwiftUI

/// Describes a subscription tier and its benefits.
struct SubscriptionTier: Identifiable {
    let id = UUID()
    let name: String
    let monthlyPrice: String
    let yearlyPrice: String
    let features: [String]
    let isRecommended: Bool
}

/// A polished subscription pricing view for CryptoSage AI.
struct SubscriptionPricingView: View {
    // Gold accent for pricing cards
    var accentColor: Color = Color(red: 0.85, green: 0.65, blue: 0.13)  // gold
    var backgroundColor: Color = .theme.background
    var secondaryColor: Color = Color(red: 0.95, green: 0.85, blue: 0.60)  // light gold
    /// Soft gold wash background for pricing cards
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [accentColor.opacity(0.1), accentColor.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    @State private var annualBilling = false

    private let tiers: [SubscriptionTier] = [
        SubscriptionTier(
            name: "Free",
            monthlyPrice: "$0",
            yearlyPrice: "$0",
            features: [
                "1 connected wallet/exchange",
                "Basic AI insights (daily)",
                "AI Chat Assistant (5 prompts/day)",
                "Delayed market data (15 min)",
                "Community forums & educational content",
                "Ad-supported interface"
            ],
            isRecommended: false
        ),
        SubscriptionTier(
            name: "Pro",
            monthlyPrice: "$39",
            yearlyPrice: "$32",
            features: [
                "3 portfolios & real-time data",
                "Hourly AI predictions & alerts",
                "AI Chat Assistant (50 prompts/day)",
                "Heatmap of popular coins",
                "Automated trading up to $50k/mo",
                "Advanced metrics & portfolio optimization",
                "Ad-free experience & priority support"
            ],
            isRecommended: true
        ),
        SubscriptionTier(
            name: "Elite",
            monthlyPrice: "$129",
            yearlyPrice: "$109",
            features: [
                "Unlimited portfolios & trades",
                "Up-to-the-minute AI predictions",
                "Unlimited AI Chat Assistant",
                "Custom AI strategy builder",
                "Exclusive research reports & live webinars",
                "Dedicated account manager & 24/7 support"
            ],
            isRecommended: false
        )
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.largeTitle.bold())
                .foregroundColor(.primary)
                .padding(.top, 20)

            Picker(selection: $annualBilling, label: Text("Billing")) {
                Text("Monthly").tag(false)
                Text("Annual").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .tint(accentColor)
            .padding(.horizontal)
            .padding(.bottom, 10)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(tiers) { tier in
                        PricingCard(
                            tier: tier,
                            annual: annualBilling,
                            accentColor: accentColor,
                            secondaryColor: secondaryColor,
                            cardBackground: tier.name == "Free"
                                ? AnyShapeStyle(Color.theme.cardBackground)
                                : AnyShapeStyle(cardGradient)
                        )
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        .accentColor(accentColor)
    }
}

private struct PricingCard: View {
    let tier: SubscriptionTier
    let annual: Bool
    let accentColor: Color
    let secondaryColor: Color
    let cardBackground: AnyShapeStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if tier.isRecommended {
                Text("MOST POPULAR")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            HStack(alignment: .firstTextBaseline) {
                Text(tier.name)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                Spacer()
                Text(currentPrice)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
            }

            Divider()
                .background(secondaryColor)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(tier.features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(accentColor)
                            .font(.body)
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }

            Button(action: {
                // TODO: connect to purchase flow for `tier.name`
            }) {
                Text("Select \(tier.name)")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(tier.name == "Free" ? secondaryColor : accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(16)
        .background(cardBackground)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(tier.name == "Free" ? Color.clear : accentColor, lineWidth: 2)
        )
        .shadow(color: accentColor.opacity(0.2), radius: 12, x: 0, y: 6)
    }

    private var currentPrice: String {
        let price = annual ? tier.yearlyPrice : tier.monthlyPrice
        return "\(price)/mo"
    }
}

struct SubscriptionPricingView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionPricingView()
            .environmentObject(PortfolioViewModel.sample)
            .preferredColorScheme(.dark)
    }
}
