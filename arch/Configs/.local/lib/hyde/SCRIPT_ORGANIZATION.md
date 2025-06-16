# HyDE Script Organization Summary

This document provides a comprehensive overview of the organized script structure within the `hyde/` directory. All scripts have been categorized by functionality and moved into logical subdirectories.

## 📁 Directory Structure

```
hyde/
├── system/           # System control and hardware management
├── theming/          # Theme management and customization
├── ui/               # User interface and interactive tools
├── wallpaper/        # Wallpaper and color scheme management
├── utilities/        # General utility scripts
├── launchers/        # Application and service launchers
├── config/           # Configuration management
├── binaries/         # Binary executables and special files
└── pyutils/          # Python utilities (maintained as-is)
```

## 📋 Categorized Script Index

### 🔧 System (`system/`)
Hardware control, system monitoring, and core system functionality.

- `amdgpu.py` - AMD GPU control and management
- `battery.sh` - Battery status and icon display
- `batterynotify.sh` - Battery notification system
- `brightnesscontrol.sh` - Screen brightness control
- `cpuinfo.sh` - CPU information display
- `globalcontrol.sh` - Global system control functions
- `gpuinfo.sh` - GPU information display
- `hyprsunset.sh` - Blue light filter control
- `keyboardswitch.sh` - Keyboard layout switching
- `pm.sh` - Power management utilities
- `polkitkdeauth.sh` - Authentication management
- `resetxdgportal.sh` - XDG portal reset utility
- `sensorsinfo.py` - Hardware sensor information
- `systemupdate.sh` - System update management
- `volumecontrol.sh` - Audio volume control

### 🎨 Theming (`theming/`)
Theme selection, switching, and customization tools.

- `color.set.sh` - Color scheme configuration
- `font.sh` - Font management
- `shaders.sh` - Shader effects control
- `theme.import.py` - Theme import functionality
- `theme.patch.sh` - Theme patching utilities
- `theme.select.sh` - Theme selection interface
- `theme.switch.sh` - Theme switching logic
- `themeselect.sh` - Alternative theme selector
- `themeswitch.sh` - Alternative theme switcher

### 🖥️ UI (`ui/`)
User interface elements, pickers, and interactive tools.

- `calculator.sh` - Calculator interface
- `cliphist.sh` - Clipboard history manager
- `emoji-picker.sh` - Emoji selection tool
- `fzf_preview.sh` - Fuzzy finder preview functionality
- `fzf_wrapper.py` - Python fuzzy finder wrapper
- `glyph-picker.sh` - Glyph and symbol picker
- `keybinds.hint.py` - Keybinding hints (Python)
- `keybinds_hint.sh` - Keybinding hints (Shell)
- `notifications.py` - Notification system management
- `quickapps.sh` - Quick application launcher
- `rofilaunch.sh` - Rofi launcher interface
- `rofiselect.sh` - Rofi selection tool
- `waybar.py` - Waybar status bar management
- `wbarconfgen.sh` - Waybar configuration generator
- `wbarstylegen.sh` - Waybar style generator

### 🖼️ Wallpaper (`wallpaper/`)
Wallpaper management and color extraction tools.

- `swwwallbash.sh` - SWWW wallpaper with color extraction
- `swwwallcache.sh` - SWWW wallpaper caching
- `swwwallkon.sh` - SWWW wallpaper configuration
- `swwwallpaper.sh` - SWWW wallpaper setter
- `swwwallselect.sh` - SWWW wallpaper selector
- `wallbash.hypr.sh` - Hyprland wallpaper color integration
- `wallbash.print.colors.sh` - Color palette printer
- `wallbash.qt.sh` - Qt application color theming
- `wallbash.sh` - Main wallpaper color extraction
- `wallbashtoggle.sh` - Wallbash toggle utility
- `wallpaper.mpvpaper.sh` - MPV video wallpaper
- `wallpaper.sh` - General wallpaper management
- `wallpaper.swww.sh` - SWWW wallpaper backend

### 🛠️ Utilities (`utilities/`)
General purpose utilities and helper scripts.

- `animations.sh` - Animation control
- `cava.sh` - Audio visualizer
- `dontkillsteam.sh` - Steam process protection
- `fastfetch.sh` - System information display
- `gamemode.sh` - Gaming mode toggle
- `hypr.unbind.sh` - Hyprland keybinding management
- `hyprlock.sh` - Hyprland screen locker
- `idle-inhibitor.py` - Idle prevention system
- `lockscreen.sh` - Screen lock utility
- `mediaplayer.py` - Media player control
- `screenrecord.sh` - Screen recording utility
- `screenshot.sh` - Screenshot utility
- `testrunner.sh` - Test execution utility
- `weather.py` - Weather information display
- `windowpin.sh` - Window management utility
- `workflows.sh` - Workflow automation

### 🚀 Launchers (`launchers/`)
Application and service launch scripts.

- `gamelauncher.sh` - Game launcher interface
- `hyde-launch.sh` - HyDE system launcher
- `logoutlaunch.sh` - Logout/session management
- `sysmonlaunch.sh` - System monitor launcher

### ⚙️ Config (`config/`)
Configuration management and parsing utilities.

- `configuration.py` - Main configuration handler
- `parse.config.py` - Configuration file parser
- `parse.json.py` - JSON configuration parser
- `restore.config.sh` - Configuration restoration

### 📦 Binaries (`binaries/`)
Binary executables and special files.

- `gnome-terminal` - GNOME Terminal executable
- `grimblast` - Screenshot utility binary
- `hyde-config` - HyDE configuration binary
- `hyq` - Hyprland query utility

### 🐍 Python Utils (`pyutils/`)
*Maintained in original structure*

Python utility modules and dependencies.

- `compositor.py` - Compositor management
- `configuration.py` - Configuration utilities
- `logger.py` - Logging functionality
- `pip_env.py` - Python environment management
- `requirements.txt` - Python dependencies
- `xdg_base_dirs.py` - XDG directory utilities
- `wrapper/` - Additional wrapper utilities

## 🔄 Migration Notes

- All scripts retain their original filenames
- The `pyutils/` directory structure remains unchanged
- Binary files have been moved to `binaries/` for better organization
- Cross-references between scripts may need path updates if they reference other scripts directly

## 📖 Usage

Each category serves a specific purpose:

- **System**: Core system functionality and hardware control
- **Theming**: Visual customization and theme management
- **UI**: Interactive user interface components
- **Wallpaper**: Background and color scheme management
- **Utilities**: General-purpose helper tools
- **Launchers**: Application and service starters
- **Config**: Configuration file management
- **Binaries**: Executable programs and special files

This organization improves maintainability, makes it easier to locate specific functionality, and provides a clearer understanding of the HyDE ecosystem's components.