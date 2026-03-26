# One-off helper to split UI/BlackListUI.lua into modules (run from repo root).
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "UI" / "BlackListUI.lua"
if not SRC.exists():
    # Fallback for regeneration when the monolithic file is not kept in-tree.
    _alt = ROOT.parent / "Toxic_BlackList - copia" / "BlackListUI.lua"
    if _alt.exists():
        SRC = _alt

SHARED_HEADER = '''--[[
  Shared layout state and helpers for Toxic BlackList UI (cross-file locals live on Addon.UI).
]]

local _, Addon = ...
local L = Addon.L

Addon.UI = Addon.UI or {}
local U = Addon.UI

local mp = Addon.MEDIA_PATH or "Interface\\\\AddOns\\\\Toxic_BlackList\\\\Media\\\\Images\\\\"

-- Globals kept for compatibility (Friends frame / scroll).
BLACKLISTS_TO_DISPLAY = 18
FRIENDS_FRAME_BLACKLIST_HEIGHT = 20
Classes = {"", "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"}
Races = {"", "Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Orc", "Undead", "Tauren", "Troll", "Blood Elf"}

U.selectedIndex = 1
U.optionsFrameWidth = 460
U.optionsCheckTextWidth = U.optionsFrameWidth - 56
U.optionsRowGap = 34
U.standaloneDoubleClickWindow = 0.35
U.standaloneListClickState = { t = 0, index = 0 }

U.standaloneIconBarBtn = 28
U.standaloneIconBarGap = 26
U.floatBtnSizeMin = 32
U.floatBtnSizeMax = 128
U.floatBtnDefaultSize = 64
U.standaloneIconTex = 24
U.iconBarTop = -54
U.iconBarShellPad = 6
U.listShellPad = 4
U.sectionBackdrop = {
	bgFile = "Interface\\\\ChatFrame\\\\ChatFrameBackground",
	edgeFile = "Interface\\\\Tooltips\\\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}
U.legendBottom = 10
U.legendRowH = 52
U.assetsPencil = mp .. "pencil.png"
U.assetsAim = mp .. "aim.png"
U.assetsIcon = mp .. "bl-icon.png"
U.assetsButton = mp .. "bl-button.png"

'''

CHUNK_HEADER = """local _, Addon = ...
local L = Addon.L
local U = Addon.UI

"""

REPLACEMENTS: list[tuple[str, str]] = [
	("CreateBlackListChromeParent", "U.createChromeParent"),
	("BlackListSafeStopMovingOrSizing", "U.safeStopMovingOrSizing"),
	("ReapplyBlackListPanelSize", "U.reapplyPanelSize"),
	("ScheduleReapplyBlackListPanelSize", "U.scheduleReapplyPanelSize"),
	("AnchorStandaloneDetailsFrame", "U.anchorStandaloneDetailsFrame"),
	("RegisterBlackListFrameEscClose", "U.registerEscClose"),
	("BlackListApplyStandaloneAtlasTexture", "U.applyStandaloneAtlasTexture"),
	("BlackListApplyStandaloneIconButtonHighlight", "U.applyStandaloneIconButtonHighlight"),
	("BlackListStyleStandaloneIconButton", "U.styleStandaloneIconButton"),
	("BlackListSetStandaloneIconTint", "U.setStandaloneIconTint"),
	("BlackListApplyStandaloneSectionBackdrop", "U.applyStandaloneSectionBackdrop"),
	("BlackListAddStandaloneIconBarDivider", "U.addStandaloneIconBarDivider"),
	("BlackListShowStandaloneHelpTooltip", "U.showStandaloneHelpTooltip"),
	("ApplyEPFListRowStyle", "U.applyEPFListRowStyle"),
	("CreateBlackListFrame", "U.createBlackListFrame"),
	("CreateBlackListHeader", "U.createBlackListHeader"),
	("CreateBlackListOption", "U.createBlackListOption"),
	("OPTIONS_FRAME_WIDTH", "U.optionsFrameWidth"),
	("OPTIONS_CHECK_TEXT_WIDTH", "U.optionsCheckTextWidth"),
	("OPTIONS_ROW_GAP", "U.optionsRowGap"),
	("STANDALONE_LIST_DOUBLE_CLICK_WINDOW", "U.standaloneDoubleClickWindow"),
	("standaloneListClickState", "U.standaloneListClickState"),
	("BLACKLIST_STANDALONE_ICON_BAR_BTN", "U.standaloneIconBarBtn"),
	("BLACKLIST_STANDALONE_ICON_BAR_GAP", "U.standaloneIconBarGap"),
	("BLACKLIST_FLOAT_BTN_SIZE_MIN", "U.floatBtnSizeMin"),
	("BLACKLIST_FLOAT_BTN_SIZE_MAX", "U.floatBtnSizeMax"),
	("BLACKLIST_FLOAT_BTN_DEFAULT_SIZE", "U.floatBtnDefaultSize"),
	("BLACKLIST_STANDALONE_ICON_TEX", "U.standaloneIconTex"),
	("STANDALONE_ICON_BAR_TOP", "U.iconBarTop"),
	("STANDALONE_ICON_BAR_SHELL_PAD", "U.iconBarShellPad"),
	("STANDALONE_LIST_SHELL_PAD", "U.listShellPad"),
	("STANDALONE_SECTION_BACKDROP", "U.sectionBackdrop"),
	("STANDALONE_LEGEND_BOTTOM", "U.legendBottom"),
	("STANDALONE_LEGEND_ROW_H", "U.legendRowH"),
	("BLACKLIST_ASSETS_PENCIL", "U.assetsPencil"),
	("BLACKLIST_ASSETS_AIM", "U.assetsAim"),
	("BLACKLIST_ASSETS_ICON", "U.assetsIcon"),
	("BLACKLIST_ASSETS_BUTTON", "U.assetsButton"),
]

