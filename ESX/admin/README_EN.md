# 🛡️ ESX Admin Panel (QB Style)

This is a complete and modern administration script for ESX Legacy based FiveM servers. It features a clean and intuitive NUI interface, inspired by the QB-Core style, offering various tools for player, vehicle, and server management.

## ✨ Features

### 👑 General Admin
*   **Godmode:** Makes the administrator invincible.
*   **Noclip:** Allows flying and passing through walls (invisible).
*   **Revive:** Revives the administrator and restores health.
*   **TP Waypoint:** Instantly teleports to the waypoint marked on the map.
*   **Names / IDs (Head):** Shows player names and IDs above their heads (optimized by distance).
*   **Player Blips (Map):** Shows the location of all players on the map.
*   **Announcement:** Sends a highlighted message to all players in the chat.

### 👥 Player Management
By selecting a player from the list, you can:
*   **Goto:** Teleport to the player.
*   **Bring:** Bring the player to you.
*   **Revive:** Revive the player.
*   **Slay:** Kill the player.
*   **Kick:** Kick the player from the server (with reason).
*   **Freeze:** Freeze/Unfreeze the player.
*   **Spectate:** Watch the player's screen.
*   **Sit Vehicle:** Enter the player's vehicle as a passenger.
*   **Give Skin:** Give the skin menu to the player.

### 🚘 Vehicles
*   **Spawn Vehicle:** Categorized menu with hundreds of vehicles (Compacts, Sedans, SUVs, Sports, Super, etc.).
*   **Full Tuning:** Applies maximum tuning to the current vehicle.
*   **Save Garage:** Saves the current vehicle to the administrator's garage (database).
*   **Fix:** Instantly repairs and cleans the vehicle.
*   **Colors:** Changes the primary and secondary color of the vehicle (visual menu).
*   **Vehicle Dev Mode:** Displays technical vehicle information on screen (ID, Plate, Engine, Body, Fuel, RPM, Speed, Heading, Coordinates).

### 🔫 Weapons
*   **Give Weapons:** Pistol, Combat Pistol, AK-47, M4, Shotgun, Sniper.
*   **Melee Weapons:** Knife, Bat, Switchblade, Machete, Flashlight.
*   **Remove All:** Removes all weapons from inventory.

### 🛠️ Developer Tools (Dev Tools)
*   **Copy Vector3:** Copies current coordinates (x, y, z) to clipboard.
*   **Copy Vector4:** Copies coordinates and heading (x, y, z, h).
*   **Copy Heading:** Copies only the rotation (heading).
*   **Vehicle Dev:** Toggles vehicle debug mode.

### 🌍 Server Management
*   **Weather Options:** Changes server weather (Sunny, Rain, Snow, Halloween, etc.).
*   **Server Time:** Sets server time via a slider (0-23h).
*   **Kick All:** Kicks all players (Superadmin/God only).

## 📦 Installation

1.  Place the `admin` folder inside your server's `resources` directory.
2.  Add `ensure admin` to your `server.cfg`.
3.  Configure permissions in the database or `server.cfg` (the script checks `xPlayer.getGroup()`).

## 🎮 Usage

*   **Command:** `/admin`
*   **Hotkey:** `INSERT` (Default)

## ⚙️ Dependencies

*   `es_extended` (ESX Legacy)
*   `oxmysql` (For saving vehicles)
*   `esx_ambulancejob` (For reviving)

## 📝 Credits

Developed FaeL Dev the FiveM community.
