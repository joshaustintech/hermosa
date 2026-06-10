# hermosa

`Hermosa` is a local-first SwiftUI iOS app for learning practical Spanish in family, food, Chicago, church, and everyday-life contexts.

## App Preview

![Hermosa lessons screenshot](Docs/Images/hermosa-screenshot-lessons.jpg)
![Hermosa vocabulary screenshot](Docs/Images/hermosa-screenshot-vocabulary.jpg)

## Current Status

- Bundled XML curriculum loads offline at app launch.
- Lesson list and lesson detail reading surfaces are implemented.
- Tap-only quiz flow is implemented for bundled `multipleChoice` and `multipleSelect` questions.
- Quiz attempts and lesson progress save locally with SwiftData.
- Lesson completion is awarded at `70%` or higher.
- Progress and settings screens still need their remaining milestone work.

## Project References

- [AGENTS.md](/Users/josh/hermosa/AGENTS.md)
- [HermosaRoadmap.md](/Users/josh/hermosa/HermosaRoadmap.md)
- [HermosaLessonPlan.md](/Users/josh/hermosa/HermosaLessonPlan.md)
- [ImplementationStatus.md](/Users/josh/hermosa/ImplementationStatus.md)

## Current App Shape

- `HermosaApp.swift`: app entry and SwiftData container
- `AppRootView.swift`: top-level app state and tab navigation
- `Hermosa/Data/lesson_plan.xml`: bundled curriculum source
- `Hermosa/Parsing/LessonXMLParser.swift`: XML parsing into plain Swift models
- `Hermosa/Views/LessonDetailView.swift`: lesson reading experience
- `Hermosa/Views/QuizView.swift`: quiz flow and result persistence
- `Hermosa/Views/ProgressView.swift`: interim progress summary
- `Hermosa/Views/SettingsView.swift`: pending milestone expansion

## Remaining Milestones

- Finish the full `P07` progress dashboard
- Implement `P08` review mode
- Add reset-progress behavior in settings
- Build a reusable stacked 3D flashcard deck for lesson-level and all-lessons vocabulary and short-phrase review
- Complete final accessibility and UI polish
