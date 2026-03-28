local _, Addon = ...

Addon.L = Addon.L or {}
local L = Addon.L

if GetLocale() ~= "koKR" then return end

-- ---------------------------------------------------------------------------
-- General — status & list messages
-- ---------------------------------------------------------------------------

L["PLAYER_IGNORING"] = "플레이어가 당신을 무시하고 있습니다."
L["PLAYER_NOT_FOUND"] = "플레이어를 찾을 수 없습니다."
L["ALREADY_BLACKLISTED"] = "이미 차단 목록에 있습니다."
L["ADDED_TO_BLACKLIST"] = "차단 목록에 추가되었습니다."
L["BLACKLIST_MERGED_UPDATE"] = "서버 및 상세 정보로 항목이 갱신되었습니다."
L["REMOVED_FROM_BLACKLIST"] = "차단 목록에서 제거되었습니다."

-- ---------------------------------------------------------------------------
-- Shared labels (reuse everywhere — avoid duplicating the same translation)
-- ---------------------------------------------------------------------------

L["FACTION"] = "진영"
L["UNKNOWN_FACTION"] = "알 수 없음"
L["TOXICITY"] = "독성"
L["TOXICITY_HEADER"] = "독성:"
L["TOXICITY_SKULLS_TOOLTIP"] = "아이콘 클릭: 독성 1–10. 우클릭: 초기화(0)."

-- ---------------------------------------------------------------------------
-- UI — title, context menu, window & buttons
-- ---------------------------------------------------------------------------

L["BLACKLIST"] = "차단 목록"
L["CONTEXT_ADD_BLACKLIST"] = "차단 목록에 추가"
L["CONTEXT_REMOVE_BLACKLIST"] = "차단 목록에서 제거"
L["LIST_MENU_EDIT"] = "항목 편집"
L["LIST_MENU_REMOVE"] = "목록에서 제거"
L["SHARE_LIST_TOOLTIP"] = "차단 목록을 보내거나 가져옵니다(백업 또는 다른 Toxic BlackList 사용자와 공유)."
L["EXPORT_FULL_MENU"] = "전체 목록 보내기…"
L["IMPORT_LIST_MENU"] = "목록 가져오기…"
L["EXPORT_DIALOG_TITLE"] = "차단 목록보내기"
L["IMPORT_DIALOG_TITLE"] = "차단 목록 가져오기"
L["IMPORT_PASTE_HINT"] = "전체보내기, 단일 항목보내기 또는 데이터 한 줄을 붙여넣으세요(전체보내기의 한 줄과 같은 형식)."
L["IMPORT_MERGE"] = "병합(중복 건너뛰기)"
L["IMPORT_REPLACE"] = "목록 전체 교체"
L["IMPORT_REPLACE_WARN"] = "가져온 데이터로 차단 목록 전체를 바꿀까요? 백업보내기가 없으면 되돌릴 수 없습니다."
L["IMPORT_RESULT_FMT"] = "가져오기 완료: %d개 추가, %d개 건너뜀 또는 잘못된 줄."
L["IMPORT_ERROR_BAD"] = "가져오기 실패."
L["ADD_DIALOG_REALM_LABEL"] = "서버(선택)"
L["ADD_DIALOG_REALM_NOTE"] = "서버 이름은 검증되지 않습니다. 애드온은 블리자드의 전체 서버 목록을 쓸 수 없습니다. 채팅/파티에 표시되는 정확한 이름을 입력하세요. 비우면 게임 내에서 만날 때까지 이름만 있는 항목입니다."
L["ADD_DIALOG_CLASS_LABEL"] = "직업"
L["ADD_DIALOG_CLASS_BUTTON"] = "직업: —"
L["BLACKLIST_PLAYER"] = "플레이어 차단"
L["REMOVE_PLAYER"] = "플레이어 제거"
L["ROW_LOCK_TOOLTIP_UNLOCKED"] = "잠금 해제됨"
L["ROW_LOCK_TOOLTIP_LOCKED"] = "잠김"
L["REMOVE_BLOCKED_ENTRY_LOCKED"] = "이 항목은 잠겨 있습니다. 목록에서 잠금을 해제한 뒤 제거하세요."
L["ADD_PLAYER_POPUP"] = "이름으로 추가"
L["ADD_TARGET"] = "대상 추가"
L["OPTIONS"] = "설정"
L["SHARE_LIST"] = "목록 공유"
L["BLACK_LIST_DETAILS_TITLE"] = "상세: %s"
L["WINDOW_TITLE_EDIT"] = "편집"
L["WINDOW_TITLE_ADD_PLAYER"] = "이름으로 추가"

