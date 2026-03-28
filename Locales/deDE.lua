local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "deDE" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "Spieler ignoriert dich."
L["PLAYER_NOT_FOUND"] = "Spieler nicht gefunden."
L["ALREADY_BLACKLISTED"] = "ist bereits auf der schwarzen Liste."
L["ADDED_TO_BLACKLIST"] = "zur schwarzen Liste hinzugefügt."
L["BLACKLIST_MERGED_UPDATE"] = "Eintrag mit Realm und Details aktualisiert."
L["REMOVED_FROM_BLACKLIST"] = "von der schwarzen Liste entfernt."

-- ---------------------------------------------------------------------------
-- Shared labels (reuse everywhere — avoid duplicating the same translation)
-- ---------------------------------------------------------------------------

L["FACTION"] = "Fraktion"
L["UNKNOWN_FACTION"] = "Unbekannt"
L["TOXICITY"] = "Toxizität"
L["TOXICITY_HEADER"] = "Toxizität:"
L["TOXICITY_SKULLS_TOOLTIP"] = "Linksklick auf ein Symbol: Toxizität 1–10. Rechtsklick: löschen (0)."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Schwarze Liste"
L["CONTEXT_ADD_BLACKLIST"] = "Zur schwarzen Liste hinzufügen"
L["CONTEXT_REMOVE_BLACKLIST"] = "Von der schwarzen Liste entfernen"
L["LIST_MENU_EDIT"] = "Eintrag bearbeiten"
L["LIST_MENU_REMOVE"] = "Aus Liste entfernen"
L["SHARE_LIST_TOOLTIP"] = "Schwarze Liste exportieren oder importieren (Backup oder Teilen mit anderen Toxic-BlackList-Nutzern)."
L["EXPORT_FULL_MENU"] = "Gesamte Liste exportieren…"
L["IMPORT_LIST_MENU"] = "Liste importieren…"
L["EXPORT_DIALOG_TITLE"] = "Schwarze Liste exportieren"
L["IMPORT_DIALOG_TITLE"] = "Schwarze Liste importieren"
L["IMPORT_PASTE_HINT"] = "Vollständigen Export, Einzelexport oder eine Rohdatenzeile einfügen (Format wie eine Zeile aus dem Vollexport)."
L["IMPORT_MERGE"] = "Zusammenführen (Duplikate überspringen)"
L["IMPORT_REPLACE"] = "Gesamte Liste ersetzen"
L["IMPORT_REPLACE_WARN"] = "Die gesamte schwarze Liste durch die importierten Daten ersetzen? Nur rückgängig mit einem Backup-Export."
L["IMPORT_RESULT_FMT"] = "Import: %d hinzugefügt, %d übersprungen oder ungültig."
L["IMPORT_ERROR_BAD"] = "Import fehlgeschlagen."
L["ADD_DIALOG_REALM_LABEL"] = "Realm (optional)"
L["ADD_DIALOG_REALM_NOTE"] = "Realm-Namen werden nicht geprüft: Addons haben keine vollständige Realm-Liste von Blizzard. Exakten Namen verwenden (wie im Chat oder Gruppe). Leer lassen für einen generischen Namen-Eintrag, bis du den Spieler im Spiel triffst."
L["ADD_DIALOG_CLASS_LABEL"] = "Klasse"
L["ADD_DIALOG_CLASS_BUTTON"] = "Klasse: —"
L["BLACKLIST_PLAYER"] = "Spieler auf schwarze Liste setzen"
L["REMOVE_PLAYER"] = "Spieler entfernen"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "Entsperrt"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "Gesperrt"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "Dieser Eintrag ist gesperrt. Entsperre ihn in der Liste."
L["ADD_PLAYER_POPUP"] = "Nach Namen"
L["ADD_TARGET"] = "Ziel hinzufügen"
L["OPTIONS"] = "Optionen"
L["SHARE_LIST"] = "Liste teilen"
L["BLACK_LIST_DETAILS_TITLE"] = "Details: %s"
L["WINDOW_TITLE_EDIT"] = "Bearbeiten"
L["WINDOW_TITLE_ADD_PLAYER"] = "Spieler hinzufügen"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Stufe"
L["DETAILS_NO_INFO"] = "Keine Angaben"
L["DATE_ADDED_LABEL"] = "Hinzugefügt am:"
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

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Reason"
L["REASON"] = "Grund:"
L["IS_BLACKLISTED"] = "ist auf deiner schwarzen Liste."
L["BINDING_HEADER_BLACKLIST"] = "Schwarze Liste"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Schwarze Liste umschalten"
L["UNKNOWN_LEVEL_CLASS"] = "Unbekannte Stufe, Klasse"
L["UNKNOWN_LEVEL"] = "Unbekannte Stufe"
L["UNKNOWN_CLASS"] = "Unbekannte Klasse"
L["UNKNOWN_RACE"] = "Unbekannte Rasse"
L["ALLIANCE"] = "Allianz"
L["HORDE"] = "Horde"
L["UNKNOWN"] = "Unbekannt"
L["REALM_UNKNOWN"] = "Unbekannter Server"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Warnen, wenn mit der Maus über Spieler auf der schwarzen Liste gefahren wird"
L["WARN_NAMEPLATE"] = "Warnen, wenn eine nahe Namensplakette einem Spieler auf der schwarzen Liste gehört"
L["OPT_WARN_TARGETED_BY"] = "Warnen, wenn ein Spieler der schwarzen Liste dich anvisiert"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "Allgemein"
L["OPT_SECTION_COMMUNICATION"] = "Kommunikation"
L["OPT_SECTION_GROUP"] = "Gruppe"
L["OPT_SECTION_SOUND"] = "Ton"
L["OPT_TAB_GENERAL"] = "Allgemein"
L["OPT_TAB_SOUND"] = "Ton"
L["OPT_TAB_FLOATING"] = "Schaltfläche"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "Linksklick: Optionen öffnen"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "Rechtsklick: Liste öffnen"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Strg+Linksklick: Hinzufügen und bearbeiten"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Strg+Rechtsklick: Ziel hinzufügen"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+Ziehen: Verschieben"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "Schnellbutton auf dem Bildschirm"
L["OPT_FLOAT_BTN_SIZE"] = "Buttongröße (Breite × Höhe)"
L["OPT_FLOAT_BTN_RESET"] = "Position & Größe zurücksetzen"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "Warntöne abspielen"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Warnen bei Ziel auf Spieler der schwarzen Liste"
L["OPT_PREVENT_WHISPERS"] = "Flüstern von Spielern der schwarzen Liste blockieren"
L["OPT_WARN_WHISPERS"] = "Warnen, wenn Spieler der schwarzen Liste flüstern"
L["OPT_PREVENT_INVITES"] = "Einladungen von Spielern der schwarzen Liste verhindern"
L["OPT_PREVENT_MY_INVITES"] = "Eigene Einladungen an Spieler der schwarzen Liste verhindern"
L["OPT_MUTED_CHAT"] = "Nachrichten erlaubt"
L["OPT_MUTED_CHAT_UNMUTE"] = "Nachrichten ignoriert"
L["MUTED_CHECKBOX_LABEL"] = "Chat ignorieren"
L["OPT_WARN_PARTY_JOIN"] = "Warnen, wenn Spieler der schwarzen Liste der Gruppe beitreten"
L["OPT_MUTE_PROXIMITY_REST"] = "Warnungen in Städten deaktivieren"
L["TOOLTIP_EDIT_BTN"] = "Bearbeiten"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Schnellbutton auf dem Bildschirm"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "Linksklick: Ziel hinzufügen"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "Rechtsklick: Liste öffnen"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+Ziehen: Button verschieben"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+Rechtsklick: Optionen"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s und hat dir geflüstert."
L["MSG_PREVENT_MY_INVITE"] = "%s %s – Einladung nicht möglich."
L["MSG_DECLINED_PARTY_INVITE"] = "Gruppeneinladung von %s abgelehnt (schwarze Liste)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s und hat dich in eine Gruppe eingeladen."
L["PARTY_WARN_TITLE"] = "WARNUNG: Spieler der schwarzen Liste in deiner Gruppe!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent nicht gefunden; Flüsterfilter funktioniert evtl. nicht."
L["LOG_ERROR_IN"] = "FEHLER in %s:"
L["REASON_SAVED_FOR"] = "Grund gespeichert für %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "Linksklick: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "Rechtsklick: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "Linksklick: Optionen öffnen"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "Rechtsklick: Liste öffnen"
L["REASON_EDIT_HINT"] = "Fahre über eine Zeile für Details. Doppelklick zum Bearbeiten."
L["SORT_BY_TITLE"] = "Sortieren nach..."
L["SORT_DATE"] = "Datum"
L["SORT_NAME"] = "Name"
L["SORT_REALM"] = "Realm"
L["UNDO_DELETE"] = "Ruckgangig"
L["UNDO_NOTHING"] = "Nichts zum Ruckgangigmachen"
L["FILTER_PLACEHOLDER"] = "Filtern..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "Filter anzeigen"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "Filter ausblenden"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Befehle und Hilfe"
L["HELP_TITLE"] = "Schwarze Liste — Hilfe"
L["HELP_PANEL_TEXT"] = [[FENSTER
• Zeile mit der Maus anfahren: Tooltip mit allen Details.
• Doppelklick: Editor öffnen (Grund und Daten).

CHAT-BEFEHLE
/tbl — Öffnet dieses Fenster (ohne Argumente).

/tbla — Öffnet den Dialog zum Hinzufügen eines Spielers.

/tblr — Entfernt nach Namen. Ohne Argument: aktuelles Ziel entfernen.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Bearbeiten…"
L["STANDALONE_EDIT_TOOLTIP"] = "Öffnet den Editor für den ausgewählten Eintrag.\nDoppelklick funktioniert auch."
L["ROW_MENU_DELETE"] = "Entfernen"
L["BLACKLIST_POPUP_TEXT"] = "Felder: Spielername (Pflicht), optional Realm, Klasse, Toxizität (0–10) und Grund."
L["POPUP_NAME_EDIT_HINT"] = "Spielername"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "Ton wenn dich ein Spieler der schwarzen Liste anvisiert"
L["MSG_TARGETED_BY_WARN"] = "%s (schwarze Liste) hat dich anvisiert"
L["MSG_TAIL_TARGET_MOUSE"] = "steht auf deiner schwarzen Liste."
L["MSG_TAIL_NAMEPLATE"] = "von deiner schwarzen Liste ist in der Nähe."
L["MSG_TAIL_PARTY_GROUP"] = "von deiner schwarzen Liste ist in deiner Gruppe."
L["MSG_TAIL_TARGETED_BY"] = "von deiner schwarzen Liste hat dich anvisiert!"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "Dieses Panel enthält nur Optionen. Die Liste öffnest du mit /tbl oder über das Menü."
L["OPT_ALERT_SOUND"] = "Alert-Ton"
