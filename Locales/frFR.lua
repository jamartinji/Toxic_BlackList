local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "frFR" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "Le joueur vous ignore."
L["PLAYER_NOT_FOUND"] = "Joueur introuvable."
L["ALREADY_BLACKLISTED"] = "est déjà sur liste noire."
L["ADDED_TO_BLACKLIST"] = "ajouté à la liste noire."
L["BLACKLIST_MERGED_UPDATE"] = "Entrée mise à jour avec le royaume et les détails."
L["REMOVED_FROM_BLACKLIST"] = "retiré de la liste noire."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Liste noire"
L["CONTEXT_ADD_BLACKLIST"] = "Ajouter à la liste noire"
L["CONTEXT_REMOVE_BLACKLIST"] = "Retirer de la liste noire"
L["LIST_MENU_EDIT"] = "Modifier l'entrée"
L["LIST_MENU_REMOVE"] = "Retirer de la liste"
L["LIST_MENU_TOXICITY"] = "Toxicité"
L["SHARE_LIST_TOOLTIP"] = "Exporter ou importer la liste noire (sauvegarde ou partage avec d’autres utilisateurs de Toxic BlackList)."
L["EXPORT_FULL_MENU"] = "Exporter toute la liste…"
L["IMPORT_LIST_MENU"] = "Importer une liste…"
L["EXPORT_DIALOG_TITLE"] = "Exporter la liste noire"
L["IMPORT_DIALOG_TITLE"] = "Importer la liste noire"
L["IMPORT_PASTE_HINT"] = "Collez un export complet, un export d’une entrée ou une ligne brute (même format qu’une ligne d’export complet)."
L["IMPORT_MERGE"] = "Fusionner (ignorer les doublons)"
L["IMPORT_REPLACE"] = "Remplacer toute la liste"
L["IMPORT_REPLACE_WARN"] = "Remplacer toute votre liste noire par les données importées ? Irréversible sans export de sauvegarde."
L["IMPORT_RESULT_FMT"] = "Import : %d ajoutés, %d ignorés ou lignes invalides."
L["IMPORT_ERROR_BAD"] = "Échec de l’import."
L["ADD_DIALOG_REALM_LABEL"] = "Royaume (facultatif)"
L["ADD_DIALOG_REALM_NOTE"] = "Les royaumes ne sont pas vérifiés : les addons n’ont pas la liste complète Blizzard. Utilisez le nom exact (chat ou groupe). Laissez vide pour une entrée nom seul jusqu’à croiser le joueur en jeu."
L["ADD_DIALOG_CLASS_LABEL"] = "Classe"
L["ADD_DIALOG_CLASS_BUTTON"] = "Classe : —"
L["ADD_DIALOG_TOXICITY_LABEL"] = "Toxicité"
L["ADD_DIALOG_TOXICITY_TOOLTIP"] = "Clic gauche : valeur suivante (0–10, boucle). Clic droit : précédente."
L["BLACKLIST_PLAYER"] = "Mettre le joueur sur liste noire"
L["REMOVE_PLAYER"] = "Retirer le joueur"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "Déverrouillé"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "Verrouillé"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "Cette entrée est verrouillée. Déverrouillez-la dans la liste avant de retirer."
L["ADD_PLAYER_POPUP"] = "Ajouter par nom"
L["ADD_TARGET"] = "Ajouter la cible"
L["OPTIONS"] = "Options"
L["SHARE_LIST"] = "Partager la liste"
L["BLACK_LIST_DETAILS_TITLE"] = "Détails : %s"
L["WINDOW_TITLE_EDIT"] = "Modifier"
L["WINDOW_TITLE_ADD_PLAYER"] = "Ajouter un joueur"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Niveau"
L["DETAILS_NO_INFO"] = "Aucune information"
L["DATE_ADDED_LABEL"] = "Date d'ajout :"
L["DATE_UPDATED_LABEL"] = "Dernière mise à jour :"
L["PREFIX_ADDED"] = "Ajouté :"
L["PREFIX_UPDATED"] = "Mis à jour :"
L["DETAILS_REALM"] = "Royaume"
L["DETAILS_GUILD"] = "Guilde"
L["DETAILS_WINDOW_TITLE"] = "Détails"
L["BUTTON_SAVE"] = "Enregistrer"
L["TOOLTIP_HINT_NAME_REALM"] = "Nom du joueur et royaume"
L["TOOLTIP_HINT_GUILD"] = "Guilde"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "Niveau, race et classe"
L["TOOLTIP_HINT_FACTION"] = "Faction"
L["TOOLTIP_BL_TOXICITY_LABEL"] = "Toxicité :"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Raison"
L["REASON"] = "Raison:"
L["IS_BLACKLISTED"] = "est sur votre liste noire."
L["BINDING_HEADER_BLACKLIST"] = "Liste noire"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Basculer la liste noire"
L["UNKNOWN_LEVEL_CLASS"] = "Niveau, Classe inconnus"
L["UNKNOWN_LEVEL"] = "Niveau inconnu"
L["UNKNOWN_CLASS"] = "Classe inconnue"
L["UNKNOWN_RACE"] = "Race inconnue"
L["ALLIANCE"] = "Alliance"
L["HORDE"] = "Horde"
L["UNKNOWN"] = "Inconnu"
L["REALM_UNKNOWN"] = "Royaume inconnu"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Avertir lors du survol de joueurs sur la liste noire"
L["WARN_NAMEPLATE"] = "Avertir lorsqu'une plaque de nom proche appartient à un joueur sur la liste noire"
L["OPT_WARN_TARGETED_BY"] = "Avertir quand un joueur sur la liste noire vous cible"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "Général"
L["OPT_SECTION_COMMUNICATION"] = "Communication"
L["OPT_SECTION_GROUP"] = "Groupe"
L["OPT_SECTION_SOUND"] = "Sons"
L["OPT_TAB_GENERAL"] = "Général"
L["OPT_TAB_SOUND"] = "Sons"
L["OPT_TAB_FLOATING"] = "Bouton"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "Clic gauche : options"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "Clic droit : ouvrir la liste"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+clic gauche : ajouter et modifier"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+clic droit : ajouter la cible"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+glisser : déplacer"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "Bouton rapide à l'écran"
L["OPT_FLOAT_BTN_SIZE"] = "Taille du bouton (largeur × hauteur)"
L["OPT_FLOAT_BTN_RESET"] = "Réinitialiser position et taille"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "Jouer les sons d'alerte"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Avertir en ciblant un joueur sur la liste noire"
L["OPT_PREVENT_WHISPERS"] = "Bloquer les chuchotements des joueurs sur la liste noire"
L["OPT_WARN_WHISPERS"] = "Avertir quand un joueur sur la liste noire vous chuchote"
L["OPT_PREVENT_INVITES"] = "Empêcher les invitations des joueurs sur la liste noire"
L["OPT_PREVENT_MY_INVITES"] = "Empêcher d'inviter des joueurs sur la liste noire"
L["OPT_MUTED_CHAT"] = "Messages autorisés"
L["OPT_MUTED_CHAT_UNMUTE"] = "Messages ignorés"
L["MUTED_CHECKBOX_LABEL"] = "Ignorer le chat"
L["EVALUATION_SKULLS_LABEL"] = "Toxicité :"
L["EVALUATION_SKULLS_TOOLTIP"] = "Clic gauche sur une icône : toxicité 1–10. Clic droit : effacer (0)."
L["OPT_WARN_PARTY_JOIN"] = "Avertir quand un joueur sur la liste noire rejoint votre groupe"
L["OPT_MUTE_PROXIMITY_REST"] = "Désactiver les alertes en ville"
L["TOOLTIP_EDIT_BTN"] = "Modifier"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Afficher le bouton rapide a l'ecran"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "Clic gauche : ajouter cible"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "Clic droit : ouvrir liste"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+glisser : deplacer bouton"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+clic droit : options"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s et vous a chuchoté."
L["MSG_PREVENT_MY_INVITE"] = "%s %s — invitation impossible."
L["MSG_DECLINED_PARTY_INVITE"] = "Invitation de groupe refusée (%s, liste noire)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s et vous a invité dans un groupe."
L["PARTY_WARN_TITLE"] = "ATTENTION : un joueur sur la liste noire est dans votre groupe !"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent introuvable ; le filtre des chuchotements peut échouer."
L["LOG_ERROR_IN"] = "ERREUR dans %s :"
L["REASON_SAVED_FOR"] = "Raison enregistrée pour %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "Clic gauche : %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "Clic droit : %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "Clic gauche : ouvrir les options"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "Clic droit : ouvrir la liste"
L["REASON_EDIT_HINT"] = "Survolez une ligne pour les détails. Double-clic pour modifier."
L["SORT_BY_TITLE"] = "Trier par..."
L["SORT_DATE"] = "Date"
L["SORT_NAME"] = "Nom"
L["SORT_REALM"] = "Royaume"
L["SORT_FACTION"] = "Faction"
L["SORT_TOXICITY"] = "Toxicité"
L["UNDO_DELETE"] = "Annuler"
L["UNDO_NOTHING"] = "Rien a annuler"
L["FILTER_PLACEHOLDER"] = "Filtrer..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "Afficher le filtre"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "Masquer le filtre"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Commandes et aide"
L["HELP_TITLE"] = "Liste noire — Aide"
L["HELP_PANEL_TEXT"] = [[FENÊTRE
• Survolez une ligne pour voir tous les détails dans l'infobulle.
• Double-clic sur une ligne pour ouvrir l'éditeur (raison et données).

COMMANDES
/tbl — Ouvre cette fenêtre (sans argument).

/tbla — Ouvre la boîte d’ajout de joueur.

/tblr — Retire par nom. Sans argument : retire la cible actuelle.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Modifier…"
L["STANDALONE_EDIT_TOOLTIP"] = "Ouvre l'éditeur pour la ligne sélectionnée.\nVous pouvez aussi double-cliquer."
L["ROW_MENU_DELETE"] = "Retirer"
L["BLACKLIST_POPUP_TEXT"] = "Champs : nom (obligatoire), royaume facultatif, classe, toxicité (0–10) et raison."
L["POPUP_NAME_EDIT_HINT"] = "Nom du joueur"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "Son quand un joueur sur la liste noire vous cible"
L["MSG_TARGETED_BY_WARN"] = "%s (liste noire) vous prend pour cible"
L["MSG_TAIL_TARGET_MOUSE"] = "est sur votre liste noire."
L["MSG_TAIL_NAMEPLATE"] = "de votre liste noire est à proximité."
L["MSG_TAIL_PARTY_GROUP"] = "de votre liste noire est dans votre groupe."
L["MSG_TAIL_TARGETED_BY"] = "de votre liste noire vous cible !"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "Ce panneau ne contient que des options. Ouvrez la liste avec /tbl ou le menu."
L["OPT_ALERT_SOUND"] = "Son d'alerte"