-- ---------------------------------------------------------------------------
-- Details panel
-- ---------------------------------------------------------------------------

L["LEVEL"] = "레벨"
L["DETAILS_NO_INFO"] = "정보 없음"
L["DATE_ADDED_LABEL"] = "추가 일시:"
L["DATE_UPDATED_LABEL"] = "마지막 업데이트:"
L["PREFIX_ADDED"] = "추가:"
L["PREFIX_UPDATED"] = "업데이트:"
L["DETAILS_REALM"] = "서버"
L["DETAILS_GUILD"] = "길드"
L["DETAILS_WINDOW_TITLE"] = "상세"
L["BUTTON_SAVE"] = "저장"
L["TOOLTIP_HINT_NAME_REALM"] = "플레이어 이름과 서버"
L["TOOLTIP_HINT_GUILD"] = "길드"
L["TOOLTIP_HINT_LEVEL_RACE_CLASS"] = "레벨, 종족, 직업"

-- ---------------------------------------------------------------------------
-- Reason, bindings, factions & unknowns
-- ---------------------------------------------------------------------------

L["REASON_HEADER"] = "사유"
L["REASON"] = "이유:"
L["IS_BLACKLISTED"] = "차단 목록에 있습니다."
L["BINDING_HEADER_BLACKLIST"] = "차단 목록"
L["BINDING_NAME_TOGGLE_BLACKLIST"] = "차단 목록 열기/닫기"
L["UNKNOWN_LEVEL_CLASS"] = "알 수 없는 레벨, 직업"
L["UNKNOWN_LEVEL"] = "알 수 없는 레벨"
L["UNKNOWN_CLASS"] = "알 수 없는 직업"
L["UNKNOWN_RACE"] = "알 수 없는 종족"
L["ALLIANCE"] = "얼라이언스"
L["HORDE"] = "호드"
L["UNKNOWN"] = "알 수 없음"
L["REALM_UNKNOWN"] = "알 수 없는 서버"

-- ---------------------------------------------------------------------------
-- Proximity alert labels (options)
-- ---------------------------------------------------------------------------

L["WARN_MOUSEOVER"] = "차단된 플레이어에게 마우스를 올릴 때 경고"
L["WARN_NAMEPLATE"] = "가까운 이름표가 차단된 플레이어일 때 경고"
L["OPT_WARN_TARGETED_BY"] = "차단 목록 플레이어가 나를 대상으로 할 때 경고"

-- ---------------------------------------------------------------------------
-- Options — section titles & tabs
-- ---------------------------------------------------------------------------

L["OPT_SECTION_GENERAL"] = "일반"
L["OPT_SECTION_COMMUNICATION"] = "대화"
L["OPT_SECTION_GROUP"] = "파티"
L["OPT_SECTION_SOUND"] = "소리"
L["OPT_TAB_GENERAL"] = "일반"
L["OPT_TAB_SOUND"] = "소리"
L["OPT_TAB_FLOATING"] = "버튼"
L["TOOLTIP_FLOAT_LEFT_OPTIONS"] = "왼쪽 클릭: 옵션"
L["TOOLTIP_FLOAT_RIGHT_LIST"] = "오른쪽 클릭: 목록 열기"
L["TOOLTIP_FLOAT_CTRL_LEFT_EDIT"] = "Ctrl+왼쪽 클릭: 추가 및 편집"
L["TOOLTIP_FLOAT_CTRL_RIGHT_ADD"] = "Ctrl+오른쪽 클릭: 대상 추가"
L["TOOLTIP_FLOAT_ALT_DRAG_LINE"] = "Alt+끌기: 이동"

