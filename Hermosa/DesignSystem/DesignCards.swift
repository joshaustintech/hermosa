import SwiftUI

struct HermosaStaticInfoCard<Content: View>: View {
    let title: String?
    let content: Content

    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space12) {
            if let title, title.isEmpty == false {
                Text(title)
                    .hermosaTextStyle(.cardTitle)
                    .foregroundStyle(HermosaColors.textPrimary)
            }

            content
        }
        .hermosaStaticCard()
    }
}

struct HermosaStudyCard<Trailing: View>: View {
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
        HStack(alignment: .top, spacing: HermosaMetrics.space12) {
            VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                Text(primaryText)
                    .hermosaTextStyle(.bodyEmphasized)
                    .foregroundStyle(HermosaColors.textPrimary)

                Text(secondaryText)
                    .hermosaTextStyle(.secondaryBody)
                    .foregroundStyle(HermosaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: HermosaMetrics.space12)

            trailing
        }
        .hermosaStaticCard()
    }
}

struct HermosaGrammarCallout: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space12) {
            HStack(alignment: .top, spacing: HermosaMetrics.space8) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(HermosaColors.accentSecondary)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                    Text(title)
                        .hermosaTextStyle(.cardTitle)
                        .foregroundStyle(HermosaColors.textPrimary)

                    ForEach(items, id: \.self) { item in
                        HermosaBulletText(text: item)
                    }
                }
                Spacer(minLength: HermosaMetrics.space12)
            }
        }
        .padding(HermosaMetrics.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous)
                .fill(HermosaColors.surfaceStaticMuted)
        )
        .overlay {
            RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous)
                .stroke(HermosaColors.strokeSoft, lineWidth: HermosaMetrics.standardBorderWidth)
        }
    }
}

private struct HermosaBulletText: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: HermosaMetrics.space8) {
            Text("•")
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .hermosaTextStyle(.body)
        .foregroundStyle(HermosaColors.textSecondary)
    }
}

struct HermosaModelSentenceBlock: View {
    let sentence: ModelSentence

    var body: some View {
        HermosaStudyCard(
            primaryText: sentence.spanish,
            secondaryText: sentence.english
        ) {
            VStack(alignment: .trailing, spacing: HermosaMetrics.space8) {
                Text("Sentence")
                    .hermosaTextStyle(.metadata)
                    .foregroundStyle(HermosaColors.accentSecondary)
            }
        }
        .textSelection(.enabled)
    }
}

#Preview("Cards") {
    HermosaScreenScrollView {
        VStack(alignment: .leading, spacing: HermosaMetrics.sectionSpacing) {
            HermosaStaticInfoCard(title: "Lesson") {
                Text("Meeting extended relatives at a family gathering.")
                    .hermosaTextStyle(.body)
                    .foregroundStyle(HermosaColors.textSecondary)
            }

            HermosaStudyCard(
                primaryText: "hola",
                secondaryText: "hello"
            ) {
                Text("interjection")
                    .hermosaTextStyle(.metadata)
                    .foregroundStyle(HermosaColors.accentSecondary)
            }

            HermosaGrammarCallout(
                title: "What to practice",
                items: Curriculum.placeholder.lessons[0].grammarFocus
            )

            HermosaModelSentenceBlock(sentence: Curriculum.placeholder.lessons[0].modelSentences[0])
        }
    }
}
