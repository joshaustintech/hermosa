import SwiftUI

struct FamiliaStaticInfoCard<Content: View>: View {
    let title: String?
    let content: Content

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
    let trailing: Trailing

    init(
        primaryText: String,
        secondaryText: String,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
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
                        FamiliaBulletText(text: item)
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

private struct FamiliaBulletText: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: FamiliaMetrics.space8) {
            Text("•")
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .familiaTextStyle(.body)
        .foregroundStyle(FamiliaColors.textSecondary)
    }
}

struct FamiliaModelSentenceBlock: View {
    let sentence: ModelSentence

    var body: some View {
        FamiliaStudyCard(
            primaryText: sentence.spanish,
            secondaryText: sentence.english
        ) {
            VStack(alignment: .trailing, spacing: FamiliaMetrics.space8) {
                Text("Sentence")
                    .familiaTextStyle(.metadata)
                    .foregroundStyle(FamiliaColors.accentSecondary)
            }
        }
        .textSelection(.enabled)
    }
}
