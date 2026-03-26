local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "esMX" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "El jugador te está ignorando."
L["PLAYER_NOT_FOUND"] = "Jugador no encontrado."
L["ALREADY_BLACKLISTED"] = "ya está en la lista negra."
L["ADDED_TO_BLACKLIST"] = "añadido a la lista negra."
L["BLACKLIST_MERGED_UPDATE"] = "Entrada actualizada con reino y datos."
L["REMOVED_FROM_BLACKLIST"] = "eliminado de la lista negra."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Lista Negra"
L["CONTEXT_ADD_BLACKLIST"] = "Agregar a la lista negra"
L["CONTEXT_REMOVE_BLACKLIST"] = "Quitar de la lista negra"
L["BLACKLIST_PLAYER"] = "Jugador a la Lista Negra"
L["REMOVE_PLAYER"] = "Eliminar Jugador"
L["ADD_PLAYER_POPUP"] = "Añadir por nombre"
L["ADD_TARGET"] = "Añadir objetivo"
L["OPTIONS"] = "Opciones"
L["SHARE_LIST"] = "Compartir Lista"
L["BLACK_LIST_DETAILS_TITLE"] = "Detalles: %s"
L["WINDOW_TITLE_EDIT"] = "Editar"
L["WINDOW_TITLE_ADD_PLAYER"] = "Añadir por nombre"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Nivel"
L["DETAILS_NO_INFO"] = "Sin información"
L["DATE_ADDED_LABEL"] = "Fecha Añadido:"
L["DATE_UPDATED_LABEL"] = "Última actualización:"
L["PREFIX_ADDED"] = "Añadido:"
L["PREFIX_UPDATED"] = "Actualizado:"
L["DETAILS_REALM"] = "Reino"
L["DETAILS_GUILD"] = "Hermandad"
L["DETAILS_WINDOW_TITLE"] = "Detalles"
L["BUTTON_SAVE"] = "Guardar"
L["TOOLTIP_HINT_NAME_REALM"] = "Nombre del jugador y reino"
L["TOOLTIP_HINT_GUILD"] = "Hermandad"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "Nivel, raza y clase"
L["TOOLTIP_HINT_FACTION"] = "Facción"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Razón"
L["REASON"] = "Razón:"
L["IS_BLACKLISTED"] = "está en tu lista negra."
L["BINDING_HEADER_BLACKLIST"] = "Lista Negra"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Alternar Lista Negra"
L["UNKNOWN_LEVEL_CLASS"] = "Nivel y Clase desconocidos"
L["UNKNOWN_LEVEL"] = "Nivel desconocido"
L["UNKNOWN_CLASS"] = "Clase desconocida"
L["UNKNOWN_RACE"] = "Raza desconocida"
L["ALLIANCE"] = "Alianza"
L["HORDE"] = "Horda"
L["UNKNOWN"] = "Desconocido"
L["REALM_UNKNOWN"] = "Reino desconocido"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Avisar al pasar el ratón sobre jugadores en la lista negra"
L["WARN_NAMEPLATE"] = "Avisar cuando una placa de nombre cercana sea de un jugador en la lista negra"
L["OPT_WARN_TARGETED_BY"] = "Avisar cuando un jugador de la lista negra te tenga como objetivo"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "Ajustes generales"
L["OPT_SECTION_COMMUNICATION"] = "Comunicación"
L["OPT_SECTION_GROUP"] = "Grupo"
L["OPT_SECTION_SOUND"] = "Sonido"
L["OPT_TAB_GENERAL"] = "General"
L["OPT_TAB_SOUND"] = "Sonido"
L["OPT_TAB_FLOATING"] = "Botón"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "Clic izquierdo: Opciones"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "Clic derecho: Abrir lista"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+clic izquierdo: Añadir y editar"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+clic derecho: Añadir objetivo"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+arrastrar: Mover"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "Botón rápido en pantalla"
L["OPT_FLOAT_BTN_SIZE"] = "Tamaño del botón (ancho × alto)"
L["OPT_FLOAT_BTN_RESET"] = "Restaurar posición y tamaño"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "Sin sonido"
L["OPT_PLAY_SOUNDS"] = "Play sounds"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Avisar al seleccionar como objetivo a jugadores en la lista negra"
L["OPT_PREVENT_WHISPERS"] = "Bloquear susurros de jugadores en la lista negra"
L["OPT_WARN_WHISPERS"] = "Avisar cuando un jugador de la lista negra te susurre"
L["OPT_PREVENT_INVITES"] = "Impedir que jugadores de la lista negra te inviten a grupo"
L["OPT_PREVENT_MY_INVITES"] = "Impedir que invites a jugadores de la lista negra"
L["OPT_MUTED_CHAT"] = "Ignorar los mensajes de este jugador"
L["OPT_WARN_PARTY_JOIN"] = "Avisar cuando un jugador de la lista negra entre en tu grupo"
L["OPT_MUTE_PROXIMITY_REST"] = "Desactivar avisos en ciudades"
L["TOOLTIP_EDIT_BTN"] = "Editar"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Mostrar botón rápido en pantalla"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "Clic izquierdo: añadir objetivo"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "Clic derecho: abrir lista"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+arrastrar: mover botón"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+clic derecho: opciones"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s y te ha susurrado."
L["MSG_PREVENT_MY_INVITE"] = "%s %s; no puedes invitarlo."
L["MSG_DECLINED_PARTY_INVITE"] = "Invitación de grupo rechazada de %s (lista negra)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s y te ha invitado a un grupo."
L["PARTY_WARN_TITLE"] = "AVISO: ¡hay un jugador de la lista negra en tu grupo!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "No se encontró ChatFrame_OnEvent; el filtro de susurros puede fallar."
L["LOG_ERROR_IN"] = "ERROR en %s:"
L["REASON_SAVED_FOR"] = "Motivo guardado para %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "Clic izquierdo: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "Clic derecho: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "Clic izquierdo: abrir opciones"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "Clic derecho: abrir la lista"
L["REASON_EDIT_HINT"] = "Pasa el ratón sobre una fila para ver los detalles.\nDoble clic o el botón de editar para abrir el editor."

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Comandos y ayuda"
L["HELP_TITLE"] = "Lista negra — Ayuda"
L["HELP_PANEL_TEXT"] = [[VENTANA DE LISTA
• Pasa el ratón sobre una fila para ver todos los detalles
en el tooltip.
• Doble clic en una fila o el botón de editar para abrir el editor
(motivo y datos).

COMANDOS DE CHAT
/tbl — Abre esta ventana (sin argumentos).

/tbla — Abre el diálogo para agregar jugador.

/tblr — Quita por nombre. Sin argumentos: quita al objetivo actual.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Editar…"
L["STANDALONE_EDIT_TOOLTIP"] = "Abre el editor de la fila seleccionada.\nTambién puedes usar doble clic en la fila."
L["ROW_MENU_DELETE"] = "Eliminar"
L["BLACKLIST_POPUP_TEXT"] = "Usa los campos de abajo: nombre del jugador (obligatorio) y motivo (opcional)."
L["POPUP_NAME_EDIT_HINT"] = "Nombre del jugador"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Sonido de aviso al seleccionar objetivo"
L["OPT_SOUND_MOUSEOVER"] = "Sonido de aviso al pasar el ratón"
L["OPT_SOUND_NAMEPLATE"] = "Sonido de aviso con placa de nombre"
L["OPT_RAID_SOUND"] = "Sonido de aviso en grupo / banda"
L["OPT_SOUND_TARGETED_BY"] = "Sonido si un jugador de la lista negra te selecciona"
L["MSG_TARGETED_BY_WARN"] = "%s de tu lista negra te ha marcado como objetivo"
L["MSG_TAIL_TARGET_MOUSE"] = "está en tu lista negra."
L["MSG_TAIL_NAMEPLATE"] = "de tu lista negra está cerca"
L["MSG_TAIL_PARTY_GROUP"] = "de tu lista negra está en tu grupo"
L["MSG_TAIL_TARGETED_BY"] = "de tu lista negra te tiene como objetivo!"
L["OPT_SOUND_TEST"] = "Probar"

-- ---------------------------------------------------------------------------
-- Sound — preset names
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_PVP_QUEUE"] = "Cola JcJ (alerta por defecto)"
L["SOUND_PRESET_RAID_WARNING"] = "Aviso de banda"
L["SOUND_PRESET_READY_CHECK"] = "Comprobación de lista"
L["SOUND_PRESET_RAID_BOSS_EMOTE"] = "Emote de jefe de banda"
L["SOUND_PRESET_ALARM"] = "Alarma"
L["SOUND_PRESET_GM_WARNING"] = "Aviso de MJ"
L["SOUND_PRESET_RAID_BOSS_WHISPER"] = "Susurro de jefe de banda"
L["SOUND_PRESET_TELL"] = "Notificación de susurro"
L["SOUND_PRESET_BNET_TOAST"] = "Notificación Battle.net"
L["SOUND_PRESET_LOSS_OF_CONTROL"] = "Pérdida de control"

-- ---------------------------------------------------------------------------
-- Settings panel (Esc menu)
-- ---------------------------------------------------------------------------

L["SETTINGS_HINT_OPTIONS_ONLY"] = "Este panel solo contiene opciones. Abre la lista con /tbl o el menú."
L["OPT_ALERT_SOUND"] = "Sonido de alerta"
