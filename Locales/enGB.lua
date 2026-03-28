local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "enGB" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "Player is ignoring you."
L["PLAYER_NOT_FOUND"] = "Player not found."
L["ALREADY_BLACKLISTED"] = "is already blacklisted."
L["ADDED_TO_BLACKLIST"] = "added to blacklist."
L["BLACKLIST_MERGED_UPDATE"] = "Entry updated with realm and details."
L["REMOVED_FROM_BLACKLIST"] = "removed from blacklist."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Toxic BlackList"
L["CONTEXT_ADD_BLACKLIST"] = "Add to blacklist"
L["CONTEXT_REMOVE_BLACKLIST"] = "Remove from blacklist"
L["LIST_MENU_EDIT"] = "Edit entry"
L["LIST_MENU_REMOVE"] = "Remove from list"
L["LIST_MENU_TOXICITY"] = "Toxicity"
L["SHARE_LIST_TOOLTIP"] = "Export or import the blacklist for backup or sharing with other Toxic BlackList users."
L["EXPORT_FULL_MENU"] = "Export entire list…"
L["IMPORT_LIST_MENU"] = "Import list…"
L["EXPORT_DIALOG_TITLE"] = "Export blacklist"
L["IMPORT_DIALOG_TITLE"] = "Import blacklist"
L["IMPORT_PASTE_HINT"] = "Paste a full export, a single-entry export, or one raw data line (same format as a line from a full export)."
L["IMPORT_MERGE"] = "Merge (skip duplicates)"
L["IMPORT_REPLACE"] = "Replace entire list"
L["IMPORT_REPLACE_WARN"] = "Replace your entire blacklist with the imported data? This cannot be undone unless you have a backup export."
L["IMPORT_RESULT_FMT"] = "Import finished: %d added, %d skipped or invalid lines."
L["IMPORT_ERROR_BAD"] = "Import failed."
L["ADD_DIALOG_REALM_LABEL"] = "Realm (optional)"
L["ADD_DIALOG_REALM_NOTE"] = "Realm names are not validated: add-ons cannot query Blizzard's full realm list. Use the exact name (as shown in chat or group). Leave empty for a generic name-only entry until you meet the player in-game."
L["ADD_DIALOG_CLASS_LABEL"] = "Class"
L["ADD_DIALOG_CLASS_BUTTON"] = "Class: —"
L["ADD_DIALOG_TOXICITY_LABEL"] = "Toxicity"
L["ADD_DIALOG_TOXICITY_TOOLTIP"] = "Left-click: next value (0–10, wraps). Right-click: previous."
L["BLACKLIST_PLAYER"] = "Toxic BlackList Player"
L["REMOVE_PLAYER"] = "Remove Player"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "Unlocked"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "Locked"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "That entry is locked. Unlock it in the list before removing."
L["ADD_PLAYER_POPUP"] = "Add by name"
L["ADD_TARGET"] = "Add target"
L["OPTIONS"] = "Options"
L["SHARE_LIST"] = "Share List"
L["BLACK_LIST_DETAILS_TITLE"] = "Details: %s"
L["WINDOW_TITLE_EDIT"] = "Edit"
L["WINDOW_TITLE_ADD_PLAYER"] = "Add player"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Level"
L["DETAILS_NO_INFO"] = "No information"
L["DATE_ADDED_LABEL"] = "Date added:"
L["DATE_UPDATED_LABEL"] = "Last updated:"
L["PREFIX_ADDED"] = "Added:"
L["PREFIX_UPDATED"] = "Updated:"
L["DETAILS_REALM"] = "Realm"
L["DETAILS_GUILD"] = "Guild"
L["DETAILS_WINDOW_TITLE"] = "Details"
L["BUTTON_SAVE"] = "Save"
L["TOOLTIP_HINT_NAME_REALM"] = "Player name and realm"
L["TOOLTIP_HINT_GUILD"] = "Guild"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "Level, race and class"
L["TOOLTIP_HINT_FACTION"] = "Faction"
L["TOOLTIP_BL_TOXICITY_LABEL"] = "Toxicity:"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Reason"
L["REASON"] = "Reason:"
L["IS_BLACKLISTED"] = "is on your blacklist."
L["BINDING_HEADER_BLACKLIST"] = "Toxic BlackList"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Toggle Toxic BlackList"
L["UNKNOWN_LEVEL_CLASS"] = "Unknown Level, Class"
L["UNKNOWN_LEVEL"] = "Unknown Level"
L["UNKNOWN_CLASS"] = "Unknown Class"
L["UNKNOWN_RACE"] = "Unknown Race"
L["ALLIANCE"] = "Alliance"
L["HORDE"] = "Horde"
L["UNKNOWN"] = "Unknown"
L["REALM_UNKNOWN"] = "Unknown realm"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Warn when mousing over blacklisted players"
L["WARN_NAMEPLATE"] = "Warn when a nearby nameplate belongs to a blacklisted player"
L["OPT_WARN_TARGETED_BY"] = "Warn when a blacklisted player targets you"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "General Settings"
L["OPT_SECTION_COMMUNICATION"] = "Communication"
L["OPT_SECTION_GROUP"] = "Group Management"
L["OPT_SECTION_SOUND"] = "Sound"
L["OPT_TAB_GENERAL"] = "General"
L["OPT_TAB_SOUND"] = "Sound"
L["OPT_TAB_FLOATING"] = "Button"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "Left-click: Open options"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "Right-click: Open list"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+left-click: Add and edit"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+right-click: Add target"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+drag: Move"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "On-screen quick button"
L["OPT_FLOAT_BTN_SIZE"] = "Button size (width × height)"
L["OPT_FLOAT_BTN_RESET"] = "Reset position & size"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "Play sounds"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Warn when targeting blacklisted players"
L["OPT_PREVENT_WHISPERS"] = "Prevent whispers from blacklisted players"
L["OPT_WARN_WHISPERS"] = "Warn when blacklisted players whisper you"
L["OPT_PREVENT_INVITES"] = "Prevent blacklisted players from inviting you"
L["OPT_PREVENT_MY_INVITES"] = "Prevent yourself from inviting blacklisted players"
L["OPT_MUTED_CHAT"] = "Messages allowed"
L["OPT_MUTED_CHAT_UNMUTE"] = "Messages ignored"
L["MUTED_CHECKBOX_LABEL"] = "Ignore chat messages"
L["EVALUATION_SKULLS_LABEL"] = "Toxicity:"
L["EVALUATION_SKULLS_TOOLTIP"] = "Left-click an icon to set toxicity (1–10). Right-click to clear (0)."
L["OPT_WARN_PARTY_JOIN"] = "Warn when blacklisted players join your party"
L["OPT_MUTE_PROXIMITY_REST"] = "Disable alerts in cities"
L["TOOLTIP_EDIT_BTN"] = "Edit"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Show on-screen quick button"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "Left-click: Add target"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "Right-click: Open list"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+drag: Move button"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+right-click: Options"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s and whispered you."
L["MSG_PREVENT_MY_INVITE"] = "%s %s, preventing you from inviting them."
L["MSG_DECLINED_PARTY_INVITE"] = "Declined party invite from blacklisted player %s."
L["MSG_PARTY_INVITE_WARN"] = "%s %s and invited you to a party."
L["PARTY_WARN_TITLE"] = "WARNING: Blacklisted player in your party!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent not found; whisper filter may not work."
L["LOG_ERROR_IN"] = "ERROR in %s:"
L["REASON_SAVED_FOR"] = "Reason saved for %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "Left-click: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "Right-click: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "Left-click: Open options"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "Right-click: Open list"
L["REASON_EDIT_HINT"] = "Hover a row for details.\nDouble-click or use the edit button to open the editor."
L["SORT_BY_TITLE"] = "Sort by..."
L["SORT_DATE"] = "Date"
L["SORT_NAME"] = "Name"
L["SORT_REALM"] = "Realm"
L["SORT_FACTION"] = "Faction"
L["SORT_TOXICITY"] = "Toxicity"
L["UNDO_DELETE"] = "Undo"
L["UNDO_NOTHING"] = "Nothing to undo"
L["FILTER_PLACEHOLDER"] = "Filter..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "Show filter"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "Hide filter"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Commands and help"
L["HELP_TITLE"] = "Toxic BlackList — Help"
L["HELP_PANEL_TEXT"] = [[LIST WINDOW
• Hover a row to see full details in
the tooltip.
• Double-click a row or use the edit button to open the editor
(reason and data).

CHAT COMMANDS
/tbl — Opens this window (no arguments).

/tbla — Opens the add-player dialog.

/tblr — Removes by player name. With no argument: removes your current target.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Edit…"
L["STANDALONE_EDIT_TOOLTIP"] = "Opens the editor for the selected entry.\nYou can also double-click a row."
L["ROW_MENU_DELETE"] = "Remove"
L["BLACKLIST_POPUP_TEXT"] = "Use the fields below: player name (required), optional realm, class, toxicity (0–10), and reason."
L["POPUP_NAME_EDIT_HINT"] = "Player name"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "Sound when a blacklisted player targets you"
L["MSG_TARGETED_BY_WARN"] = "%s has targeted you (blacklisted)"
L["MSG_TAIL_TARGET_MOUSE"] = "is on your blacklist."
L["MSG_TAIL_NAMEPLATE"] = "from your blacklist is nearby."
L["MSG_TAIL_PARTY_GROUP"] = "from your blacklist is in your group."
L["MSG_TAIL_TARGETED_BY"] = "from your blacklist has you targeted!"
L["OPT_SOUND_TEST"] = "Test"

-- ---------------------------------------------------------------------------
-- Sound — preset names
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_PVP_QUEUE"] = "PVP queue (default alert)"
L["SOUND_PRESET_RAID_WARNING"] = "Raid warning"
L["SOUND_PRESET_READY_CHECK"] = "Ready check"
L["SOUND_PRESET_RAID_BOSS_EMOTE"] = "Raid boss emote warning"
L["SOUND_PRESET_ALARM"] = "Alarm clock"
L["SOUND_PRESET_GM_WARNING"] = "GM chat warning"
L["SOUND_PRESET_RAID_BOSS_WHISPER"] = "Raid boss whisper"
L["SOUND_PRESET_TELL"] = "Tell / whisper notification"
L["SOUND_PRESET_BNET_TOAST"] = "Battle.net toast"
L["SOUND_PRESET_LOSS_OF_CONTROL"] = "Loss of control"

-- ---------------------------------------------------------------------------
-- Settings panel (Esc menu)
-- ---------------------------------------------------------------------------

L["SETTINGS_HINT_OPTIONS_ONLY"] = "This panel only contains options. Open the list with /tbl or the game menu."
L["OPT_ALERT_SOUND"] = "Alert sound"
