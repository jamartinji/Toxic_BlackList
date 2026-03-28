local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "ptBR" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "O jogador está ignorando você."
L["PLAYER_NOT_FOUND"] = "Jogador não encontrado."
L["ALREADY_BLACKLISTED"] = "já está na lista negra."
L["ADDED_TO_BLACKLIST"] = "adicionado à lista negra."
L["BLACKLIST_MERGED_UPDATE"] = "Entrada atualizada com reino e detalhes."
L["REMOVED_FROM_BLACKLIST"] = "removido da lista negra."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Lista Negra"
L["CONTEXT_ADD_BLACKLIST"] = "Adicionar à lista negra"
L["CONTEXT_REMOVE_BLACKLIST"] = "Remover da lista negra"
L["LIST_MENU_EDIT"] = "Editar entrada"
L["LIST_MENU_REMOVE"] = "Remover da lista"
L["LIST_MENU_TOXICITY"] = "Toxicidade"
L["SHARE_LIST_TOOLTIP"] = "Exportar ou importar a lista negra (backup ou compartilhar com outros usuários do Toxic BlackList)."
L["EXPORT_FULL_MENU"] = "Exportar lista inteira…"
L["IMPORT_LIST_MENU"] = "Importar lista…"
L["EXPORT_DIALOG_TITLE"] = "Exportar lista negra"
L["IMPORT_DIALOG_TITLE"] = "Importar lista negra"
L["IMPORT_PASTE_HINT"] = "Cole um export completo, export de uma entrada ou uma linha de dados (mesmo formato de uma linha do export completo)."
L["IMPORT_MERGE"] = "Mesclar (ignorar duplicados)"
L["IMPORT_REPLACE"] = "Substituir lista inteira"
L["IMPORT_REPLACE_WARN"] = "Substituir toda a lista negra pelos dados importados? Irreversível sem um export de backup."
L["IMPORT_RESULT_FMT"] = "Importação: %d adicionados, %d ignorados ou linhas inválidas."
L["IMPORT_ERROR_BAD"] = "Falha na importação."
L["ADD_DIALOG_REALM_LABEL"] = "Reino (opcional)"
L["ADD_DIALOG_REALM_NOTE"] = "Reinos não são validados: addons não têm a lista completa da Blizzard. Use o nome exato (chat ou grupo). Deixe vazio para entrada só com nome até encontrar o jogador."
L["ADD_DIALOG_CLASS_LABEL"] = "Classe"
L["ADD_DIALOG_CLASS_BUTTON"] = "Classe: —"
L["ADD_DIALOG_TOXICITY_LABEL"] = "Toxicidade"
L["ADD_DIALOG_TOXICITY_TOOLTIP"] = "Clique esquerdo: próximo valor (0–10, volta ao início). Clique direito: anterior."
L["BLACKLIST_PLAYER"] = "Adicionar Jogador"
L["REMOVE_PLAYER"] = "Remover Jogador"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "Desbloqueado"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "Bloqueado"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "Esta entrada está bloqueada. Desbloqueie na lista antes de remover."
L["ADD_PLAYER_POPUP"] = "Adicionar por nome"
L["ADD_TARGET"] = "Adicionar alvo"
L["OPTIONS"] = "Opções"
L["SHARE_LIST"] = "Compartilhar Lista"
L["BLACK_LIST_DETAILS_TITLE"] = "Detalhes: %s"
L["WINDOW_TITLE_EDIT"] = "Editar"
L["WINDOW_TITLE_ADD_PLAYER"] = "Adicionar por nome"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Nível"
L["DETAILS_NO_INFO"] = "Sem informação"
L["DATE_ADDED_LABEL"] = "Data adicionada:"
L["DATE_UPDATED_LABEL"] = "Última atualização:"
L["PREFIX_ADDED"] = "Adicionado:"
L["PREFIX_UPDATED"] = "Atualizado:"
L["DETAILS_REALM"] = "Reino"
L["DETAILS_GUILD"] = "Guilda"
L["DETAILS_WINDOW_TITLE"] = "Detalhes"
L["BUTTON_SAVE"] = "Salvar"
L["TOOLTIP_HINT_NAME_REALM"] = "Nome do jogador e reino"
L["TOOLTIP_HINT_GUILD"] = "Guilda"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "Nível, raça e classe"
L["TOOLTIP_HINT_FACTION"] = "Facção"
L["TOOLTIP_BL_TOXICITY_LABEL"] = "Toxicidade:"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Motivo"
L["REASON"] = "Motivo:"
L["IS_BLACKLISTED"] = "está na sua lista negra."
L["BINDING_HEADER_BLACKLIST"] = "Lista Negra"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Alternar Lista Negra"
L["UNKNOWN_LEVEL_CLASS"] = "Nível e Classe Desconhecidos"
L["UNKNOWN_LEVEL"] = "Nível Desconhecido"
L["UNKNOWN_CLASS"] = "Classe Desconhecida"
L["UNKNOWN_RACE"] = "Raça Desconhecida"
L["ALLIANCE"] = "Aliança"
L["HORDE"] = "Horda"
L["UNKNOWN"] = "Desconhecido"
L["REALM_UNKNOWN"] = "Reino desconhecido"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Avisar ao passar o mouse sobre jogadores na lista negra"
L["WARN_NAMEPLATE"] = "Avisar quando uma placa de nome próxima for de um jogador na lista negra"
L["OPT_WARN_TARGETED_BY"] = "Avisar quando um jogador da lista negra mirar em você"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "Geral"
L["OPT_SECTION_COMMUNICATION"] = "Comunicação"
L["OPT_SECTION_GROUP"] = "Grupo"
L["OPT_SECTION_SOUND"] = "Som"
L["OPT_TAB_GENERAL"] = "Geral"
L["OPT_TAB_SOUND"] = "Som"
L["OPT_TAB_FLOATING"] = "Botão"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "Clique esquerdo: opções"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "Clique direito: abrir lista"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+clique esquerdo: adicionar e editar"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+clique direito: adicionar alvo"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+arrastar: mover"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "Botão rápido na tela"
L["OPT_FLOAT_BTN_SIZE"] = "Tamanho do botão (largura × altura)"
L["OPT_FLOAT_BTN_RESET"] = "Redefinir posição e tamanho"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "Tocar sons de aviso"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Avisar ao mirar jogadores na lista negra"
L["OPT_PREVENT_WHISPERS"] = "Bloquear sussurros de jogadores na lista negra"
L["OPT_WARN_WHISPERS"] = "Avisar ao receber sussurro de jogador na lista negra"
L["OPT_PREVENT_INVITES"] = "Impedir convites de jogadores na lista negra"
L["OPT_PREVENT_MY_INVITES"] = "Impedir que você convide jogadores na lista negra"
L["OPT_MUTED_CHAT"] = "Mensagens permitidas"
L["OPT_MUTED_CHAT_UNMUTE"] = "Mensagens ignoradas"
L["MUTED_CHECKBOX_LABEL"] = "Ignorar mensagens no chat"
L["EVALUATION_SKULLS_LABEL"] = "Toxicidade:"
L["EVALUATION_SKULLS_TOOLTIP"] = "Clique esquerdo no ícone: toxicidade 1–10. Botão direito: limpar (0)."
L["OPT_WARN_PARTY_JOIN"] = "Avisar quando um jogador da lista negra entrar no grupo"
L["OPT_MUTE_PROXIMITY_REST"] = "Desativar avisos em cidades"
L["TOOLTIP_EDIT_BTN"] = "Editar"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Mostrar botão rápido na tela"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "Clique esquerdo: adicionar alvo"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "Clique direito: abrir lista"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+arrastar: mover botão"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+clique direito: opções"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s e sussurrou para você."
L["MSG_PREVENT_MY_INVITE"] = "%s %s — não é possível convidar."
L["MSG_DECLINED_PARTY_INVITE"] = "Convite de grupo recusado de %s (lista negra)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s e convidou você para um grupo."
L["PARTY_WARN_TITLE"] = "AVISO: jogador da lista negra no seu grupo!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent não encontrado; o filtro de sussurros pode falhar."
L["LOG_ERROR_IN"] = "ERRO em %s:"
L["REASON_SAVED_FOR"] = "Motivo salvo para %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "Clique esquerdo: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "Clique direito: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "Clique esquerdo: abrir opções"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "Clique direito: abrir a lista"
L["REASON_EDIT_HINT"] = "Passe o mouse na linha para ver detalhes. Duplo clique para editar."
L["SORT_BY_TITLE"] = "Ordenar por..."
L["SORT_DATE"] = "Data"
L["SORT_NAME"] = "Nome"
L["SORT_REALM"] = "Reino"
L["SORT_FACTION"] = "Facção"
L["SORT_TOXICITY"] = "Toxicidade"
L["UNDO_DELETE"] = "Desfazer"
L["UNDO_NOTHING"] = "Nada para desfazer"
L["FILTER_PLACEHOLDER"] = "Filtrar..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "Mostrar filtro"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "Ocultar filtro"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Comandos e ajuda"
L["HELP_TITLE"] = "Lista negra — Ajuda"
L["HELP_PANEL_TEXT"] = [[JANELA
• Passe o mouse sobre uma linha para ver todos os detalhes na dica.
• Duplo clique em uma linha para abrir o editor (motivo e dados).

COMANDOS
/tbl — Abre esta janela (sem argumentos).

/tbla — Abre o diálogo para adicionar jogador.

/tblr — Remove por nome. Sem argumentos: remove o alvo atual.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Editar…"
L["STANDALONE_EDIT_TOOLTIP"] = "Abre o editor da linha selecionada.\nTambém pode dar duplo clique."
L["ROW_MENU_DELETE"] = "Remover"
L["BLACKLIST_POPUP_TEXT"] = "Campos: nome (obrigatório), reino opcional, classe, toxicidade (0–10) e motivo."
L["POPUP_NAME_EDIT_HINT"] = "Nome do jogador"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "Som quando um jogador da lista negra mirar em você"
L["MSG_TARGETED_BY_WARN"] = "%s da sua lista negra está mirando em você"
L["MSG_TAIL_TARGET_MOUSE"] = "está na sua lista negra."
L["MSG_TAIL_NAMEPLATE"] = "da sua lista negra está por perto."
L["MSG_TAIL_PARTY_GROUP"] = "da sua lista negra está no seu grupo."
L["MSG_TAIL_TARGETED_BY"] = "da sua lista negra está mirando em você!"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "Este painel contém apenas opções. Abra a lista com /tbl ou pelo menu."
L["OPT_ALERT_SOUND"] = "Som de alerta"
