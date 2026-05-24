import SwiftUI
import Charts

struct HeuteScreen: View {
    @EnvironmentObject private var ledger: WeightLedger
    @State private var newWeight: String = ""
    @State private var showingPicker = false
    @State private var showAddEntry = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if let bird = ledger.activeBird {
                    VStack(alignment: .leading, spacing: 14) {
                        birdSelector(bird)
                        weightHero(bird)
                        feedRecommendCard(bird)
                        chartCard(bird)
                        quickEntryCard(bird)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                } else {
                    EmptyStateBox(symbol: "bird",
                                  titleKey: "heute.empty.title",
                                  messageKey: "heute.empty.body")
                        .padding(20)
                }
            }
            .background(FieldCanvas(opacity: 0.32, imageName: ledger.activeBird.map { FieldBackdrop.named(for: $0.species) } ?? FieldBackdrop.primary))
            .navigationTitle("tab.heute")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func birdSelector(_ bird: Bird) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ledger.birds) { b in
                    ChipButton(verbatim: b.name,
                               symbol: "bird.fill",
                               selected: b.id == bird.id,
                               tint: b.species.tint) {
                        ledger.activeBirdId = b.id
                    }
                }
            }
        }
    }

    private func weightHero(_ bird: Bird) -> some View {
        let weights = ledger.recentWeights(for: bird)
        let latest = weights.last?.weightGrams ?? bird.flyingWeight
        let status = FeedRecommender.status(for: bird, currentGrams: latest)
        let delta = latest - bird.flyingWeight
        return ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Palette.leather)
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(bird.name)
                        .font(.system(.headline, design: .serif).weight(.bold))
                        .foregroundStyle(Palette.brass)
                    Spacer()
                    Image(systemName: "bird.fill")
                        .foregroundStyle(Palette.brass)
                }
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(latest)")
                        .font(.system(size: 64, weight: .black, design: .serif))
                        .foregroundStyle(.white)
                    Text(formatUnit())
                        .font(.system(.title2, design: .serif).weight(.semibold))
                        .foregroundStyle(Palette.brass)
                }
                statusBadge(status: status)
                HStack {
                    Text(LocalizedStringKey(deltaKey(delta)))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    Text(formatDelta(delta))
                        .font(.system(.subheadline, design: .monospaced).weight(.bold))
                        .foregroundStyle(deltaColor(delta))
                }
                Text(String(format: NSLocalizedString("heute.target", comment: ""), bird.flyingWeight))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(Palette.brass.opacity(0.9))
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
    }

    private func statusBadge(status: WeightStatus) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color(hue: status.hueValue, saturation: 0.7, brightness: 0.85))
                .frame(width: 10, height: 10)
            Text(LocalizedStringKey(status.titleKey))
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Capsule().fill(.white.opacity(0.18)))
    }

    private func feedRecommendCard(_ bird: Bird) -> some View {
        let weights = ledger.recentWeights(for: bird)
        let latest = weights.last?.weightGrams ?? bird.flyingWeight
        let grams = FeedRecommender.recommendedFeedGrams(for: bird, currentGrams: latest)
        return RoundedCard(tinted: Palette.brass.opacity(0.14)) {
            VStack(alignment: .leading, spacing: 6) {
                Text("heute.feed.title").upperLabel()
                HStack {
                    Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundStyle(Palette.bordeaux)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(String(format: NSLocalizedString("heute.feed.gram", comment: ""), grams))
                            .font(.system(.title2, design: .serif).weight(.bold))
                        Text(LocalizedStringKey("heute.feed.kinds"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                Divider().padding(.vertical, 4)
                HStack(spacing: 14) {
                    ForEach(FeedKind.allCases) { kind in
                        VStack(spacing: 2) {
                            Text("\(FeedRecommender.recommendedFeed(kind, gramsAt: grams))")
                                .font(.system(.subheadline, design: .monospaced).weight(.bold))
                            Text(LocalizedStringKey(kind.nameKey))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func chartCard(_ bird: Bird) -> some View {
        let weights = ledger.recentWeights(for: bird)
        RoundedCard {
            VStack(alignment: .leading, spacing: 6) {
                Text("heute.chart.title").upperLabel()
                if weights.isEmpty {
                    Text("heute.chart.empty")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 30)
                } else {
                    Chart(weights) { entry in
                        if let grams = entry.weightGrams {
                            LineMark(x: .value("date", entry.date),
                                     y: .value("g", grams))
                                .interpolationMethod(.monotone)
                                .foregroundStyle(bird.species.tint)
                            PointMark(x: .value("date", entry.date),
                                      y: .value("g", grams))
                                .foregroundStyle(Palette.bordeaux)
                        }
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .frame(height: 160)
                }
            }
        }
    }

    private func quickEntryCard(_ bird: Bird) -> some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("heute.entry.title").upperLabel()
                HStack {
                    TextField("heute.entry.placeholder", text: $newWeight)
                        .keyboardType(.numberPad)
                        .font(.system(.title3, design: .serif).weight(.bold))
                    Button {
                        if let grams = Int(newWeight) {
                            ledger.append(LogbookEntry(birdId: bird.id, kind: .weighing, weightGrams: grams))
                            newWeight = ""
                            Haptics.success()
                        }
                    } label: {
                        Label("heute.entry.save", systemImage: "checkmark.circle.fill")
                            .font(.system(.subheadline, design: .serif).weight(.bold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Palette.accent, in: Capsule())
                            .foregroundStyle(.white)
                    }
                    .disabled(Int(newWeight) == nil)
                }
            }
        }
    }

    private func formatUnit() -> String {
        ledger.weightUnit == .grams ? "g" : "oz"
    }

    private func formatDelta(_ delta: Int) -> String {
        if delta >= 0 { return "+\(delta)" }
        return "\(delta)"
    }

    private func deltaKey(_ delta: Int) -> String {
        if delta == 0 { return "heute.delta.exact" }
        if delta > 0 { return "heute.delta.over" }
        return "heute.delta.under"
    }

    private func deltaColor(_ delta: Int) -> Color {
        if abs(delta) <= 10 { return Color.green }
        if delta > 30 { return Color.red }
        return Palette.brass
    }
}
