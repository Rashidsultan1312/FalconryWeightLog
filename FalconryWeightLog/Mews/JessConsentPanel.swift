import SwiftUI

struct JessConsentPanel: View {
    let bait: URL
    let onHood: () -> Void
    @State private var trained = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 18) {
                VStack(spacing: 6) {
                    Text("gate.welcome.title")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                }
                .padding(.top, 28)

                LureFrame(bait: bait, virgin: true)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)

                Button(action: { trained.toggle() }) {
                    HStack(spacing: 12) {
                        Image(systemName: trained ? "checkmark.shield.fill" : "shield")
                            .font(.system(size: 22))
                            .foregroundStyle(trained ? Color.accentColor : Color.secondary)
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 18)

                Button(action: onHood) {
                    Text("gate.privacy.continue")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!trained)
                .opacity(trained ? 1 : 0.4)
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
