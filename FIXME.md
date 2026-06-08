# FIXME.md

## Known Issues

### 1. Removed marketing copy was accidentally reintroduced

Status: resolved on 2026-06-08

Problem:

- The unnecessary `Hermosa` subtitle and the “Become conversational with Spanish-speaking extended relatives...” paragraph were supposed to stay removed.
- They were reintroduced during the design-system screen refactor by binding the lesson list header to `curriculum.title` and `curriculum.goal` instead of preserving the intended on-screen copy decisions.

Root cause:

- The implementation reused curriculum metadata as UI header content without checking whether that content was still product-approved for display.
- The agent followed the data model too literally and failed to preserve prior UX copy removals.

Resolution:

- Removed the reintroduced subtitle/body copy from the live UI.
- Removed unused runtime curriculum title/goal fields from the Swift model and XML parser path.
- Removed the unused `goal` attribute from the bundled lesson XML resource.
- Added copy-preservation guardrails to `AGENTS.md`.

Files likely involved:

- `FamiliaSpanish/Views/LessonListView.swift`
- `AGENTS.md`

### 2. Serif/sans font pairing is specified but not visibly applied across screens

Status: resolved on 2026-06-08

Problem:

- `DESIGN.md` specifies serif titles and sans-serif body text.
- The current UI still does not reliably present that pairing in a clear, intentional way across the app.

Resolution:

- Audited title/body usage across the screen layer.
- Updated typography helpers so title roles use an unmistakable serif system face and body roles use sans-serif system text.
- Kept Dynamic Type support intact.

Files likely involved:

- `FamiliaSpanish/DesignSystem/DesignTypography.swift`
- screen views under `FamiliaSpanish/Views/`

### 3. Clickable and non-clickable surfaces are still too visually similar

Status: resolved on 2026-06-08

Problem:

- Clickable cards and non-clickable list/content items still share too much of the same color and border treatment.
- This makes some non-clickable content look tappable.

Resolution:

- Re-reviewed and updated `DESIGN.md`.
- Added distinct interactive surface and border tokens.
- Updated interactive rows and quiz choices to use dedicated interactive fills and borders.
- Kept static information cards on quieter neutral surfaces.

Files likely involved:

- `DESIGN.md`
- `FamiliaSpanish/DesignSystem/DesignRows.swift`
- `FamiliaSpanish/DesignSystem/DesignCards.swift`
- `FamiliaSpanish/DesignSystem/DesignSurfaces.swift`
- affected screen views

### 4. The current warm palette feels too common and too Claude-like

Status: resolved on 2026-06-08

Problem:

- The palette is warm, but it reads like a generic AI-generated editorial palette rather than something more distinct and authored.

Resolution:

- Replaced the old terracotta/lake-blue palette with a more authored currant/patina/mineral-parchment palette.
- Updated both light and dark mode token sets together.
- Propagated the new token names and values into the SwiftUI design-system layer.

Files likely involved:

- `DESIGN.md`
- `FamiliaSpanish/DesignSystem/DesignColors.swift`
- any derived component styling
