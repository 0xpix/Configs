#!/usr/bin/env bash

set -e

# === Paths ===
FONT_NAME="Hasklig"
PATCHED_FONT_NAME="Hasklug Nerd Font"
FONTS_DIR="$HOME/.local/share/fonts"
WORKDIR="$HOME/fonts/$FONT_NAME"
NERD_FONTS_REPO="$HOME/nerd-fonts"

echo "🧩 Installing dependencies..."
sudo apt update
sudo apt install -y fontforge python3-fontforge unzip wget

echo "📦 Downloading $FONT_NAME..."
mkdir -p "$WORKDIR"
cd "$WORKDIR"
wget -q https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip -O Hasklig.zip
unzip -o Hasklig.zip

echo "🔧 Cloning Nerd Fonts repo (if not already)..."
if [ ! -d "$NERD_FONTS_REPO" ]; then
  git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git "$NERD_FONTS_REPO"
fi

echo "🔤 Patching fonts..."
mkdir -p "$FONTS_DIR"
for file in "$WORKDIR"/TTF/*.ttf; do
  fontforge -script "$NERD_FONTS_REPO/font-patcher" "$file" --complete --outputdir "$FONTS_DIR"
done

echo "🧼 Cleaning up..."
rm -rf "$WORKDIR"

echo "🔄 Updating font cache..."
fc-cache -fv > /dev/null

echo "✅ Done! You can now set your terminal font to: \"$PATCHED_FONT_NAME\""
echo "💡 Tip: use 'fc-list | grep -i hasklug' to confirm the installed fonts."
