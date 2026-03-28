local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "zhCN" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "玩家正在忽略你。"
L["PLAYER_NOT_FOUND"] = "未找到玩家。"
L["ALREADY_BLACKLISTED"] = "已经在黑名单中。"
L["ADDED_TO_BLACKLIST"] = "已添加到黑名单。"
L["BLACKLIST_MERGED_UPDATE"] = "已用服务器与详情更新条目。"
L["REMOVED_FROM_BLACKLIST"] = "已从黑名单中移除。"

-- ---------------------------------------------------------------------------
-- Shared labels (reuse everywhere — avoid duplicating the same translation)
-- ---------------------------------------------------------------------------

L["FACTION"] = "阵营"
L["UNKNOWN_FACTION"] = "未知"
L["TOXICITY"] = "毒性"
L["TOXICITY_HEADER"] = "毒性："
L["TOXICITY_SKULLS_TOOLTIP"] = "左键点击图标：毒性 1–10。右键：清除（0）。"

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "黑名单"
L["CONTEXT_ADD_BLACKLIST"] = "加入黑名单"
L["CONTEXT_REMOVE_BLACKLIST"] = "从黑名单移除"
L["LIST_MENU_EDIT"] = "编辑条目"
L["LIST_MENU_REMOVE"] = "从列表移除"
L["SHARE_LIST_TOOLTIP"] = "导出或导入黑名单，用于备份或与其他 Toxic BlackList 用户分享。"
L["EXPORT_FULL_MENU"] = "导出整个列表…"
L["IMPORT_LIST_MENU"] = "导入列表…"
L["EXPORT_DIALOG_TITLE"] = "导出黑名单"
L["IMPORT_DIALOG_TITLE"] = "导入黑名单"
L["IMPORT_PASTE_HINT"] = "粘贴完整导出、单条导出或一行原始数据（格式与完整导出中的行相同）。"
L["IMPORT_MERGE"] = "合并（跳过重复）"
L["IMPORT_REPLACE"] = "替换整个列表"
L["IMPORT_REPLACE_WARN"] = "用导入的数据替换整个黑名单？除非有备份导出，否则无法撤销。"
L["IMPORT_RESULT_FMT"] = "导入完成：%d 条已添加，%d 条跳过或无效行。"
L["IMPORT_ERROR_BAD"] = "导入失败。"
L["ADD_DIALOG_REALM_LABEL"] = "服务器（可选）"
L["ADD_DIALOG_REALM_NOTE"] = "无法验证服务器：插件无法获取暴雪的完整服务器列表。请使用聊天或队伍中的准确名称。留空则仅为按名称记录，直到你在游戏中遇到该玩家。"
L["ADD_DIALOG_CLASS_LABEL"] = "职业"
L["ADD_DIALOG_CLASS_BUTTON"] = "职业：—"
L["BLACKLIST_PLAYER"] = "将玩家加入黑名单"
L["REMOVE_PLAYER"] = "移除玩家"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "已解锁"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "已锁定"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "该条目已锁定。请先在列表中解锁再移除。"
L["ADD_PLAYER_POPUP"] = "按名称添加"
L["ADD_TARGET"] = "添加目标"
L["OPTIONS"] = "选项"
L["SHARE_LIST"] = "分享名单"
L["BLACK_LIST_DETAILS_TITLE"] = "详情：%s"
L["WINDOW_TITLE_EDIT"] = "编辑"
L["WINDOW_TITLE_ADD_PLAYER"] = "按名称添加"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "等级"
L["DETAILS_NO_INFO"] = "无信息"
L["DATE_ADDED_LABEL"] = "添加时间："
L["DATE_UPDATED_LABEL"] = "上次更新："
L["PREFIX_ADDED"] = "添加时间："
L["PREFIX_UPDATED"] = "更新时间："
L["DETAILS_REALM"] = "服务器"
L["DETAILS_GUILD"] = "公会"
L["DETAILS_WINDOW_TITLE"] = "详情"
L["BUTTON_SAVE"] = "保存"
L["TOOLTIP_HINT_NAME_REALM"] = "角色名与服务器"
L["TOOLTIP_HINT_GUILD"] = "公会"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "等级、种族与职业"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "原因"
L["REASON"] = "原因："
L["IS_BLACKLISTED"] = "在你的黑名单中。"
L["BINDING_HEADER_BLACKLIST"] = "黑名单"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "切换黑名单"
L["UNKNOWN_LEVEL_CLASS"] = "未知等级，职业"
L["UNKNOWN_LEVEL"] = "未知等级"
L["UNKNOWN_CLASS"] = "未知职业"
L["UNKNOWN_RACE"] = "未知种族"
L["ALLIANCE"] = "联盟"
L["HORDE"] = "部落"
L["UNKNOWN"] = "未知"
L["REALM_UNKNOWN"] = "未知服务器"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "鼠标悬停在黑名单玩家上时发出警告"
L["WARN_NAMEPLATE"] = "附近姓名板属于黑名单玩家时发出警告"
L["OPT_WARN_TARGETED_BY"] = "黑名单玩家选中你时发出警告"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "常规"
L["OPT_SECTION_COMMUNICATION"] = "聊天"
L["OPT_SECTION_GROUP"] = "队伍"
L["OPT_SECTION_SOUND"] = "音效"
L["OPT_TAB_GENERAL"] = "常规"
L["OPT_TAB_SOUND"] = "音效"
L["OPT_TAB_FLOATING"] = "按钮"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "左键：选项"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "右键：打开列表"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+左键：添加并编辑"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+右键：添加目标"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+拖动：移动"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "屏幕快捷按钮"
L["OPT_FLOAT_BTN_SIZE"] = "按钮大小（宽 × 高）"
L["OPT_FLOAT_BTN_RESET"] = "重置位置和大小"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "播放警告音效"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "选中黑名单玩家时发出警告"
L["OPT_PREVENT_WHISPERS"] = "屏蔽黑名单玩家的密语"
L["OPT_WARN_WHISPERS"] = "黑名单玩家密语时发出警告"
L["OPT_PREVENT_INVITES"] = "阻止黑名单玩家邀请你入队"
L["OPT_PREVENT_MY_INVITES"] = "阻止你邀请黑名单玩家"
L["OPT_MUTED_CHAT"] = "允许消息"
L["OPT_MUTED_CHAT_UNMUTE"] = "已忽略消息"
L["MUTED_CHECKBOX_LABEL"] = "忽略聊天消息"
L["OPT_WARN_PARTY_JOIN"] = "黑名单玩家加入队伍时发出警告"
L["OPT_MUTE_PROXIMITY_REST"] = "在城市关闭提示"
L["TOOLTIP_EDIT_BTN"] = "编辑"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "显示屏幕快捷按钮"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "左键：添加目标"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "右键：打开列表"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+拖动：移动按钮"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+右键：选项"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s 并向你密语。"
L["MSG_PREVENT_MY_INVITE"] = "%s %s，无法邀请。"
L["MSG_DECLINED_PARTY_INVITE"] = "已拒绝黑名单玩家 %s 的队伍邀请。"
L["MSG_PARTY_INVITE_WARN"] = "%s %s 并邀请你加入队伍。"
L["PARTY_WARN_TITLE"] = "警告：队伍中有黑名单玩家！"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "未找到 ChatFrame_OnEvent，密语过滤可能无效。"
L["LOG_ERROR_IN"] = "%s 出错："
L["REASON_SAVED_FOR"] = "已保存 %s 的原因"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "左键：%s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "右键：%s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "左键：打开选项"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "右键：打开列表"
L["REASON_EDIT_HINT"] = "悬停在行上查看详情。双击行可编辑。"
L["SORT_BY_TITLE"] = "排序方式..."
L["SORT_DATE"] = "日期"
L["SORT_NAME"] = "名称"
L["SORT_REALM"] = "服务器"
L["UNDO_DELETE"] = "撤销"
L["UNDO_NOTHING"] = "无可撤销"
L["FILTER_PLACEHOLDER"] = "过滤..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "显示过滤"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "隐藏过滤"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "命令与帮助"
L["HELP_TITLE"] = "黑名单 — 帮助"
L["HELP_PANEL_TEXT"] = [[窗口
• 悬停在行上可在提示中查看完整信息。
• 双击行打开编辑（原因与数据）。

聊天命令
/tbl — 无参数时打开此窗口。

/tbla — 打开添加玩家对话框。

/tblr — 按名称移除。无参数时移除当前目标。
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "编辑…"
L["STANDALONE_EDIT_TOOLTIP"] = "Opens the editor for the selected entry.\nYou can also double-click a row."
L["ROW_MENU_DELETE"] = "移除"
L["BLACKLIST_POPUP_TEXT"] = "填写玩家名称（必填）、可选服务器、职业、毒性（0–10）和原因。"
L["POPUP_NAME_EDIT_HINT"] = "玩家名称"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "黑名单玩家选中你时的音效"
L["MSG_TARGETED_BY_WARN"] = "黑名单中的 %s 正在选中你"
L["MSG_TAIL_TARGET_MOUSE"] = "在你的黑名单中。"
L["MSG_TAIL_NAMEPLATE"] = "（黑名单）在附近。"
L["MSG_TAIL_PARTY_GROUP"] = "（黑名单）在你的队伍中。"
L["MSG_TAIL_TARGETED_BY"] = "（黑名单）的目标是你！"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "此面板仅包含选项。使用 /tbl 或菜单打开列表。"
L["OPT_ALERT_SOUND"] = "警报音效"
