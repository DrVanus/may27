import SwiftUI
import Charts

/// A donut (pie) chart view that displays each coin’s share of the portfolio
/// based on its current value (quantity * currentPrice).
struct ThemedPortfolioPieChartView: View {
    @ObservedObject var portfolioVM: PortfolioViewModel
    @Binding var showLegend: Bool

    /// Initialize with optional legend binding (defaults to false).
    init(
        portfolioVM: PortfolioViewModel,
        showLegend: Binding<Bool> = .constant(false)
    ) {
        self.portfolioVM = portfolioVM
        self._showLegend = showLegend
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart(portfolioVM.allocationData, id: \.symbol) { slice in
                SectorMark(
                    angle: .value("Percent", slice.percent),
                    innerRadius: .ratio(0.6),
                    outerRadius: .ratio(0.95)
                )
                .foregroundStyle(slice.color)
            }
            .chartLegend(showLegend ? .visible : .hidden)
            .chartLegend(position: .bottom, alignment: .center, spacing: 8)
        } else {
            Text("Pie chart requires iOS 16+.")
                .foregroundColor(.gray)
        }
    }
    
}

// MARK: - Preview
struct ThemedPortfolioPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        // No sample holdings preview since Holding is no longer used.
        // You may want to create a mock PortfolioViewModel for preview.
        ThemedPortfolioPieChartView(
            portfolioVM: PortfolioViewModel(),
            showLegend: .constant(false)
        )
        .frame(width: 200, height: 200)
    }
}
