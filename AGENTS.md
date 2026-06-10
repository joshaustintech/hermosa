# AGENTS.md

## Project Overview

This repository contains `Hermosa`, a local-first SwiftUI iOS app for learning practical Spanish in family, food, Chicago, church, and daily-life contexts.

Current repo state:
- The iOS app scaffold exists and builds.
- Bundled XML parsing, lesson reading, quizzes, progress persistence, and flashcards are implemented.
- The roadmap, curriculum, and design documents remain the source of truth for unfinished work and future changes.

Primary references:
- [HermosaRoadmap.md](/Users/josh/hermosa/HermosaRoadmap.md)
- [HermosaLessonPlan.md](/Users/josh/hermosa/HermosaLessonPlan.md)
- [DESIGN.md](/Users/josh/hermosa/DESIGN.md)

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

## Copy Preservation Rule

These rules are not optional unless the user explicitly changes them.

- Do not reintroduce previously removed UI copy just because it still exists in the underlying data model or planning documents.
- Treat product-approved on-screen copy as distinct from source curriculum metadata.
- Before surfacing fields like curriculum title, goal, tagline, marketing summary, or descriptive paragraphs in the UI, confirm that the current screen is actually supposed to display them.
- If a title, subtitle, paragraph, or label was intentionally removed earlier, do not add it back implicitly during refactors, design passes, or component migrations.
- When in doubt, preserve the current visible UX copy rather than regenerating it from model data.

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

- `HermosaApp.swift`
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
- `Views/VocabularyFlashcardsView.swift`
- `Views/PhraseFlashcardsView.swift`

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

The design system reference is:
- [DESIGN.md](/Users/josh/hermosa/DESIGN.md)

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
- Make clickable and non-clickable elements visually distinct.

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
10. Add the reusable flashcard deck.
11. Add vocabulary flashcards tied to each lesson.
12. Add short phrase flashcards tied to each lesson.
13. Add the progress dashboard.
14. Add review mode.
15. Polish UI and accessibility.

## Flashcard Rules

- Use the reusable flashcard deck for lesson-scoped and all-lessons review.
- Keep vocabulary and phrase decks distinct; do not mix phrase-tagged cards into vocabulary decks.
- Respect `Reduce Motion` when flipping or moving cards.
- Prefer lesson-linked bundled content before introducing new persistence needs.
- Keep flashcard UI in small SwiftUI views rather than introducing a new architecture layer.

## Change Guidance For Agents

When making changes in this repo:

- Treat the roadmap and lesson plan as the initial specification.
- Prefer direct implementation over speculative abstraction.
- Keep files small when possible.
- Add comments only where the code would otherwise be hard to follow.
- If the implementation diverges from this document, update this document or explain the reason clearly.

When adding new work:
- Extend the existing compiling app structure rather than rebuilding it.
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
