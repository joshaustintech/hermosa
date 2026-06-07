# AGENTS.md

## Project Overview

This repository defines the plan for `Familia Spanish`, a local-first iOS app for learning practical Spanish in family, food, Chicago, church, and daily-life contexts.

Current repo state:
- Planning documents exist.
- The iOS app scaffold does not exist yet.
- The roadmap and curriculum documents are the source of truth for initial implementation.

Primary references:
- [FamiliaSpanishRoadmap.md](/Users/josh/hermosa/FamiliaSpanishRoadmap.md)
- [FamiliaSpanishLessonPlan.md](/Users/josh/hermosa/FamiliaSpanishLessonPlan.md)

## Product Intent

Build a SwiftUI iOS app that:
- Works fully offline.
- Uses bundled XML for static lesson content.
- Uses SwiftData only for user progress.
- Helps an English-speaking adult become conversational with Spanish-speaking relatives, especially around family, meals, Chicago life, and Protestant Christian vocabulary.

Non-goals for v1:
- No cloud sync or account system.
- No subscriptions or monetization logic.
- No speech recognition.
- No server-delivered lessons.
- No heavy architecture such as MVVM, coordinators, repositories, or DI frameworks.

## Architecture Rules

These rules are not optional unless the user explicitly changes the plan.

- Use `Swift 6`, `SwiftUI`, and `SwiftData`.
- Follow Apple Human Interface Guidelines in broad product and interaction decisions.
- Keep app state in a top-level `AppRootView`.
- Pass data and bindings down into small SwiftUI views.
- Parse bundled XML into plain Swift value types before rendering.
- Store static curriculum content in bundled resources, not SwiftData.
- Use SwiftData only for learner progress and quiz attempts.
- Prefer simple, direct data flow over abstraction layers.
- Prefer modern SwiftUI patterns over UIKit-style indirection or manual state plumbing.
- Avoid introducing MVVM, repositories, service containers, or dependency injection frameworks.

## Expected App Structure

When creating the app, prefer this structure:

- `FamiliaSpanishApp.swift`
- `AppRootView.swift`
- `Models/LessonModels.swift`
- `Models/ProgressModels.swift`
- `Parsing/LessonXMLParser.swift`
- `Data/lesson_plan.xml`
- `Views/LessonListView.swift`
- `Views/LessonDetailView.swift`
- `Views/VocabularyView.swift`
- `Views/GrammarFocusView.swift`
- `Views/ModelSentencesView.swift`
- `Views/QuizView.swift`
- `Views/QuizQuestionViews.swift`
- `Views/ProgressView.swift`
- `Views/SettingsView.swift`

## Data Model Expectations

Static curriculum models should remain plain Swift types.

Expected static models:
- `Curriculum`
- `Lesson`
- `VocabularyWord`
- `ModelSentence`
- `QuizQuestion`

Expected SwiftData models:
- `LessonProgress`
- `QuizAttempt`

Do not convert lesson content into SwiftData models unless the user explicitly asks for editable or user-authored lessons.

## Curriculum Rules

The bundled curriculum should reflect the lesson-plan document and remain aligned with these teaching priorities:

- Teach sentence construction, not isolated phrase memorization.
- Introduce grammar through useful conversation.
- Keep Chicago-local scenarios in the curriculum.
- Include Protestant Christian vocabulary in a respectful, non-denominationally rigid way.
- Favor high-frequency words and practical sentence patterns.

If curriculum content is generated or transformed:
- Preserve lesson order.
- Preserve lesson IDs.
- Preserve quiz intent and question type.
- Preserve Spanish text faithfully, including accent marks where applicable.

## UI Guidance

The app should feel native and readable rather than heavily stylized.

- Follow Apple HIG principles for clarity, deference, feedback, consistency, and touch-friendly interaction.
- Favor standard SwiftUI navigation and controls.
- Use small, composable views.
- Prefer SwiftUI-native composition with `NavigationStack`, `List`, `Form`, `Section`, and standard modifiers where they fit.
- Keep state ownership close to the top of the feature and pass only the data each child view needs.
- Prefer value-driven view composition and straightforward bindings over view models.
- Make Spanish text selectable where practical.
- Support Dynamic Type by avoiding rigid fixed-size layouts.
- Add accessibility labels for quiz controls.
- Keep lesson reading surfaces calm and easy to scan.

## Progress and Quiz Rules

- Parse lesson XML on app load.
- Show a readable error state if parsing fails.
- Quiz interactions should be tap-only in v1.
- Do not require typed, write-in, self-graded, or spoken answers in quizzes.
- Randomize answer order each time a question is shown.
- Vary incorrect answer choices between quiz runs when the curriculum data allows it.
- Prefer larger distractor pools so repeated attempts are less memorization-driven.
- Save quiz attempts locally with SwiftData.
- Mark a lesson completed at `70%` or higher quiz score.
- Progress must persist across app restarts.

## Build Order

Preferred implementation order:

1. Create the app shell and SwiftData container.
2. Add the bundled lesson XML resource.
3. Define plain Swift lesson models.
4. Implement XML parsing.
5. Render the lesson list.
6. Implement lesson detail.
7. Add SwiftData progress models.
8. Build the quiz engine.
9. Save quiz results and lesson completion.
10. Add the progress dashboard.
11. Add review mode.
12. Polish UI and accessibility.

## Change Guidance For Agents

When making changes in this repo:

- Treat the roadmap and lesson plan as the initial specification.
- Prefer direct implementation over speculative abstraction.
- Keep files small when possible.
- Add comments only where the code would otherwise be hard to follow.
- If the implementation diverges from this document, update this document or explain the reason clearly.

When the codebase is still missing:
- Create the minimal compiling app structure first.
- Do not invent unsupported features.
- Do not add external dependencies unless the user explicitly requests them.

## Verification Expectations

Before closing substantial implementation work, verify what is possible locally:

- Confirm the expected files exist.
- Verify the app builds if an Xcode project exists.
- Verify bundled XML can be loaded and parsed.
- Verify SwiftData-backed progress behavior where practical.

If verification cannot be run, state that explicitly.

## Definition Of Done For V1

The first usable version is done when:

- The app launches offline.
- Bundled XML lessons parse successfully.
- Every lesson can be read.
- Every lesson quiz can be completed.
- Progress persists locally with SwiftData.
- Progress can be reset.
- No server, account, analytics, or third-party dependency is required.
