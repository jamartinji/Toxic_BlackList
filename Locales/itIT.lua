local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "itIT" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "Il giocatore ti sta ignorando."
L["PLAYER_NOT_FOUND"] = "Giocatore non trovato."
L["ALREADY_BLACKLISTED"] = "è già in lista nera."
L["ADDED_TO_BLACKLIST"] = "aggiunto alla lista nera."
L["BLACKLIST_MERGED_UPDATE"] = "Voce aggiornata con reame e dettagli."
L["REMOVED_FROM_BLACKLIST"] = "rimosso dalla lista nera."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Lista nera"
L["CONTEXT_ADD_BLACKLIST"] = "Aggiungi alla lista nera"
L["CONTEXT_REMOVE_BLACKLIST"] = "Rimuovi dalla lista nera"
L["BLACKLIST_PLAYER"] = "Aggiungi giocatore"
L["REMOVE_PLAYER"] = "Rimuovi giocatore"
L["ADD_PLAYER_POPUP"] = "Aggiungi per nome"
L["ADD_TARGET"] = "Aggiungi bersaglio"
L["OPTIONS"] = "Opzioni"
L["SHARE_LIST"] = "Condividi elenco"
L["BLACK_LIST_DETAILS_TITLE"] = "Dettagli: %s"
L["WINDOW_TITLE_EDIT"] = "Modifica"
L["WINDOW_TITLE_ADD_PLAYER"] = "Aggiungi per nome"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Livello"
L["DETAILS_NO_INFO"] = "Nessuna informazione"
L["DATE_ADDED_LABEL"] = "Data aggiunta:"
L["DATE_UPDATED_LABEL"] = "Ultimo aggiornamento:"
L["PREFIX_ADDED"] = "Aggiunto:"
L["PREFIX_UPDATED"] = "Aggiornato:"
L["DETAILS_REALM"] = "Reame"
L["DETAILS_GUILD"] = "Gilda"
L["DETAILS_WINDOW_TITLE"] = "Dettagli"
L["BUTTON_SAVE"] = "Salva"
L["TOOLTIP_HINT_NAME_REALM"] = "Nome del giocatore e reame"
L["TOOLTIP_HINT_GUILD"] = "Gilda"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "Livello, razza e classe"
L["TOOLTIP_HINT_FACTION"] = "Fazione"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Motivo"
L["REASON"] = "Motivo:"
L["IS_BLACKLISTED"] = "è nella tua lista nera."
L["BINDING_HEADER_BLACKLIST"] = "Lista nera"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Mostra lista nera"
L["UNKNOWN_LEVEL_CLASS"] = "Livello e classe sconosciuti"
L["UNKNOWN_LEVEL"] = "Livello sconosciuto"
L["UNKNOWN_CLASS"] = "Classe sconosciuta"
L["UNKNOWN_RACE"] = "Razza sconosciuta"
L["ALLIANCE"] = "Alleanza"
L["HORDE"] = "Orda"
L["UNKNOWN"] = "Sconosciuto"
L["REALM_UNKNOWN"] = "Reame sconosciuto"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Avvisa passando il mouse sui giocatori in lista nera"
L["WARN_NAMEPLATE"] = "Avvisa se una targhetta vicina appartiene a un giocatore in lista nera"
L["OPT_WARN_TARGETED_BY"] = "Avvisa quando un giocatore in lista nera ti prende di mira"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "Impostazioni generali"
L["OPT_SECTION_COMMUNICATION"] = "Comunicazione"
L["OPT_SECTION_GROUP"] = "Gruppo"
L["OPT_SECTION_SOUND"] = "Suono"
L["OPT_TAB_GENERAL"] = "Generale"
L["OPT_TAB_SOUND"] = "Suono"
L["OPT_TAB_FLOATING"] = "Pulsante"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "Clic sinistro: opzioni"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "Clic destro: apri elenco"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+clic sinistro: aggiungi e modifica"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+clic destro: aggiungi bersaglio"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+trascina: sposta"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "Pulsante rapido sullo schermo"
L["OPT_FLOAT_BTN_SIZE"] = "Dimensione pulsante (larghezza × altezza)"
L["OPT_FLOAT_BTN_RESET"] = "Ripristina posizione e dimensione"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "Nessun suono"
L["OPT_PLAY_SOUNDS"] = "Riproduci suoni di avviso"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Avvisa quando bersagli un giocatore in lista nera"
L["OPT_PREVENT_WHISPERS"] = "Blocca i sussurri dai giocatori in lista nera"
L["OPT_WARN_WHISPERS"] = "Avvisa quando un giocatore in lista nera ti sussurra"
L["OPT_PREVENT_INVITES"] = "Impedisci inviti al gruppo da giocatori in lista nera"
L["OPT_PREVENT_MY_INVITES"] = "Impedisci di invitare giocatori in lista nera"
L["OPT_MUTED_CHAT"] = "Silenzia la chat di questo giocatore"
L["OPT_WARN_PARTY_JOIN"] = "Avvisa quando un giocatore in lista nera entra nel gruppo"
L["OPT_MUTE_PROXIMITY_REST"] = "Disattiva avvisi in città"
L["TOOLTIP_EDIT_BTN"] = "Modifica"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Mostra pulsante rapido sullo schermo"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "Clic sinistro: aggiungi bersaglio"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "Clic destro: apri lista"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+trascina: sposta pulsante"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+clic destro: opzioni"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s e ti ha sussurrato."
L["MSG_PREVENT_MY_INVITE"] = "%s %s: non puoi invitarlo."
L["MSG_DECLINED_PARTY_INVITE"] = "Invito al gruppo rifiutato da %s (lista nera)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s ti ha invitato in un gruppo."
L["PARTY_WARN_TITLE"] = "ATTENZIONE: c'è un giocatore in lista nera nel tuo gruppo!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent non trovato; il filtro sussurri potrebbe non funzionare."
L["LOG_ERROR_IN"] = "ERRORE in %s:"
L["REASON_SAVED_FOR"] = "Motivo salvato per %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "Clic sinistro: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "Clic destro: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "Clic sinistro: apri opzioni"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "Clic destro: apri elenco"
L["REASON_EDIT_HINT"] = "Passa il mouse su una riga per i dettagli. Doppio clic per modificare."

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Comandi e guida"
L["HELP_TITLE"] = "Lista nera — Guida"
L["HELP_PANEL_TEXT"] = [[FINESTRA ELENCO
• Passa il mouse su una riga per vedere tutti i dettagli nel tooltip.
• Doppio clic su una riga per aprire l'editor (motivo e dati).

COMANDI CHAT
/tbl — Apre questa finestra (senza argomenti).

/tbla — Apre la finestra per aggiungere un giocatore.

/tblr — Rimuove per nome. Senza argomenti: rimuove il bersaglio attuale.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Modifica…"
L["STANDALONE_EDIT_TOOLTIP"] = "Apre l'editor per la riga selezionata.\nPuoi anche fare doppio clic."
L["ROW_MENU_DELETE"] = "Rimuovi"
L["BLACKLIST_POPUP_TEXT"] = "Compila i campi sotto: nome del giocatore (obbligatorio) e motivo (facoltativo)."
L["POPUP_NAME_EDIT_HINT"] = "Nome del giocatore"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Suono di avviso con bersaglio"
L["OPT_SOUND_MOUSEOVER"] = "Suono di avviso al passaggio del mouse"
L["OPT_SOUND_NAMEPLATE"] = "Suono di avviso con targhetta vicina"
L["OPT_RAID_SOUND"] = "Suono di avviso in gruppo / incursione"
L["OPT_SOUND_TARGETED_BY"] = "Suono se un giocatore in lista nera ti prende di mira"
L["MSG_TARGETED_BY_WARN"] = "%s della lista nera ti ha preso di mira"
L["MSG_TAIL_TARGET_MOUSE"] = "è nella tua lista nera."
L["MSG_TAIL_NAMEPLATE"] = "della lista nera è vicino"
L["MSG_TAIL_PARTY_GROUP"] = "della lista nera è nel tuo gruppo"
L["MSG_TAIL_TARGETED_BY"] = "della lista nera ti ha preso di mira!"
L["OPT_SOUND_TEST"] = "Prova"

-- ---------------------------------------------------------------------------
-- Sound — preset names
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_PVP_QUEUE"] = "Coda PvP (avviso predefinito)"
L["SOUND_PRESET_RAID_WARNING"] = "Avviso incursione"
L["SOUND_PRESET_READY_CHECK"] = "Controllo disponibilità"
L["SOUND_PRESET_RAID_BOSS_EMOTE"] = "Avviso emote del boss"
L["SOUND_PRESET_ALARM"] = "Sveglia"
L["SOUND_PRESET_GM_WARNING"] = "Avviso chat GM"
L["SOUND_PRESET_RAID_BOSS_WHISPER"] = "Sussurro del boss"
L["SOUND_PRESET_TELL"] = "Notifica sussurro"
L["SOUND_PRESET_BNET_TOAST"] = "Notifica Battle.net"
L["SOUND_PRESET_LOSS_OF_CONTROL"] = "Perdita di controllo"

-- ---------------------------------------------------------------------------
-- Settings panel (Esc menu)
-- ---------------------------------------------------------------------------

L["SETTINGS_HINT_OPTIONS_ONLY"] = "Questo pannello contiene solo le opzioni. L'elenco si apre con /tbl o dal menu."
L["OPT_ALERT_SOUND"] = "Suono di avviso"
