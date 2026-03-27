# Changelog

All notable changes to **Toxic BlackList** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-03-27

### Added

- Context menu entries on **Friends → Recent Allies** (online and offline), same add/remove blacklist flow as target and LFG menus (`MENU_UNIT_RECENT_ALLY`, `MENU_UNIT_RECENT_ALLY_OFFLINE`).
- Name/realm resolution for context and nameplates: **`GetPlayerInfoByGUID` with raw GUID** when string copy fails; **`UnitNameUnmodified`** as first try on nameplates; class/race fallback from `recentAllyData.characterData` when needed.

### Changed

- **Retail “secret” API values (Midnight / 12.x):** safe handling for secret GUIDs (plain copy before `strsub`), secret booleans from `UnitExists` / `UnitIsUnit` / `UnitIsPlayer` without comparing to `true`/`false`, and `apiBoolIsTrue` that returns plain Lua booleans only.
- **Nameplate proximity:** resolve **name and realm before** the strict “is another player” check so hostile / opposite-faction nameplates still match the list when `UnitIsPlayer` or GUID prefix checks are unreliable.
- **Standalone list:** unknown-faction row icon (`QuestLegendaryTurnin`) anchor nudged left to align with faction badges; Alliance/Horde icons explicitly re-anchored after size changes.
- Startup errors from `BlackList_RunStep` still surface in chat (red text); verbose `BlackList.Log` / `BlackListDebugLog` toggle removed.

### Removed

- Temporary nearby-player experiment module and related XML load.
- Chat spam from optional debug logging (`/run BlackListDebugLog` workflow).

### Fixed

- `GetPlayerInfoByGUID` return values: **name** is the 6th return (was shifted in one path).
- Stale “RegisterEvents: frame missing” log when the top frame is absent.

## [1.1.0] - 2026-03-27

### Added

- Standalone list sorting context menu (right click on row): **Date**, **Name**, **Realm**, **Faction** with ascending/descending toggle.
- Standalone **Undo** action button to restore recent deletions.
- Standalone list search UX improvements: toggle button, hide/show search bar behavior, localized placeholder text and filter toggle tooltips.
- UI decoration framework for top trims on standalone windows.

### Changed

- Standalone list interactions refined:
  - when editor is already open, clicking another row switches the editor view.
- Standalone row visuals updated:
  - unknown/manual entries now use a dedicated icon style and sizing.
- Tooltip styling refined:
  - faction-colored border/background behavior updated,
  - top and bottom decorative trims added/tuned and reset safely when tooltip closes.
- Standalone window chrome/layout pass:
  - tighter top spacing,
  - icon bar spacing and ordering adjustments,
- Add-by-name dialog layout adjusted with cleaner vertical spacing around reason box and action buttons.
- Details window styling updated:
  - top trim decoration added.

### Fixed

- Multiple visual alignments.

## [1.0.3] - 2026-03-27

### Fixed

- **secret-value taint**: Avoid comparing raw realm strings from `UnitName` / `GetRealmName` and avoid boolean tests on API results (`UnitExists`, `UnitIsPlayer`, `UnitIsUnit`) in `CollectPlayerFieldsFromUnit`, proximity/nameplate scans, and context-menu unit resolution — prevents Lua errors when nameplates or “targeting you” alerts run.

## [1.0.2] - 2026-03-26

### Added

- **Standalone edit window**: Info icon (bottom-left, same row as Save) with a tooltip showing Added/Updated dates (same gray text as before); default panel size slightly increased.

### Fixed

- **Sounds**: Respect **Play sounds** in `PlaySoundForKind`; restore per-context presets when re-enabling sounds after they were muted by migration (`_blSoundMutedByPlaySoundsOff`); optional login restore.
- **Sounds**: Defer preset playback by one frame (`C_Timer.After(0)`) so SFX from OnUpdate/combat paths are not blocked.
- **Nameplate proximity**: `NAME_PLATE_UNIT_ADDED` can fire before the unit is valid — schedule checks at 0s and 0.05s; resolve name/realm with `UnitFullName` / `UnitName` and `FindEntryIndexForUnit` for cross-realm matches.


## [1.0.1] - 2026-03-26

### Fixed

- **Standalone list window**: Restored the style frame chrome (NineSlice / `ButtonFrameTemplateNoPortrait`) so the title bar and border match the Options and Edit windows again.
