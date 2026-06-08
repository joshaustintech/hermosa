# DESIGN.md

## Purpose

This document defines the visual and interaction system for `Familia Spanish`.
It overrides current ad hoc styling choices and should be treated as the source of truth for future UI implementation unless the user explicitly changes it.

This is a SwiftUI-first design system for a calm, native-feeling, adult-oriented language app.
The intended mood is:

- warm
- editorial
- quiet
- trustworthy
- practical

It should feel closer to a well-designed prayer journal, cookbook margin note, or neighborhood guide than a gamified children’s app or a flashy startup dashboard.

## Core Design Direction

### Design concept

Use a restrained editorial system built from:

- mineral parchment backgrounds
- dark plum-ink text
- one confident currant action color
- one patina-green support color
- serif titles
- sans-serif body copy
- simple, obvious interactive affordances

### Principles

- Prioritize readability over decoration.
- Make interaction states obvious at a glance.
- Keep the layout airy, but not sparse.
- Prefer one strong accent color for actions rather than many competing accents.
- Use color to communicate meaning, not to decorate neutral surfaces.
- Preserve a native iOS feel even when using a custom palette.
- Avoid glassy, aurora, neon, or highly atmospheric backgrounds for primary reading surfaces.

## Interaction Rule: Clickable Must Look Clickable

This is mandatory.

The current UX problem is that clickable and non-clickable elements are too visually similar. Future UI work must fix that decisively.

### Required distinction

Interactive elements must use at least two of these cues:

- accent fill or accent tint
- clear button shape
- chevron or disclosure indicator for navigation rows
- elevated or stroked boundary that changes on press
- icon treatment that implies action

Non-interactive elements must stay visually quieter:

- neutral surfaces
- no accent-colored outlines unless the element is interactive
- no button-like fill treatment
- no chevrons
- no pressed-state styling

### Practical rules

- Primary actions use filled buttons.
- Secondary actions use stroked buttons.
- Plain text should never look like a tappable control unless it is actually a button or link.
- Navigating list rows must include either a chevron or a strong pressed/highlight behavior.
- Static information cards must not use the same accent fill or border treatment as buttons.
- Quiz answer choices are interactive and must always look selectable.
- Disabled controls must be visibly dimmed and lose action contrast.

## Platform Constraints

- Use only fonts available on Apple platforms by default.
- Use Dynamic Type-friendly text styles.
- Maintain minimum 44x44 pt tap targets.
- Favor semantic SwiftUI structure and asset colors over hard-coded one-off styling.
- Support both Light Mode and Dark Mode.

## Font System

### Pairing

- Title serif: `System Serif` (`.serif`, New-York-like in tone)
- Body sans-serif: `SF Pro`

This pairing is intentionally Apple-native, editorial, durable, and visually reliable in SwiftUI.

### Usage rules

- Use the system serif face only for titles, screen headings, lesson names, and a few emphasis moments.
- Use `SF Pro` for body text, labels, controls, metadata, quiz content, and settings.
- Do not use more than these two type families in v1.
- Do not use all-caps for long labels.
- Keep letter spacing default unless there is a specific reason to adjust it.

### Type scale

- Display: `System Serif`, 34 pt, semibold
- Screen title: `System Serif`, 28 pt, semibold
- Section title: `System Serif`, 22 pt, medium
- Card title: `System Serif`, 20 pt, medium
- Body: `SF Pro`, 17 pt, regular
- Body emphasized: `SF Pro`, 17 pt, semibold
- Secondary body: `SF Pro`, 15 pt, regular
- Metadata: `SF Pro`, 13 pt, medium
- Caption: `SF Pro`, 12 pt, regular
- Button label: `SF Pro`, 17 pt, semibold

### Text behavior

- Spanish examples may use body-emphasized weight to lead the eye.
- English translations should usually be secondary body.
- Metadata should never compete with lesson titles.
- Titles may wrap to two lines; avoid truncating lesson names if possible.

## Color System

Use named semantic colors in implementation later. These hex values define the palette.

### Brand palette intent

- `Currant` is the action color.
- `Patina Green` is the informational/support color.
- `Moss` is used sparingly for success/progress.
- Mineral parchment neutrals carry most of the interface.

### Light Mode palette

