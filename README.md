# vCore Shops - Modern FiveM ESX Shop System 🛒
![Framework](https://img.shields.io/badge/Framework-ESX_Legacy-green)

This script is designed to improve your server. With its attractive overlay and user-friendly interface, I bet you'll find that many people will thank you for using vCoreShops.

## Features

* **Modern UI:** Clean, dark-themed interface
* **Cart System:** Real-time shopping cart. Add multiple items, adjust quantities, and see total costs before checking out.
* **Dynamic Shop Types:** Configure different types of stores (e.g., 24/7, Tech Store, Hardware Store) with unique inventories.
* **Secure:** Server-side validation for prices and inventory space.

## Requirements

* **ESX Legacy**
* **oxmysql** (or mysql-async)

##  Installation

1.  **Download** the repository.
2.  **Rename** the folder to exactly:

    vCore_Shops

    > ⚠️ **IMPORTANT:** The script includes a security check. If the folder is named differently, it will **not** start.
3.  **Drop** the folder into your `resources` directory.
4.  **Add Items:** Ensure the items listed in `config.lua` (e.g., `phone`, `bread`, `water`) exist in your database (`items` table).
5.  **Add to server.cfg:** = ensure vCore_Shops


## Configuration (`config.lua`)

* **`Config.ShopTypes`**: Define shop categories (e.g., "Tech Store") and which item categories they sell.
* **`Config.ShopLocations`**: Add coordinates for your shops and assign them a `type`.
* **`Config.Items`**: Define all sellable items, their price, label, and image filename.

## Adding Custom Images

1.  Take a picture of your item (png recommended).
2.  Name it exactly like the `image` property in your `config.lua`.
3.  Place the file in: `html/img/`.

## Support

If you encounter any issues, feel free to open an issue ticket on our discord.
discord.gg/vcore

---
*Made with ❤️ by NexusScripting / vCore Scripting*