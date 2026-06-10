# Hermosa Roadmap

- Roadmap ID: `spanish-learning-swiftui-roadmap`
- Version: `1.0`
- App Name: `Hermosa`
- Language: `Swift 6`
- UI Framework: `SwiftUI`
- Persistence: `SwiftData`
- Lesson Format: `Embedded XML`
- Architecture Preference: Small composable SwiftUI views with state managed in the top-level view

## Product Goal

Build a local-first iOS Spanish learning app that teaches practical conversation, grammar awareness, vocabulary, Chicago-local scenarios, and Protestant Christian terminology.

### Non-Goals

- No cloud account system.
- No subscription logic in v1.
- No speech recognition in v1.
- No complex MVVM architecture.
- No server-side lesson delivery.

## Core User Stories

- `US01`: As a learner, I can see all lessons in order.
- `US02`: As a learner, I can open a lesson and read grammar notes, vocabulary, and model sentences.
- `US03`: As a learner, I can take quizzes after each lesson.
- `US04`: As a learner, I can see completed lessons.
- `US05`: As a learner, I can see quiz scores and progress.
- `US06`: As a learner, I can review vocabulary by lesson.
- `US07`: As a learner, I can reset progress for development/testing.

## Architecture

### Principles

- Use embedded XML as the static curriculum source.
- Parse XML into plain Swift structs.
- Use SwiftData only for user progress, not static lesson content.
- Keep app state in the top-level `AppRootView`.
- Pass state and bindings down into small SwiftUI views.
- Follow Apple Human Interface Guidelines for navigation, feedback, hierarchy, and readability.
- Prefer modern SwiftUI patterns and native controls over custom architecture or UIKit-style indirection.
- Avoid MVVM, coordinators, repositories, dependency injection frameworks, and over-abstraction.

### Suggested File Structure

- `HermosaApp.swift`: SwiftData container and app entry point.
- `AppRootView.swift`: Top-level navigation and app state.
- `Models/LessonModels.swift`: Plain Swift structs for parsed lesson XML.
- `Models/ProgressModels.swift`: SwiftData `@Model` classes for progress.
- `Parsing/LessonXMLParser.swift`: `XMLParser` delegate that loads embedded lesson data.
- `Data/lesson_plan.xml`: Embedded curriculum XML bundled in app resources.
- `Views/LessonListView.swift`: List of lessons with completion state.
- `Views/LessonDetailView.swift`: Lesson reading screen.
- `Views/VocabularyView.swift`: Vocabulary card/list component.
- `Views/GrammarFocusView.swift`: Grammar explanation component.
- `Views/ModelSentencesView.swift`: Example sentences component.
- `Views/QuizView.swift`: Quiz flow.
- `Views/QuizQuestionViews.swift`: Tap-based quiz question views such as multiple-choice and multi-select.
- `Views/ProgressView.swift`: Progress dashboard.
- `Views/FlashcardDeckView.swift`: Reusable stacked flashcard deck view.
- `Views/FlashcardsView.swift`: Top-level all-lessons flashcard hub.
- `Views/VocabularyFlashcardsView.swift`: Vocabulary flashcard launcher wrapper.
- `Views/PhraseFlashcardsView.swift`: Phrase flashcard launcher wrapper.
- `Views/SettingsView.swift`: Reset progress and development utilities.

## Data Model

### Static Models

#### `Curriculum`

- `id: String`
- `version: String`
- `lessons: [Lesson]`

#### `Lesson`

- `id: String`
- `title: String`
- `level: String`
- `estimatedMinutes: Int`
- `context: String`
- `grammarFocus: [String]`
- `vocabulary: [VocabularyWord]`
- `modelSentences: [ModelSentence]`
- `quiz: [QuizQuestion]`

#### `VocabularyWord`

- `spanish: String`
- `english: String`
- `partOfSpeech: String`

#### `ModelSentence`