- `bg.base`: `#F4F0EA`
- `bg.elevated`: `#FCF8F2`
- `bg.subtle`: `#E8E1D8`
- `surface.static`: `#F1E8DD`
- `surface.staticMuted`: `#ECE3D8`
- `surface.interactive`: `#FAF5EF`
- `surface.interactivePressed`: `#F3E7E6`
- `surface.feature`: `#FFF9F4`
- `surface.input`: `#F7EFE5`
- `stroke.soft`: `#CFC4B8`
- `stroke.strong`: `#A99788`
- `stroke.interactive`: `#8C3B4A`
- `stroke.interactivePressed`: `#6F2D39`
- `text.primary`: `#221A1C`
- `text.secondary`: `#5B4F52`
- `text.tertiary`: `#85767A`
- `accent.primary`: `#8C3B4A`
- `accent.primaryPressed`: `#6F2D39`
- `accent.secondary`: `#2F6D67`
- `accent.secondaryPressed`: `#245650`
- `success`: `#5A7353`
- `warning`: `#9D6F28`
- `error`: `#A1463F`
- `selection.fill`: `#EAD6DB`
- `selection.stroke`: `#8C3B4A`
- `divider`: `#D7CDC2`
- `shadow`: `#00000014`

### Dark Mode palette

- `bg.base`: `#161315`
- `bg.elevated`: `#1E1A1D`
- `bg.subtle`: `#292427`
- `surface.static`: `#262124`
- `surface.staticMuted`: `#221D20`
- `surface.interactive`: `#30282C`
- `surface.interactivePressed`: `#3A3035`
- `surface.feature`: `#231E21`
- `surface.input`: `#2C2528`
- `stroke.soft`: `#4A4144`
- `stroke.strong`: `#6A5D63`
- `stroke.interactive`: `#C56A78`
- `stroke.interactivePressed`: `#9E5360`
- `text.primary`: `#F6EDEE`
- `text.secondary`: `#D6C7CB`
- `text.tertiary`: `#AA999F`
- `accent.primary`: `#C56A78`
- `accent.primaryPressed`: `#9E5360`
- `accent.secondary`: `#79AAA4`
- `accent.secondaryPressed`: `#5D8882`
- `success`: `#90AD87`
- `warning`: `#D2A25C`
- `error`: `#D97E77`
- `selection.fill`: `#4B2C35`
- `selection.stroke`: `#C56A78`
- `divider`: `#3A3337`
- `shadow`: `#00000033`

### Color usage rules

- `accent.primary` is for primary actions, selected quiz states, active progress, and the current tab.
- `accent.secondary` is for links, informational chips, and secondary emphasis.
- Neutral backgrounds should dominate the interface.
- Never place body text on `accent.primary` unless using white or near-white text with accessible contrast.
- Avoid using both accent colors in the same small component unless one is clearly status-related.
- Static information surfaces should use `surface.static` or `surface.staticMuted` with soft borders.
- Interactive rows and answer choices should use `surface.interactive` with `stroke.interactive`.
- Static information surfaces must not share the same border color as interactive surfaces.

## Spacing, Shape, and Layout

### Spacing scale

- `4`
- `8`
- `12`
- `16`
- `20`
- `24`
- `32`

Use these as the main rhythm.

### Corners

- Small controls: `10`
- Cards and grouped surfaces: `16`
- Hero or feature containers: `20`
- Pills and badges: capsule or `999`

### Strokes and shadows

- Prefer 1 pt borders over heavy shadows.
- Use shadows sparingly and only on elevated action surfaces.
- Reading cards should usually rely on tone and border, not shadow.

### Layout guidance

- Screen padding: `20`
- Vertical spacing between major sections: `24`
- Vertical spacing within a section: `12`
- Card internal padding: `16`
- Dense metadata rows may use `12`

## Component System

These components should be enough to support a coherent v1 app.

### 1. App Shell

- `NavigationStack` per major tab
- Bottom tab bar with standard SF Symbols
- Background stays neutral and quiet
- Current tab uses `accent.primary`

### 2. Screen Header

- Large serif title
- Optional short supporting sentence in secondary body text
- No decorative banners behind standard screen titles

### 3. Section Header

- Serif heading
- Optional short body-sized helper text
- Optional trailing text button in `accent.secondary`

### 4. Primary Button

- Filled with `accent.primary`
- White or near-white label
- Minimum height 50 pt
- Corner radius 14
- Pressed state darkens fill

Use for:

- Start Quiz
- Submit Answer
- Continue
- Reset confirmation

### 5. Secondary Button

- Neutral or transparent fill
- 1 pt border using `stroke.strong`
- Label in `text.primary`
- Pressed state adds subtle `bg.subtle`

Use for:

- Review lesson
- Try again
- Cancel secondary workflows

### 6. Quiet Text Button

- Sans-serif semibold label
- `accent.secondary` text
- No container by default
- Must have enough spacing around it to feel tappable

Use sparingly for tertiary actions.

