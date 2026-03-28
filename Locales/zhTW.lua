local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "zhTW" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "玩家正在忽略你。"
L["PLAYER_NOT_FOUND"] = "未找到玩家。"
L["ALREADY_BLACKLISTED"] = "已經在黑名單中。"
L["ADDED_TO_BLACKLIST"] = "已新增至黑名單。"
L["BLACKLIST_MERGED_UPDATE"] = "已用伺服器與詳情更新項目。"
L["REMOVED_FROM_BLACKLIST"] = "已從黑名單中移除。"

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "黑名單"
L["CONTEXT_ADD_BLACKLIST"] = "加入黑名單"
L["CONTEXT_REMOVE_BLACKLIST"] = "從黑名單移除"
L["LIST_MENU_EDIT"] = "編輯項目"
L["LIST_MENU_REMOVE"] = "從清單移除"
L["LIST_MENU_TOXICITY"] = "毒性"
L["SHARE_LIST_TOOLTIP"] = "匯出或匯入黑名單，用於備份或與其他 Toxic BlackList 使用者分享。"
L["EXPORT_FULL_MENU"] = "匯出整份清單…"
L["IMPORT_LIST_MENU"] = "匯入清單…"
L["EXPORT_DIALOG_TITLE"] = "匯出黑名單"
L["IMPORT_DIALOG_TITLE"] = "匯入黑名單"
L["IMPORT_PASTE_HINT"] = "貼上完整匯出、單筆匯出或一行原始資料（格式與完整匯出中的行相同）。"
L["IMPORT_MERGE"] = "合併（略過重複）"
L["IMPORT_REPLACE"] = "取代整份清單"
L["IMPORT_REPLACE_WARN"] = "要以匯入的資料取代整份黑名單嗎？若無備份匯出則無法還原。"
L["IMPORT_RESULT_FMT"] = "匯入完成：%d 筆已加入，%d 筆略過或無效行。"
L["IMPORT_ERROR_BAD"] = "匯入失敗。"
L["ADD_DIALOG_REALM_LABEL"] = "伺服器（選填）"
L["ADD_DIALOG_REALM_NOTE"] = "無法驗證伺服器：插件無法取得暴雪的完整伺服器清單。請使用聊天或隊伍中顯示的確切名稱。留空則僅依名稱記錄，直到你在遊戲中遇到該玩家。"
L["ADD_DIALOG_CLASS_LABEL"] = "職業"
L["ADD_DIALOG_CLASS_BUTTON"] = "職業：—"
L["ADD_DIALOG_TOXICITY_LABEL"] = "毒性"
L["ADD_DIALOG_TOXICITY_TOOLTIP"] = "左鍵：下一個數值（0–10，循環）。右鍵：上一個。"
L["BLACKLIST_PLAYER"] = "將玩家加入黑名單"
L["REMOVE_PLAYER"] = "移除玩家"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "已解鎖"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "已鎖定"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "此項目已鎖定。請先在清單中解鎖再移除。"
L["ADD_PLAYER_POPUP"] = "依名稱新增"
L["ADD_TARGET"] = "新增目標"
L["OPTIONS"] = "選項"
L["SHARE_LIST"] = "分享名單"
L["BLACK_LIST_DETAILS_TITLE"] = "詳細：%s"
L["WINDOW_TITLE_EDIT"] = "編輯"
L["WINDOW_TITLE_ADD_PLAYER"] = "依名稱新增"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "等級"
L["DETAILS_NO_INFO"] = "無資訊"
L["DATE_ADDED_LABEL"] = "加入時間："
L["DATE_UPDATED_LABEL"] = "上次更新："
L["PREFIX_ADDED"] = "加入時間："
L["PREFIX_UPDATED"] = "更新時間："
L["DETAILS_REALM"] = "伺服器"
L["DETAILS_GUILD"] = "公會"
L["DETAILS_WINDOW_TITLE"] = "詳細"
L["BUTTON_SAVE"] = "儲存"
L["TOOLTIP_HINT_NAME_REALM"] = "角色名與伺服器"
L["TOOLTIP_HINT_GUILD"] = "公會"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "等級、種族與職業"
L["TOOLTIP_HINT_FACTION"] = "陣營"
L["TOOLTIP_BL_TOXICITY_LABEL"] = "毒性："

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "原因"
L["REASON"] = "原因："
L["IS_BLACKLISTED"] = "在你的黑名單中。"
L["BINDING_HEADER_BLACKLIST"] = "黑名單"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "切換黑名單"
L["UNKNOWN_LEVEL_CLASS"] = "未知等級，職業"
L["UNKNOWN_LEVEL"] = "未知等級"
L["UNKNOWN_CLASS"] = "未知職業"
L["UNKNOWN_RACE"] = "未知種族"
L["ALLIANCE"] = "聯盟"
L["HORDE"] = "部落"
L["UNKNOWN"] = "未知"
L["REALM_UNKNOWN"] = "未知伺服器"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "滑鼠懸停在黑名單玩家上時發出警告"
L["WARN_NAMEPLATE"] = "附近名條屬於黑名單玩家時發出警告"
L["OPT_WARN_TARGETED_BY"] = "黑名單玩家選取你時發出警告"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "一般"
L["OPT_SECTION_COMMUNICATION"] = "聊天"
L["OPT_SECTION_GROUP"] = "隊伍"
L["OPT_SECTION_SOUND"] = "音效"
L["OPT_TAB_GENERAL"] = "一般"
L["OPT_TAB_SOUND"] = "音效"
L["OPT_TAB_FLOATING"] = "按鈕"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "左鍵：選項"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "右鍵：開啟列表"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+左鍵：新增並編輯"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+右鍵：新增目標"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+拖曳：移動"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "螢幕快捷按鈕"
L["OPT_FLOAT_BTN_SIZE"] = "按鈕大小（寬 × 高）"
L["OPT_FLOAT_BTN_RESET"] = "重設位置與大小"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "播放警告音效"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "選取黑名單玩家為目標時發出警告"
L["OPT_PREVENT_WHISPERS"] = "阻擋黑名單玩家的悄悄話"
L["OPT_WARN_WHISPERS"] = "黑名單玩家悄悄話時發出警告"
L["OPT_PREVENT_INVITES"] = "阻擋黑名單玩家邀請你入隊"
L["OPT_PREVENT_MY_INVITES"] = "阻擋你邀請黑名單玩家"
L["OPT_MUTED_CHAT"] = "允許訊息"
L["OPT_MUTED_CHAT_UNMUTE"] = "已忽略訊息"
L["MUTED_CHECKBOX_LABEL"] = "忽略聊天訊息"
L["EVALUATION_SKULLS_LABEL"] = "毒性："
L["EVALUATION_SKULLS_TOOLTIP"] = "左鍵點擊圖示：毒性 1–10。右鍵：清除（0）。"
L["OPT_WARN_PARTY_JOIN"] = "黑名單玩家加入隊伍時發出警告"
L["OPT_MUTE_PROXIMITY_REST"] = "在城市關閉提示"
L["TOOLTIP_EDIT_BTN"] = "編輯"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "顯示螢幕快捷按鈕"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "左鍵：新增目標"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "右鍵：開啟列表"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+拖曳：移動按鈕"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+右鍵：選項"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s 並對你悄悄話。"
L["MSG_PREVENT_MY_INVITE"] = "%s %s，無法邀請。"
L["MSG_DECLINED_PARTY_INVITE"] = "已拒絕黑名單玩家 %s 的隊伍邀請。"
L["MSG_PARTY_INVITE_WARN"] = "%s %s 並邀請你加入隊伍。"
L["PARTY_WARN_TITLE"] = "警告：隊伍中有黑名單玩家！"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "找不到 ChatFrame_OnEvent，悄悄話過濾可能無效。"
L["LOG_ERROR_IN"] = "%s 發生錯誤："
L["REASON_SAVED_FOR"] = "已儲存 %s 的原因"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "左鍵：%s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "右鍵：%s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "左鍵：開啟選項"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "右鍵：開啟列表"
L["REASON_EDIT_HINT"] = "游標移到列上可檢視詳細資訊。按兩下可編輯。"
L["SORT_BY_TITLE"] = "排序方式..."
L["SORT_DATE"] = "日期"
L["SORT_NAME"] = "名稱"
L["SORT_REALM"] = "伺服器"
L["SORT_FACTION"] = "陣營"
L["SORT_TOXICITY"] = "毒性"
L["UNDO_DELETE"] = "復原"
L["UNDO_NOTHING"] = "沒有可復原項目"
L["FILTER_PLACEHOLDER"] = "篩選..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "顯示篩選"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "隱藏篩選"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "指令與說明"
L["HELP_TITLE"] = "黑名單 — 說明"
L["HELP_PANEL_TEXT"] = [[視窗
• 游標移到列上可在提示中查看完整資訊。
• 按兩下列可開啟編輯（原因與資料）。

聊天指令
/tbl — 無參數時開啟此視窗。

/tbla — 開啟新增玩家對話框。

/tblr — 依名稱移除。無參數時移除目前目標。
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "編輯…"
L["STANDALONE_EDIT_TOOLTIP"] = "Opens the editor for the selected entry.\nYou can also double-click a row."
L["ROW_MENU_DELETE"] = "移除"
L["BLACKLIST_POPUP_TEXT"] = "填寫玩家名稱（必填）、選填伺服器、職業、毒性（0–10）與原因。"
L["POPUP_NAME_EDIT_HINT"] = "玩家名稱"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "黑名單玩家選取你時的音效"
L["MSG_TARGETED_BY_WARN"] = "黑名單中的 %s 正在選取你"
L["MSG_TAIL_TARGET_MOUSE"] = "在你的黑名單中。"
L["MSG_TAIL_NAMEPLATE"] = "（黑名單）在附近。"
L["MSG_TAIL_PARTY_GROUP"] = "（黑名單）在你的隊伍中。"
L["MSG_TAIL_TARGETED_BY"] = "（黑名單）的目標是你！"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "此面板僅包含選項。使用 /tbl 或選單開啟清單。"
L["OPT_ALERT_SOUND"] = "警示音效"