- `spanish: String`
- `english: String`

#### `QuizQuestion`

- `multipleChoice(prompt: String, options: [String], answer: String)`
- `multipleSelect(prompt: String, options: [String], answers: [String])`

Quiz presentation rules:

- Shuffle answer order at runtime.
- Build incorrect answer sets from larger distractor pools when available.
- Vary distractor combinations between quiz attempts to reduce memorization.

### SwiftData Models

#### `LessonProgress`

- `lessonID: String` unique
- `isCompleted: Bool`
- `bestScore: Double`
- `lastScore: Double`
- `timesReviewed: Int`
- `completedAt: Date?`
- `lastReviewedAt: Date?`

#### `QuizAttempt`

- `lessonID: String`
- `score: Double`
- `correctCount: Int`
- `totalCount: Int`
- `attemptedAt: Date`

## Embedded XML Plan

- Add `lesson_plan.xml` to the app bundle. It should contain the `SpanishLearningCurriculum` XML artifact.
- Load `lesson_plan.xml` using `Bundle.main.url(forResource:withExtension:)`.
- Parse using `Foundation.XMLParser`.
- Convert parsed nodes into Swift structs before rendering.
- Do not save lesson text into SwiftData unless the user later needs editable lessons.

## Top-Level State Plan

### `AppRootView` State

- `curriculum: Curriculum?`
- `quizInProgressLessonID: String?`
- `loadError: String?`
- `lessonProgress: [LessonProgress]`

### Behavior

- On appear, parse bundled XML.
- If parsing succeeds, store `Curriculum` in `@State`.
- If parsing fails, show a readable error screen.
- Pass selected lessons into detail and quiz views.
- Use `modelContext` directly in user-action closures for saving completion.

## Screens

### `S01` - `LessonListView`

Purpose: Show ordered lessons and progress.

Components:

- Lesson row with title, level, estimated time, completion checkmark, and best score.
- Progress summary header.

Actions:

- Tap lesson to open `LessonDetailView`.
- Tap Progress tab to open `ProgressView`.

### `S02` - `LessonDetailView`

Purpose: Display lesson content.

Sections:

- Context
- Grammar Focus
- Vocabulary
- Model Sentences
- Start Quiz Button

### `S03` - `QuizView`

Purpose: Run quiz questions for a lesson.

State:

- `currentQuestionIndex: Int`
- `selectedAnswer: String`
- `correctCount: Int`
- `answeredQuestions: Int`
- `showFeedback: Bool`

Behavior:

- Render the current question based on enum case.
- Keep quiz interactions tap-only.
- Check answers by comparing the selected option or selected set.
- Randomize answer order when presenting each question.
- Rotate or sample incorrect answers from larger pools when available.
- At end, show score.
- Save `QuizAttempt`.
- Update `LessonProgress`.
- Mark lesson completed if score is at least 70 percent.

### `S04` - `ProgressView`

Purpose: Show progress across the curriculum.

Metrics:

- Lessons completed
- Total lessons
- Completion percentage
- Average best quiz score
- Last reviewed lesson

Current implementation status:

- Implemented as an interim summary view.
- Still missing the full recent-attempt and richer dashboard breakdown planned for `P07`.

### `S05` - `FlashcardsView`

Purpose: Launch all-lessons flashcard review from its own top-level tab.

Sections:

- All-lessons vocabulary deck
- All-lessons phrase deck

### `S05` - `SettingsView`

Purpose: Development and learner settings.

Actions:

- Reset all SwiftData progress.
- Show app version.
- Show lesson XML version.

Current implementation status:

- Version and curriculum rows exist.
- Reset-progress flow still needs implementation.

## Codex Build Roadmap

### `P01` - Create Project and Bundle XML

Goal: Create a compiling SwiftUI iOS app with bundled lesson XML.

Codex Prompt:

> Create a new Swift 6 SwiftUI iOS app named Hermosa. Use SwiftData.
> Add a bundled resource file named lesson_plan.xml.
> Do not use MVVM. Keep state in AppRootView and pass data into small composable views.
> Create placeholder views for LessonListView, LessonDetailView, QuizView, ProgressView, and SettingsView.
> Make the app compile.

Acceptance Criteria:

- App builds in Xcode.
- SwiftData container is configured.
- `lesson_plan.xml` is included in the app bundle.
- `AppRootView` renders without lesson parsing yet.

### `P02` - Define Plain Swift Lesson Models

Goal: Add simple structs and enums for curriculum content.

Codex Prompt:

> Implement plain Swift models for Curriculum, Lesson, VocabularyWord, ModelSentence, and QuizQuestion.
> QuizQuestion should support tap-only formats such as multipleChoice and multipleSelect.
> Do not use question types that require typing or speaking.
> Design the quiz models so answer order can be shuffled and distractor pools can vary by attempt.
> Keep these as value types. Do not make them SwiftData models.
> Make the code compile with sample in-memory test data.

Acceptance Criteria:

- Static lesson models compile.
- No static lesson model uses `@Model`.
- Sample lesson can render in `LessonListView`.

### `P03` - Implement XML Parsing

Goal: Parse `lesson_plan.xml` into `Curriculum`.

Codex Prompt:

> Create LessonXMLParser using Foundation.XMLParser.
> Load lesson_plan.xml from Bundle.main.
> Parse the SpanishLearningCurriculum XML into Curriculum and Lesson structs.
> Support Vocabulary Word attributes: spanish, english, partOfSpeech.
> Support Sentence attributes: spanish and english.
> Support tap-only quiz nodes. Normalize legacy question ideas into MultipleChoice or MultipleSelect.
> Support distractor pools or equivalent parsed data so incorrect answers can vary across attempts.
> Return a helpful error if parsing fails.
> Do not introduce external dependencies.

Acceptance Criteria:

- Bundled XML parses successfully.
- All lessons appear in `LessonListView`.
- Vocabulary, grammar focus, model sentences, and quizzes are populated.
- Parser errors are visible in the UI.

### `P04` - Create SwiftData Progress Models

Goal: Persist lesson completion and quiz attempts.

Codex Prompt:

> Create SwiftData `@Model` classes LessonProgress and QuizAttempt.
> LessonProgress should store lessonID, isCompleted, bestScore, lastScore, timesReviewed, completedAt, and lastReviewedAt.
> QuizAttempt should store lessonID, score, correctCount, totalCount, and attemptedAt.
> Wire the model container into HermosaApp.
> In AppRootView, query progress records and pass them into LessonListView.

Acceptance Criteria:

- Progress data persists after app restart.
- Lesson list shows completed lessons.
- Best quiz score is visible when available.

### `P05` - Build Lesson Reading Experience

Goal: Make lessons pleasant to read and study.

Codex Prompt:

> Implement LessonDetailView.
> Show lesson title, level, estimated minutes, context, grammar focus, vocabulary, and model sentences.
> Use small subviews: GrammarFocusView, VocabularyView, ModelSentencesView.
> Add a Start Quiz button.
> Keep styling simple, readable, and native.
> Use NavigationStack from AppRootView.

Acceptance Criteria:

- Every lesson can be opened.
- Grammar focus is easy to scan.
- Vocabulary shows Spanish, English, and part of speech.
- Model sentences show Spanish and English side by side or stacked.

### `P06` - Build Quiz Engine

Goal: Support tap-only quiz types from XML.

Codex Prompt:

> Implement QuizView for a lesson.
> Support these tap-only question types:
> - multiple choice
> - multi-select
>
> Use tappable options only.
> Do not require typed answers, spoken answers, or self-grading.
> Shuffle answer order for each presented question.
> Vary incorrect answer choices between attempts when possible.
> Show immediate feedback after each answer.
> At quiz end, show score and save QuizAttempt and LessonProgress using modelContext.
> Mark the lesson completed if score is at least 70 percent.

