# DiChat

### [Main Developer (Telegram)](https://t.me/lisowsky)

## DiChat.lua Description for GitHub Repository

**DiChat.lua** is a Lua script developed for the SAMP (San Andreas Multiplayer) platform. The script is designed to enhance the gameplay experience by managing in-game chat interactions, skipping unnecessary messages, and automating certain repetitive tasks. Below is a detailed description of the script's features and functionalities:

## Features

- **Automated Message Filtering:**
Automatically skips predefined "trash" messages to keep the chat clean and relevant.

- **Version and Update Management:**
Checks for updates by comparing the local script version with the version available on a remote server.
Automatically downloads and updates the script if a newer version is found.

- **Integration with MoonLoader:**
Utilizes MoonLoader for downloading updates and handling script dependencies.

- **Customizable Alerts and Notifications:**
Displays customizable in-game notifications and alerts to players.

- **Command Integration:**
Provides commands like **'/update'** to manually check for and apply updates.

## Usage

- **Installation:**
Download the script and place it in the MoonLoader scripts directory.
Ensure MoonLoader is installed and configured correctly.

- **Commands:**
**'/update'**: Manually checks for updates and applies them if available.

## Configuration

The script can be configured by modifying specific variables within the script. Key configurations include:

- **'update_url':** URL for checking updates.
- **'script_url':** URL from where the script is downloaded.
- **'update_path':** Path where the update information is stored.

## Requirements

- **SAMP (San Andreas Multiplayer):** A multiplayer modification for GTA: San Andreas.
- **MoonLoader:** A Lua script loader for SAMP.

## Contribution

Contributions are welcome! If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request.

## License

Apache License Version 2.0
