local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "ruRU" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "Игрок вас игнорирует."
L["PLAYER_NOT_FOUND"] = "Игрок не найден."
L["ALREADY_BLACKLISTED"] = "уже в черном списке."
L["ADDED_TO_BLACKLIST"] = "добавлен в черный список."
L["BLACKLIST_MERGED_UPDATE"] = "Запись обновлена: реалм и данные."
L["REMOVED_FROM_BLACKLIST"] = "удален из черного списка."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "Черный список"
L["CONTEXT_ADD_BLACKLIST"] = "В черный список"
L["CONTEXT_REMOVE_BLACKLIST"] = "Удалить из черного списка"
L["BLACKLIST_PLAYER"] = "В черный список"
L["REMOVE_PLAYER"] = "Удалить игрока"
L["ADD_PLAYER_POPUP"] = "По имени"
L["ADD_TARGET"] = "Добавить цель"
L["OPTIONS"] = "Настройки"
L["SHARE_LIST"] = "Поделиться списком"
L["BLACK_LIST_DETAILS_TITLE"] = "Подробности: %s"
L["WINDOW_TITLE_EDIT"] = "Изменить"
L["WINDOW_TITLE_ADD_PLAYER"] = "Добавить по имени"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "Уровень"
L["DETAILS_NO_INFO"] = "Нет данных"
L["DATE_ADDED_LABEL"] = "Дата добавления:"
L["DATE_UPDATED_LABEL"] = "Последнее обновление:"
L["PREFIX_ADDED"] = "Добавлено:"
L["PREFIX_UPDATED"] = "Обновлено:"
L["DETAILS_REALM"] = "Игровой мир"
L["DETAILS_GUILD"] = "Гильдия"
L["DETAILS_WINDOW_TITLE"] = "Подробности"
L["BUTTON_SAVE"] = "Сохранить"
L["TOOLTIP_HINT_NAME_REALM"] = "Имя игрока и мир"
L["TOOLTIP_HINT_GUILD"] = "Гильдия"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "Уровень, раса и класс"
L["TOOLTIP_HINT_FACTION"] = "Фракция"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "Причина"
L["REASON"] = "Причина:"
L["IS_BLACKLISTED"] = "в вашем черном списке."
L["BINDING_HEADER_BLACKLIST"] = "Черный список"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "Показать/Скрыть черный список"
L["UNKNOWN_LEVEL_CLASS"] = "Неизвестный уровень, класс"
L["UNKNOWN_LEVEL"] = "Неизвестный уровень"
L["UNKNOWN_CLASS"] = "Неизвестный класс"
L["UNKNOWN_RACE"] = "Неизвестная раса"
L["ALLIANCE"] = "Альянс"
L["HORDE"] = "Орда"
L["UNKNOWN"] = "Неизвестно"
L["REALM_UNKNOWN"] = "Неизвестный мир"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "Предупреждать при наведении курсора на игроков из черного списка"
L["WARN_NAMEPLATE"] = "Предупреждать, если ближайшая табличка с именем принадлежит игроку из черного списка"
L["OPT_WARN_TARGETED_BY"] = "Предупреждать, если игрок из черного списка берет вас в цель"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "Общие"
L["OPT_SECTION_COMMUNICATION"] = "Общение"
L["OPT_SECTION_GROUP"] = "Группа"
L["OPT_SECTION_SOUND"] = "Звук"
L["OPT_TAB_GENERAL"] = "Общие"
L["OPT_TAB_SOUND"] = "Звук"
L["OPT_TAB_FLOATING"] = "Кнопка"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "ЛКМ: настройки"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "ПКМ: открыть список"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+ЛКМ: добавить и изменить"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+ПКМ: добавить цель"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+перетаскивание: переместить"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "Быстрая кнопка на экране"
L["OPT_FLOAT_BTN_SIZE"] = "Размер кнопки (ширина × высота)"
L["OPT_FLOAT_BTN_RESET"] = "Сбросить позицию и размер"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "Воспроизводить звуки предупреждений"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "Предупреждать при выборе цели — игрок из черного списка"
L["OPT_PREVENT_WHISPERS"] = "Блокировать шепот от игроков из черного списка"
L["OPT_WARN_WHISPERS"] = "Предупреждать о шепоте от игроков из черного списка"
L["OPT_PREVENT_INVITES"] = "Блокировать приглашения в группу от игроков из черного списка"
L["OPT_PREVENT_MY_INVITES"] = "Запретить приглашать игроков из черного списка"
L["OPT_MUTED_CHAT"] = "Скрывать сообщения этого игрока в чате"
L["OPT_WARN_PARTY_JOIN"] = "Предупреждать, когда игрок из черного списка вступает в группу"
L["OPT_MUTE_PROXIMITY_REST"] = "Отключить предупреждения в городах"
L["TOOLTIP_EDIT_BTN"] = "Изменить"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "Показывать быструю кнопку на экране"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "ЛКМ: добавить цель"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "ПКМ: открыть список"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+перетаскивание: переместить кнопку"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+ПКМ: настройки"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s и шепчет вам."
L["MSG_PREVENT_MY_INVITE"] = "%s %s — приглашение невозможно."
L["MSG_DECLINED_PARTY_INVITE"] = "Отклонено приглашение в группу от %s (черный список)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s и приглашает вас в группу."
L["PARTY_WARN_TITLE"] = "ВНИМАНИЕ: в группе игрок из черного списка!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent не найден; фильтр шепота может не работать."
L["LOG_ERROR_IN"] = "ОШИБКА в %s:"
L["REASON_SAVED_FOR"] = "Причина сохранена для %s"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "ЛКМ: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "ПКМ: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "ЛКМ: открыть настройки"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "ПКМ: открыть список"
L["REASON_EDIT_HINT"] = "Наведите на строку — подробности. Двойной щелчок — редактировать."
L["FILTER_PLACEHOLDER"] = "Фильтр..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "Показать фильтр"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "Скрыть фильтр"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "Команды и справка"
L["HELP_TITLE"] = "Черный список — справка"
L["HELP_PANEL_TEXT"] = [[ОКНО
• Наведите курсор на строку — подсказка со всеми данными.
• Двойной щелчок — редактор (причина и данные).

КОМАНДЫ
/tbl — Открыть это окно (без аргументов).

/tbla — Открыть окно добавления игрока.

/tblr — Удалить по имени. Без аргумента — текущая цель.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "Изменить…"
L["STANDALONE_EDIT_TOOLTIP"] = "Открывает редактор для выбранной записи.\nДвойной щелчок тоже открывает редактор."
L["ROW_MENU_DELETE"] = "Удалить"
L["BLACKLIST_POPUP_TEXT"] = "Заполните поля ниже: имя игрока (обязательно) и причина (по желанию)."
L["POPUP_NAME_EDIT_HINT"] = "Имя игрока"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "Звук, когда игрок из черного списка берет вас в цель"
L["MSG_TARGETED_BY_WARN"] = "%s из черного списка берет вас в цель"
L["MSG_TAIL_TARGET_MOUSE"] = "в вашем чёрном списке."
L["MSG_TAIL_NAMEPLATE"] = "из чёрного списка рядом."
L["MSG_TAIL_PARTY_GROUP"] = "из чёрного списка в вашей группе."
L["MSG_TAIL_TARGETED_BY"] = "из чёрного списка берёт вас в цель!"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "Эта панель содержит только настройки. Список открывается через /tbl или меню."
L["OPT_ALERT_SOUND"] = "Звук предупреждения"
