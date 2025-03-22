# RDR2 Mod Toggler

A simple yet effective batch script to toggle mods between Red Dead Redemption 2 story mode and Red Dead Online.

![RDR2 Screenshot](![image](https://github.com/user-attachments/assets/dd561043-94df-4d5e-98cc-593620041027)
)

## Overview

RDR2 Mod Toggler solves a common problem for Red Dead Redemption 2 players who enjoy both modded story mode and Red Dead Online. The script automatically moves mod files between your game directory and a backup location, allowing you to quickly switch between modes without the tedious process of manually moving files.

## Features

- **One-Click Switching**: Easily toggle between modded Story Mode and clean Online play
- **Smart Restoration**: Only restores missing files, making the process faster
- **Auto-Detection**: Identifies additional .asi mod files that may not be explicitly listed
- **Steam Integration**: Creates desktop shortcuts for launching the appropriate game mode
- **Safety Checks**: Detects if Steam is running and warns about potential file access issues
- **Detailed Feedback**: Provides clear information about what files are being moved

## Installation

1. **Download** the `RDR2_Mod_Toggler.bat` file
2. **Edit** the script to match your setup:
   - Set `RDR2_FOLDER` to your RDR2 installation path
   - Set `MODS_BACKUP` to where you want mod files backed up
   - Update `MOD_FILES` and `MOD_FOLDERS` with your own (see Adding Mod Files below)
3. **Run** the script by double-clicking it

## Usage

1. Run `RDR2_Mod_Toggler.bat`
2. Choose an option from the menu:
   - `[1] Enable Mods (for Story Mode)`
   - `[2] Disable Mods (for Red Dead Online)`
   - `[3] Exit`
3. The script will move files as needed and create desktop shortcuts for easy launching

## Customization

### Adding Mod Files

To add additional mod files to the tracker, edit the `MOD_FILES` variable in the script, mod files need to be separated by a space:

```batch
set "MOD_FILES=asiloader.log dinput8.dll your-new-mod-file.dll"
```

### Adding More Mod Folders

To add additional mod folders, edit the `MOD_FOLDERS` variable, mod folders need to be separated by a space:

```batch
set "MOD_FOLDERS=LennysSimpleTrainer lml RampageFiles reshade-shaders your-new-folder"
```

## How It Works

The script operates in two main modes:

### Disabling Mods (for Online play)
- Moves all mod files and folders to your backup location
- Creates a desktop shortcut to launch Red Dead Online
- Removes the `.mods_active` flag

### Enabling Mods (for Story Mode)
- Checks which mod files and folders are missing from the game directory
- Only restores files that are actually needed
- Creates a desktop shortcut to launch Story Mode
- Sets the `.mods_active` flag

## Requirements

- Windows 10/11
- Red Dead Redemption 2 (Steam version)
- Basic file/folder write permissions

## Troubleshooting

### Steam Is Still Running Error
If you get a warning that Steam is running, it's recommended to close Steam before continuing. Moving files while the game or Steam is accessing them can cause issues.

### Files Not Moving Correctly
Make sure you have the correct paths set in the script and that you have permissions to write to both locations.

### Desktop Shortcuts Not Working
Make sure your Steam installation is working properly. The shortcuts use Steam's URL protocol to launch the correct game mode.

## License

This script is released under the MIT License. Feel free to modify and distribute it as needed.

## Acknowledgments

- Rockstar Games for creating Red Dead Redemption 2
- The modding community for making the game even better
- All the cowboys and cowgirls who inspired this tool

## Author

[Liliana Summers](https://blog.lilianasummers.com/))

---

**Disclaimer**: This tool is not affiliated with or endorsed by Rockstar Games. Use mods at your own risk and never use them in Online mode.
