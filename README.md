# hermosa

`Familia Spanish` is a local-first SwiftUI iOS app for learning practical Spanish in family, food, Chicago, church, and everyday-life contexts.

## Current Status

- Bundled XML curriculum loads offline at app launch.
- Lesson list and lesson detail reading surfaces are implemented.
- Tap-only quiz flow is implemented for bundled `multipleChoice` and `multipleSelect` questions.
- Quiz attempts and lesson progress save locally with SwiftData.
- Lesson completion is awarded at `70%` or higher.
- Progress and settings screens still need their remaining milestone work.

## Project References

- [AGENTS.md](/Users/josh/hermosa/AGENTS.md)
- [FamiliaSpanishRoadmap.md](/Users/josh/hermosa/FamiliaSpanishRoadmap.md)
- [FamiliaSpanishLessonPlan.md](/Users/josh/hermosa/FamiliaSpanishLessonPlan.md)
- [ImplementationStatus.md](/Users/josh/hermosa/ImplementationStatus.md)

## Current App Shape

- `FamiliaSpanishApp.swift`: app entry and SwiftData container
- `AppRootView.swift`: top-level app state and tab navigation
- `FamiliaSpanish/Data/lesson_plan.xml`: bundled curriculum source
- `FamiliaSpanish/Parsing/LessonXMLParser.swift`: XML parsing into plain Swift models
- `FamiliaSpanish/Views/LessonDetailView.swift`: lesson reading experience
- `FamiliaSpanish/Views/QuizView.swift`: quiz flow and result persistence
- `FamiliaSpanish/Views/ProgressView.swift`: interim progress summary
- `FamiliaSpanish/Views/SettingsView.swift`: pending milestone expansion

## Remaining Milestones

- Finish the full `P07` progress dashboard
- Implement `P08` review mode
- Add reset-progress behavior in settings
- Complete final accessibility and UI polish