Acceptance Criteria:

- Quiz can run from start to finish.
- Scores calculate correctly.
- Progress saves to SwiftData.
- Lesson completion updates immediately in the lesson list.
- Repeated attempts do not present the exact same answer order every time.
- Repeated attempts can vary distractor choices where the data supports it.

### `P07` - Build Progress Dashboard

Goal: Give the learner a clear sense of momentum.

Codex Prompt:

> Implement ProgressView.
> Show total lessons, completed lessons, completion percentage, average best score, and recent quiz attempts.
> Use the parsed Curriculum plus SwiftData progress records.
> Keep calculations in the view or small helper functions, not in a view model.

Acceptance Criteria:

- Progress dashboard shows correct lesson counts.
- Completion percentage is accurate.
- Recent quiz attempts are listed.

### `P08` - Add Review Mode

Goal: Add lightweight spaced-review behavior.

Codex Prompt:

> Add a Review tab or section.
> Show lessons that are incomplete or have not been reviewed recently.
> Prioritize:
> 1. incomplete lessons
> 2. completed lessons with bestScore below 85 percent
> 3. lessons whose lastReviewedAt is older than 7 days
>
> Add a Review Vocabulary button that shows vocabulary cards from selected lessons.
> When the learner finishes reviewing a lesson, increment timesReviewed and update lastReviewedAt.

Acceptance Criteria:

- Review recommendations appear.
- Vocabulary review can be completed.
- `timesReviewed` and `lastReviewedAt` update correctly.

### `P09` - Add Settings and Reset Progress

Goal: Make development and testing easier.

Codex Prompt:

> Implement SettingsView.
> Add a Reset Progress button that deletes all LessonProgress and QuizAttempt records.
> Ask for confirmation before deleting.
> Show app version and curriculum version.
> Do not delete or modify bundled XML.

Acceptance Criteria:

- Reset requires confirmation.
- All progress records are deleted after reset.
- Lesson XML remains unchanged.

### `P10` - Polish and Accessibility

Goal: Make the app comfortable to use daily.

Codex Prompt:

> Polish the UI using native SwiftUI styling.
> Follow Apple Human Interface Guidelines and modern SwiftUI best practices.
> Prefer native controls, clear hierarchy, strong accessibility, and simple state flow over custom abstractions.
> Add Dynamic Type support by avoiding fixed font sizes where possible.
> Add accessibility labels for quiz buttons.
> Make Spanish text selectable where practical.
> Use clear spacing and section headers.
> Test on small and large iPhone simulators.

Acceptance Criteria:

- UI is readable on small iPhones.
- Dynamic Type does not break major screens.
- Quiz controls have useful accessibility labels.

### `P11` - Build Reusable 3D Flashcard Deck View

Goal: Create one simple reusable flashcard deck component that supports vocabulary and short-phrase review for a single lesson or across all lessons.

Codex Prompt:

> Build a reusable SwiftUI flashcard deck view that can present cards for one lesson or for all lessons.
> The deck should look visually stacked, similar to a compact pile of images in iMessage.
> Support vocabulary cards and short phrase cards with the same deck component.
> A vertical swipe partially follows the learner's drag and flips the current card to reveal the other side only when committed.
> A left swipe sends the current top card to the bottom of the deck and brings the next top card forward.
> A right swipe surfaces the bottom card, brings it to the top z-index only after commit, and places it on top of the stack.
> Animate both the flip and the card movement within the stack.
> If the user reverses direction before completing a swipe, cancel the action and return the card to its prior position and face.
> Respect Reduce Motion with simpler transitions while preserving the same interaction model.
> Keep the implementation in small SwiftUI views without introducing MVVM or a separate architecture layer.

Acceptance Criteria:

- One reusable deck view can render lesson-scoped and all-lessons flashcard sets.
- The deck visually reads as a stacked set of cards rather than a flat pager.
- Vertical swipes can be canceled by dragging the card back before release.
- Left and right swipes reorder cards only when the gesture commits.
- Releasing a partial or reversed swipe restores the card cleanly with no accidental flip or reorder.
- Reduce Motion users still get clear state changes without heavy 3D animation.

### `P12` - Add Vocabulary Flashcards

Goal: Add lightweight per-lesson vocabulary flashcards for focused review.

Codex Prompt:

> Add a vocabulary flashcard mode linked to each lesson.
> Allow the learner to open flashcards from a lesson detail screen and from review surfaces.
> Show Spanish on one side and English plus part of speech on the other side.
> Use the shared stacked flashcard deck with swipe-based flip and deck cycling behavior that respects Reduce Motion.
> Track lightweight review activity in SwiftData only if needed for future scheduling.
> Keep the implementation in small SwiftUI views without introducing MVVM.

Acceptance Criteria:

- Every lesson with vocabulary can launch a flashcard review flow.
- Flashcards are readable in light mode and dark mode.
- Flashcard interactions respect iOS accessibility motion settings.
- Lesson-linked vocabulary review can be completed without typing or speaking.

### `P13` - Add Short Phrase Flashcards

Goal: Add lesson-linked short phrase flashcards for practical conversation review.

Codex Prompt:

> Add short phrase flashcards tied to each lesson using model sentences or curated short conversational phrases.
> Show a Spanish prompt first, then reveal the English meaning or conversational use with the shared vertical flip gesture.
> Prefer short, high-frequency phrases that reinforce lesson grammar and context.
> Let the learner review phrase cards from the lesson detail screen and from a broader review area.
> Keep the implementation local-first and accessible without typing or speaking.
> Avoid overengineering; use straightforward SwiftUI state and composition.

Acceptance Criteria:

- Each lesson can expose a short phrase flashcard set when phrase content exists.
- Phrase cards reinforce the lesson context rather than duplicating only isolated vocabulary.
- Phrase review remains usable with Dynamic Type and Reduce Motion enabled.
- Phrase flashcards fit naturally into the existing lesson and review navigation.

## Current Milestone Status

- Completed: `P01`, `P02`, `P03`, `P04`, `P05`, `P06`, `P11`, `P12`, `P13`
- Partially completed: `P07`, `P10`
- Not started: `P08`, `P09`

## Suggested Implementation Order

1. Create app shell and SwiftData container.
2. Add lesson XML resource.
3. Add plain Swift lesson models.
4. Parse XML.
5. Render lesson list.
6. Render lesson detail.
7. Add SwiftData progress models.
8. Build quiz engine.
9. Save quiz results and lesson completion.
10. Build the reusable 3D flashcard deck view.
11. Add vocabulary flashcards.
12. Add short phrase flashcards.
13. Add progress dashboard.
14. Add review mode.
15. Polish UI and accessibility.

## Version 1 Definition of Done

- App launches offline.
- Bundled XML lessons parse successfully.
- User can study every lesson.
- User can take quizzes for every lesson.
- User progress persists locally with SwiftData.
- User can reset progress.
- No server, account, analytics, or third-party dependency is required.

## Future Enhancements

- `F01`: Add audio pronunciation using `AVSpeechSynthesizer`.
- `F02`: Add learner-recorded speaking practice.
- `F03`: Add lesson authoring from local XML files.
- `F04`: Add phrasebook mode for family gatherings.
- `F05`: Add church-service vocabulary pack.
- `F06`: Add Chicago neighborhood conversation packs.
- `F07`: Add spaced repetition scheduling per vocabulary word.
- `F08`: Expand vocabulary flashcards with per-card familiarity tracking.
- `F09`: Expand short phrase flashcards with phrase-level spaced repetition.