-- ---------------------------------------------------------------------------
-- Options — floating button chrome
-- ---------------------------------------------------------------------------

L["OPT_SECTION_FLOATING"] = "화면 빠른 버튼"
L["OPT_FLOAT_BTN_SIZE"] = "버튼 크기 (가로 × 세로)"
L["OPT_FLOAT_BTN_RESET"] = "위치 및 크기 초기화"
L["TOOLTIP_FLOAT_TITLE"] = "Black List"

-- ---------------------------------------------------------------------------
-- Sound — mute & play sounds
-- ---------------------------------------------------------------------------

L["SOUND_PRESET_NONE"] = "No sound"
L["OPT_PLAY_SOUNDS"] = "경고음 재생"

-- ---------------------------------------------------------------------------
-- Options — communication, group, quick button
-- ---------------------------------------------------------------------------

L["OPT_WARN_TARGET"] = "차단된 플레이어를 대상으로 할 때 경고"
L["OPT_PREVENT_WHISPERS"] = "차단된 플레이어의 귓속말 차단"
L["OPT_WARN_WHISPERS"] = "차단된 플레이어가 귓속말할 때 경고"
L["OPT_PREVENT_INVITES"] = "차단된 플레이어의 파티 초대 차단"
L["OPT_PREVENT_MY_INVITES"] = "차단된 플레이어 초대 방지"
L["OPT_MUTED_CHAT"] = "메시지 허용"
L["OPT_MUTED_CHAT_UNMUTE"] = "메시지 무시됨"
L["MUTED_CHECKBOX_LABEL"] = "대화 메시지 무시"
L["OPT_WARN_PARTY_JOIN"] = "차단된 플레이어가 파티에 합류할 때 경고"
L["OPT_MUTE_PROXIMITY_REST"] = "도시에서 경고 끄기"
L["TOOLTIP_EDIT_BTN"] = "편집"
L["OPT_SHOW_FLOATING_QUICK_BUTTON"] = "화면에 빠른 버튼 표시"
L["TOOLTIP_FLOATING_QUICK_LEFT"] = "왼쪽 클릭: 대상 추가"
L["TOOLTIP_FLOATING_QUICK_RIGHT"] = "오른쪽 클릭: 목록 열기"
L["TOOLTIP_FLOATING_QUICK_DRAG"] = "Alt+끌기: 버튼 이동"
L["TOOLTIP_FLOATING_QUICK_ALT_RIGHT"] = "Alt+오른쪽 클릭: 옵션"

-- ---------------------------------------------------------------------------
-- Chat — whispers, invites, party
-- ---------------------------------------------------------------------------

L["MSG_PLAYER_BLACKLISTED"] = "%s %s"
L["MSG_WHISPER_WARN"] = "%s %s 귓속말을 보냈습니다."
L["MSG_PREVENT_MY_INVITE"] = "%s %s — 초대할 수 없습니다."
L["MSG_DECLINED_PARTY_INVITE"] = "%s의 파티 초대를 거절했습니다(차단 목록)."
L["MSG_PARTY_INVITE_WARN"] = "%s %s 파티에 초대했습니다."
L["PARTY_WARN_TITLE"] = "경고: 파티에 차단된 플레이어가 있습니다!"

-- ---------------------------------------------------------------------------
-- Logs & minimap
-- ---------------------------------------------------------------------------

