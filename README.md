# Toxic BlackList

[![Version](https://img.shields.io/badge/Version-1.0.1-informational?style=for-the-badge)](Toxic_BlackList.toc)
[![WoW](https://img.shields.io/badge/WoW-12.0.1%20(Midnight)-orange?style=for-the-badge)](https://worldofwarcraft.blizzard.com/)
[![Lua](https://img.shields.io/badge/Lua-5.x-blue?style=for-the-badge)](https://www.lua.org/)

A powerful, unlimited, and private list of players you don't want to play with again, far surpassing the default ignore list.

---

## ✨ Características

Toxic BlackList enhances player management by offering features the default ignore system lacks.

| Feature | WoW's Ignore List | Toxic BlackList                                                                  |
| :--- | :--- |:--------------------------------------------------------------------------------|
| **Player Limit** | Limited (e.g., 50 per character) | ✅ **Unlimited**                                                                 |
| **Custom Reasons**| No | ✅ Yes — add detailed notes for each player                                      |
| **Information Stored** | Name only | ✅ Name, Realm, Level, Class, Race, Faction                                      |
| **Synchronization** | Per-character | ✅ **Account-wide** list                                                         |
| **Alerts & Warnings** | None | ✅ Text and sound alerts (on target, mouseover, nameplates, etc.)                |
| **Whisper Blocking** | Yes | ✅ Yes, with an optional warning instead of a silent block                       |
| **Group Protection** | No | ✅ Blocks invites, prevents you from inviting, and warns if one joins your group |
| **UI & Access** | Basic list in the Friends panel | ✅ Standalone window, minimap button, and a floating button                      |

---

## 📥 Installation

1.  Download the latest version from the Releases page.
2.  Extract the ZIP file.
3.  Copy the `Toxic_BlackList` folder into your `World of Warcraft\\_retail_\\Interface\\AddOns\\` directory.
4.  Restart World of Warcraft and ensure the addon is enabled on the character selection screen.

---

## ⚙️ Usage & Interface

Toxic BlackList is designed for ease of use with multiple access points.

### Main Window

Open the main window by typing `/tbl`, or by right-clicking the minimap or floating button. From here, you can:
- View all players on the blacklist for the current realm.
- **Add** a player by name ( `+` button) or from your current **target** ( `aim` button).
- **Remove** (`-`) or **Edit** (`✎`) the selected player.
- Open the **Options** panel (gear icon).
- Get **Help** with a summary of features ( `?` icon).

Double-clicking a player or selecting them and pressing `✎` opens the **Edit Window**, where you can view their detailed information and write or update your reason for blacklisting them.

### Options Panel

The options panel (accessible via the gear icon, or by left-clicking the minimap/floating button) lets you customize every aspect of the addon:
- **General**: Enable or disable warnings for target, mouseover, nameplates, and group joins. Configure whisper and invite blocking.
- **Sound**: Choose custom warning sounds for different events.
- **On-screen Button**: Enable, resize, and reset the position of the floating button.

### Minimap & Floating Buttons

- **Minimap Button**: A handy icon on your minimap.
  - **Left-click**: Open Options.
  - **Right-click**: Open the Toxic BlackList window.
- **Floating Button**: A movable button you can place anywhere on the screen.
  - **Left-click**: Open Options.
  - **Right-click**: Open the Toxic BlackList window.
  - **Ctrl+Left-click**: Add/edit your current target.
  - **Ctrl+Right-click**: Quickly add your current target.
  - **Alt+Drag**: Move the button.

---

## ⌨️ Chat Commands

The main list commands can be used with `/blacklist`, `/tbl`, or `/blist`.

| Command | Alias | Description |
| :--- | :--- | :--- |
| `/tbl` | | Toggles the main Toxic BlackList window. |
| `/tbl <PlayerName> [reason]` | | Adds a player to the list, optionally with a reason. |
| `/blt [reason]` | `/blacklisttarget` | Adds your current target to the list, optionally with a reason. |
| `/removebl <PlayerName>` | `/removeblacklist` | Removes a player from the list. |
| `/removebl` | | Removes your current target from the list. |

---

## 🌐 Localization

This addon is fully localized for all World of Warcraft supported languages.

---

## 🤝 Contributing

Contributions are welcome! You can:
- **Submit a pull request (PR)** to add new features or fix bugs.
- **Report bugs** on the GitHub repository's issue tracker.
- **Help with localization** by translating the addon into your language.

---

## 👤 Author

**Drakeinhart**

