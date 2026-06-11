# Implementation Status

## Finished

- Milestone `P01` app project scaffold completed.
- Milestone `P02` lesson value models expanded for parsed curriculum content.
- Milestone `P03` bundled lesson XML parsing implemented and wired into app startup.
- Milestone `P04` SwiftData progress models implemented and wired into app state.
- Milestone `P05` lesson reading experience implemented.
- Milestone `P06` tap-only quiz engine implemented.
- Milestone `P07` full progress dashboard completed with quiz attempt history.
- Milestone `P08` spaced-review mode completed with prioritized recommendations and flashcard deck completion triggers.
- Milestone `P09` settings and progress reset behavior implemented with confirmation dialogs.
- Milestone `P10` final UI and accessibility polish pass completed, including Dynamic Type ranges, selectable texts, and button accessibility hints.
- Milestone `P11` reusable stacked 3D/gesture-based flashcard deck view implemented.
- Milestone `P12` lesson-linked vocabulary flashcards deck implemented with dynamic completion tracking.
- Milestone `P13` lesson-linked phrase flashcards deck implemented.
- `Hermosa.xcodeproj` added to the repo.
- SwiftData container configured in `HermosaApp`.
- Bundled `lesson_plan.xml` resource wired into the target.
- Bundled `lesson_plan.xml` expanded to the full tap-only curriculum set for v1.
- `LessonXMLParser` now converts bundled XML into plain Swift lesson structs using `XMLParser`.
- `AppRootView` now loads bundled curriculum data at startup and shows a readable failure screen if parsing fails.
- Lesson list now renders real curriculum metadata rather than milestone placeholder copy.
- `LessonDetailView` now renders lesson context, grammar focus, vocabulary, model sentences, and a quiz entry point.
- `QuizView` now supports shuffled multiple-choice and multi-select questions with tap-only interaction.
- Quiz results now save `QuizAttempt` and `LessonProgress` records in SwiftData.
- Lesson completion now updates from quiz runs using the `70%` pass threshold.
- Quiz answer feedback now replaces the question block after submission and uses animated result icon feedback.
- Top-level `AppRootView` added with tab-based navigation and SwiftData query wiring.
- Top-level `Flashcards` tab added for all-lessons vocabulary and phrase review.
- Lesson detail screens can launch lesson-scoped vocabulary and phrase decks.
- Flashcard decks separate vocabulary cards from phrase cards instead of mixing them.
- Flashcard decks support partial vertical flip dragging, committed/canceled flip behavior, and left/right stack cycling without fade-based transitions.
- Static `#Preview` coverage now exists for every SwiftUI view file under `Hermosa/Views` and `Hermosa/DesignSystem`.
- Debug builds now explicitly use `-Onone`, so SwiftUI previews can render in Xcode.
- Plain Swift lesson models and SwiftData progress models are in active use for bundled lessons and learner progress.
- Simulator build passes.
- App launches on iOS Simulator with parser-backed bundled lesson data.

## In Progress

- None (Version 1 is fully complete!)

## Not Started Yet

- None