### 7. Lesson Row

Interactive component.

Must include:

- title
- metadata line
- progress status
- disclosure chevron

Styling:

- neutral card surface
- visible pressed/highlight state
- subtle border
- completion badge in success color

Non-interactive cards must not use this exact layout treatment.

### 8. Static Info Card

Non-interactive component.

Use for:

- grammar notes
- cultural notes
- summaries
- encouragement

Styling:

- neutral surface only
- no chevron
- no interactive border color
- no button-like fill

### 9. Vocabulary Row

- Spanish term as body-emphasized text
- English gloss as secondary body
- Part of speech as metadata chip
- Optional audio or favorite actions can be added later, but only if clearly tappable

### 10. Grammar Callout

- Small title
- 1 to 3 bullet points or brief explanation
- Use `bg.subtle` or `surface.card`
- Use `accent.secondary` only as a small leading rule or icon, not a full fill

### 11. Model Sentence Block

- Spanish sentence first
- English translation below
- Generous line spacing
- Optional “copy” action must be visibly a button

### 12. Quiz Answer Option

Highly important interactive element.

Default state:

- clear border
- neutral surface
- radio/check indicator space

Selected state:

- `selection.fill`
- `selection.stroke`
- stronger text emphasis

Correct state:

- success tint and success border

Incorrect state:

- error tint and error border

This component must never look like passive text in a box.

### 13. Progress Badge

- compact pill
- success tone for completed
- neutral tone for not started
- accent tone for in progress

### 14. Progress Summary Card

- serif heading
- large numeric progress metric
- short helper text
- optional progress bar

### 15. Progress Bar

- track uses subdued neutral
- fill uses `accent.primary`
- success can be used once a lesson is complete

### 16. Settings Row

If interactive:

- include chevron, toggle, or button treatment

If static:

- no chevron
- quieter text color

Never make static and interactive settings rows visually identical.

### 17. Empty State

- simple symbol
- serif title
- short sans-serif explanation
- one clear primary action

### 18. Error State

- symbol or icon
- concise title
- plain-language explanation
- retry button as primary button

### 19. Flashcard

For later milestones.

- quiet card face
- strong title hierarchy
- obvious tap affordance
- reveal state change must be clear even with Reduce Motion enabled

### 20. Confirmation Dialog Actions

- destructive action in error color only when truly destructive
- cancel stays neutral
- avoid having two equally loud actions

## Iconography

- Use SF Symbols only for v1 unless the user asks otherwise.
- Symbols should support comprehension, not decoration.
- Pair symbols with text when meaning is not instantly obvious.
- Do not rely on icon-only buttons for essential quiz actions.

## Motion and Feedback

- Motion should be subtle and fast.
- Prefer fade, scale, and small position changes.
- Avoid floaty ambient motion on core study screens.
- Respect `Reduce Motion`.
- Interactive controls should show pressed feedback through tint, opacity, or scale.
- Use haptics sparingly for quiz submission, correct answer, and completion moments.

## Content Styling Rules

- Spanish content should usually lead visually.
- English translations should support, not dominate.
- Avoid centering long reading text.
- Keep line lengths comfortable.
- Make lesson text selectable where practical.
- Avoid decorative italics for large amounts of instructional copy.

## Accessibility Rules

- Body text contrast should target 7:1 where practical.
- Never rely on color alone to show selected, correct, incorrect, or completed state.
- Interactive rows need visible structure plus VoiceOver labels.
- Touch targets must remain comfortable at large Dynamic Type sizes.
- If a row is tappable, the full row should usually be tappable.

## Implementation Guidance For Future SwiftUI Work

- Create semantic color assets matching these token names.
- Build a single typography helper for serif titles and sans body styles.
- Standardize button styles instead of styling each button inline.
- Standardize interactive rows separately from static cards.
- Standardize quiz option states before building more screens.
- Remove or replace any custom atmospheric background treatment that reduces legibility or weakens interaction clarity.

## Anti-Patterns

Do not do the following unless the user explicitly asks for it:

- aurora/glow backgrounds behind reading-heavy content
- purple-first palette
- low-contrast beige-on-beige text
- static cards that look like buttons
- button labels that look like plain captions
- more than two font families
- heavy gradients on controls
- glassmorphism for core lesson surfaces
- random accent colors per screen
- overly playful gamification visuals for the adult learner audience

## Visual Summary

If a future contributor needs a one-sentence brief:

Build `Familia Spanish` like a calm editorial iPhone app with serif headlines, SF Pro body text, currant actions, patina-green support accents, mineral parchment surfaces, and unmistakably tappable controls.