DEF_REPLACEMENTS: list[tuple[str, str]] = [
	("local function BlackListApplyStandaloneAtlasTexture(", "function U.applyStandaloneAtlasTexture("),
	("local function BlackListApplyStandaloneIconButtonHighlight(", "function U.applyStandaloneIconButtonHighlight("),
	("local function BlackListStyleStandaloneIconButton(", "function U.styleStandaloneIconButton("),
	("local function BlackListSetStandaloneIconTint(", "function U.setStandaloneIconTint("),
	("local function BlackListApplyStandaloneSectionBackdrop(", "function U.applyStandaloneSectionBackdrop("),
	("local function BlackListAddStandaloneIconBarDivider(", "function U.addStandaloneIconBarDivider("),
	("local function BlackListShowStandaloneHelpTooltip(", "function U.showStandaloneHelpTooltip("),
	("local function ApplyEPFListRowStyle(", "function U.applyEPFListRowStyle("),
	("local function CreateBlackListChromeParent(", "function U.createChromeParent("),
	("local function BlackListSafeStopMovingOrSizing(", "function U.safeStopMovingOrSizing("),
	("local function ReapplyBlackListPanelSize(", "function U.reapplyPanelSize("),
	("local function ScheduleReapplyBlackListPanelSize(", "function U.scheduleReapplyPanelSize("),
	("local function AnchorStandaloneDetailsFrame(", "function U.anchorStandaloneDetailsFrame("),
	("local function RegisterBlackListFrameEscClose(", "function U.registerEscClose("),
	("local function CreateBlackListFrame(", "function U.createBlackListFrame("),
	("local function CreateBlackListHeader(", "function U.createBlackListHeader("),
	("local function CreateBlackListOption(", "function U.createBlackListOption("),
]


def apply_replacements(text: str) -> str:
	for a, b in DEF_REPLACEMENTS:
		text = text.replace(a, b)
	for a, b in REPLACEMENTS:
		text = text.replace(a, b)
	text = text.replace("SelectedIndex", "U.selectedIndex")
	return text


def slice_lines(lines: list[str], start: int, end: int) -> str:
	return "".join(lines[start - 1 : end])


def main() -> None:
	lines = SRC.read_text(encoding="utf-8").splitlines(keepends=True)

	# Shared: standalone helpers + chrome factory helpers + option row builders.
	# Excludes InitFriends (Chrome), resize/DBM skin methods (Chrome), float slider block (Chrome).
	shared_body = slice_lines(lines, 50, 186) + slice_lines(lines, 197, 290) + slice_lines(lines, 477, 509)
	shared_body = apply_replacements(shared_body)

	(ROOT / "UI" / "BlackListUI_Shared.lua").write_text(SHARED_HEADER + shared_body, encoding="utf-8")

	chunks: list[tuple[str, list[tuple[int, int]]]] = [
		# InitFriends + DBM chrome methods + floating controls (skip 475-510: option builders live in Shared).
		("BlackListUI_Chrome.lua", [(188, 190), (291, 474), (511, 688)]),
		("BlackListUI_OptionsDialog.lua", [(690, 1097)]),
		("BlackListUI_Standalone.lua", [(1099, 1506)]),
		("BlackListUI_Details.lua", [(1508, 1807)]),
		("BlackListUI_Friends.lua", [(1809, 1975)]),
		("BlackListUI_QuickButton.lua", [(1977, 2201)]),
	]

	for name, ranges in chunks:
		body = "".join(apply_replacements(slice_lines(lines, a, b)) for a, b in ranges)
		(ROOT / "UI" / name).write_text(CHUNK_HEADER + body, encoding="utf-8")

	print("OK:", SRC)


if __name__ == "__main__":
	main()
