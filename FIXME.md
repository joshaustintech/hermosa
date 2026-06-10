# FIXME.md

## Current Open Work

- `ProgressView` is still an interim summary screen rather than the full `P07` dashboard.
- `SettingsView` still needs reset-progress behavior and confirmation flow from `P09`.
- `P08` review mode is not implemented yet.

## Recently Resolved

### 1. Removed marketing copy was accidentally reintroduced

Status: resolved on 2026-06-08

Resolution:

- Removed the reintroduced subtitle/body copy from the live UI.
- Removed unused runtime curriculum title/goal fields from the Swift model and XML parser path.
- Removed the unused `goal` attribute from the bundled lesson XML resource.
- Added copy-preservation guardrails to `AGENTS.md`.

### 2. Serif/sans font pairing was not visibly applied across screens

Status: resolved on 2026-06-08

Resolution:

- Audited title/body usage across the screen layer.
- Updated typography helpers so title roles use a serif system face and body roles use sans-serif system text.
- Kept Dynamic Type support intact.

### 3. Clickable and non-clickable surfaces were too visually similar

Status: resolved on 2026-06-08

Resolution:

- Added distinct interactive surface and border tokens.
- Updated interactive rows and quiz choices to use dedicated interactive fills and borders.
- Kept static information cards on quieter neutral surfaces.

### 4. Debug previews were blocked by optimized builds

Status: resolved on 2026-06-10

Resolution:

- Set `SWIFT_OPTIMIZATION_LEVEL = "-Onone"` for both Debug configuration blocks in `Hermosa.xcodeproj/project.pbxproj`.
- Verified Debug builds now compile with `-Onone`, restoring SwiftUI preview compatibility.

### 5. The palette direction changed from the earlier warm editorial scheme

Status: resolved on 2026-06-10

Resolution:

- Updated the shipped design tokens to a clearer blue-led light/dark palette with white and blue-gray surfaces.
- Brought `DESIGN.md` back in sync with the colors actually used by `Hermosa/DesignSystem/DesignColors.swift`.
