import SwiftUI

struct FamiliaStaticInfoCard<Content: View>: View {
    let title: String?
    @ViewBuilder let content: Content

    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space12) {
            if let title, title.isEmpty == false {
                Text(title)
                    .familiaTextStyle(.cardTitle)
                    .foregroundStyle(FamiliaColors.textPrimary)
            }

            content
        }
        .familiaStaticCard()
    }
}

struct FamiliaStudyCard<Trailing: View>: View {
    let primaryText: String
    let secondaryText: String
    let tertiaryText: String?
    let trailing: Trailing

    init(
        primaryText: String,
        secondaryText: String,
        tertiaryText: String? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.tertiaryText = tertiaryText
        self.trailing = trailing()
    }

    var body: some View {
        HStack(alignment: .top, spacing: FamiliaMetrics.space12) {
            VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
                Text(primaryText)
                    .familiaTextStyle(.bodyEmphasized)
                    .foregroundStyle(FamiliaColors.textPrimary)

                Text(secondaryText)
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let tertiaryText, tertiaryText.isEmpty == false {
                    Text(tertiaryText)
                        .familiaTextStyle(.metadata)
                        .foregroundStyle(FamiliaColors.textTertiary)
                }
            }

            Spacer(minLength: FamiliaMetrics.space12)

            trailing
        }
        .familiaStaticCard()
    }
}

struct FamiliaGrammarCallout: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space12) {
            HStack(alignment: .top, spacing: FamiliaMetrics.space8) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(FamiliaColors.accentSecondary)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
                    Text(title)
                        .familiaTextStyle(.cardTitle)
                        .foregroundStyle(FamiliaColors.textPrimary)

                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: FamiliaMetrics.space8) {
                            Text("•")
                                .familiaTextStyle(.body)
                                .foregroundStyle(FamiliaColors.textSecondary)

                            Text(item)
                                .familiaTextStyle(.body)
                                .foregroundStyle(FamiliaColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .padding(FamiliaMetrics.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                .fill(FamiliaColors.surfaceStaticMuted)
        )
        .overlay {
            RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                .stroke(FamiliaColors.strokeSoft, lineWidth: FamiliaMetrics.standardBorderWidth)
        }
    }
}

struct FamiliaModelSentenceBlock: View {
    let sentence: ModelSentence
    let actionTitle: String?
    let action: (() -> Void)?

    init(sentence: ModelSentence, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.sentence = sentence
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        FamiliaStudyCard(
            primaryText: sentence.spanish,
            secondaryText: sentence.english
        ) {
            VStack(alignment: .trailing, spacing: FamiliaMetrics.space8) {
                Text("Sentence")
                    .familiaTextStyle(.metadata)
                    .foregroundStyle(FamiliaColors.accentSecondary)

                if let actionTitle, let action {
                    Button(actionTitle, action: action)
                        .buttonStyle(FamiliaQuietButtonStyle())
                }
            }
        }
        .textSelection(.enabled)
    }
}

struct FamiliaFlashcard: View {
    let title: String
    let prompt: String
    let answer: String
    let isRevealed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space16) {
            Text(title)
                .familiaTextStyle(.metadata)
                .foregroundStyle(FamiliaColors.accentSecondary)

            Text(prompt)
                .familiaTextStyle(.cardTitle)
                .foregroundStyle(FamiliaColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()
                .overlay(FamiliaColors.divider)

            if isRevealed {
                Text(answer)
                    .familiaTextStyle(.body)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("Tap to reveal")
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(FamiliaColors.textTertiary)
            }
        }
        .familiaFeatureCard()
    }
}