L["LOG_CHATFRAME_HOOK_MISSING"] = "ChatFrame_OnEvent를 찾을 수 없습니다. 귓속말 필터가 작동하지 않을 수 있습니다."
L["LOG_ERROR_IN"] = "%s 오류:"
L["REASON_SAVED_FOR"] = "%s의 사유를 저장했습니다"
L["MINIMAP_TOOLTIP_LEFT_CLICK"] = "왼쪽 클릭: %s"
L["MINIMAP_TOOLTIP_RIGHT_CLICK"] = "오른쪽 클릭: %s"
L["MINIMAP_TOOLTIP_LEFT_OPTIONS"] = "왼쪽 클릭: 옵션 열기"
L["MINIMAP_TOOLTIP_RIGHT_LIST"] = "오른쪽 클릭: 목록 열기"
L["REASON_EDIT_HINT"] = "행에 마우스를 올리면 상세 정보가 보입니다. 더블 클릭으로 편집."
L["SORT_BY_TITLE"] = "정렬 기준..."
L["SORT_DATE"] = "날짜"
L["SORT_NAME"] = "이름"
L["SORT_REALM"] = "서버"
L["UNDO_DELETE"] = "실행 취소"
L["UNDO_NOTHING"] = "실행 취소할 항목 없음"
L["FILTER_PLACEHOLDER"] = "필터..."
L["TOOLTIP_FILTER_TOGGLE_SHOW"] = "필터 표시"
L["TOOLTIP_FILTER_TOGGLE_HIDE"] = "필터 숨기기"

-- ---------------------------------------------------------------------------
-- Help
-- ---------------------------------------------------------------------------

L["HELP_BUTTON"] = "?"
L["HELP_BUTTON_TOOLTIP"] = "명령어 및 도움말"
L["HELP_TITLE"] = "차단 목록 — 도움말"
L["HELP_PANEL_TEXT"] = [[창
• 행에 마우스를 올리면 툴팁에 모든 정보가 표시됩니다.
• 행을 더블 클릭하면 편집기(사유 및 데이터)가 열립니다.

채팅 명령
/tbl — 인자 없이 이 창을 엽니다.

/tbla — 플레이어 추가 창을 엽니다.

/tblr — 이름으로 제거합니다. 인자 없음: 현재 대상 제거.
]]

-- ---------------------------------------------------------------------------
-- List row menu & add-player dialog
-- ---------------------------------------------------------------------------

L["ROW_MENU_EDIT"] = "편집…"
L["STANDALONE_EDIT_TOOLTIP"] = "Opens the editor for the selected entry.\nYou can also double-click a row."
L["ROW_MENU_DELETE"] = "삭제"
L["BLACKLIST_POPUP_TEXT"] = "이름(필수), 선택 서버, 직업, 독성(0–10), 사유를 입력하세요."
L["POPUP_NAME_EDIT_HINT"] = "플레이어 이름"

-- ---------------------------------------------------------------------------
-- Sound — per-alert labels & message tails
-- ---------------------------------------------------------------------------

L["OPT_SOUND_TARGET"] = "Target warning sound"
L["OPT_SOUND_MOUSEOVER"] = "Mouseover warning sound"
L["OPT_SOUND_NAMEPLATE"] = "Nameplate warning sound"
L["OPT_RAID_SOUND"] = "Party / group warning sound"
L["OPT_SOUND_TARGETED_BY"] = "차단 목록 플레이어가 나를 대상으로 할 때 소리"
L["MSG_TARGETED_BY_WARN"] = "차단 목록의 %s(이)가 당신을 대상으로 함"
L["MSG_TAIL_TARGET_MOUSE"] = "차단 목록에 있습니다."
L["MSG_TAIL_NAMEPLATE"] = "(차단 목록) 근처에 있습니다."
L["MSG_TAIL_PARTY_GROUP"] = "(차단 목록) 당신의 파티에 있습니다."
L["MSG_TAIL_TARGETED_BY"] = "(차단 목록) 당신을 대상으로 했습니다!"
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

L["SETTINGS_HINT_OPTIONS_ONLY"] = "이 패널에는 옵션만 있습니다. 목록은 /tbl 또는 메뉴로 엽니다."
L["OPT_ALERT_SOUND"] = "경고 알림"
