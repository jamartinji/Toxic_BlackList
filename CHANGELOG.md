# Changelog

All notable changes to **Toxic BlackList** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-03-28

### Added

- **Friends → Recent Allies:** context-menu actions to add or remove players from the blacklist.
- **Nameplate and menu resolution:** more reliable name/realm when the game gives little data or across realms.
- **Row lock** on the standalone list so an entry cannot be removed until you unlock it.
- **Chat mute** per entry (toggle in the edit panel and on list rows).
- **Toxicity level** (0–10) on entries.
- **Game tooltips** (e.g. mouseover/target) can show toxicity for players on your blacklist when their saved score is above zero.
- **Floating quick button:** Ctrl+left-click with **no** player target opens the add-player dialog; with a **player** target, adds if needed and opens the editor.

### Changed

- **Faction** is stored with stable internal IDs (Alliance/Horde). Existing entries are updated when you load; changing the client language no longer drops faction display for old saves that used localized text.

### Fixed

- Wrong player details in some edge cases.
- Add-by-target and add-by-name failing in some situations.

## [1.1.0] - 2026-03-27

### Added

- Standalone list sorting (header/row menu): **date**, **name**, **realm**, **faction**, ascending or descending.
- **Undo** button for recent deletions in the list window.
- List **search** improvements: toggle, placeholder text, filter tooltips.
- Top decoration on standalone windows.

### Changed

- With the editor open, clicking another list row switches the edited player.
- Row visuals for manual/incomplete entries; tooltip styling (faction-colored border/background, trims reset when the tooltip closes).
- Spacing in the list window, add-by-name dialog, and details panel.

### Fixed

- Several visual alignment issues.

## [1.0.3] - 2026-03-27

### Fixed

- Errors when using **nameplates** or **“targeting you”** alerts.

## [1.0.2] - 2026-03-26

### Added

- Edit window: **info** control (same row as Save) with a tooltip for added/updated dates; slightly wider default panel.

### Fixed

- **Sounds** respect the game’s sound option and restore correctly after being muted by migration.
- **Nameplate** proximity checks run more reliably right when a plate appears.

## [1.0.1] - 2026-03-26

### Fixed

- Standalone **list** window uses the same frame chrome (title/border) as Options and Edit.
