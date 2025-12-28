#!/bin/sh
cd "$(dirname "$0")"

# Use bundled Wine
export WINEPREFIX="$HOME/.wine_ppro2024"
export WINE="$PWD/wine/bin/wine"
export WINESERVER="$PWD/wine/bin/wineserver"
export WINELOADER="$PWD/wine/bin/wine"
export WINEDLLPATH="$PWD/wine/lib64/wine:$PWD/wine/lib/wine"

# Create prefix if missing
if [ ! -d "$WINEPREFIX" ]; then
    echo "Creating Wine prefix..."
    "$WINE" winecfg  # Set to Windows 10 when GUI appears
fi

# Install DXVK
echo "Installing DXVK..."
tar -xzf assets/dxvk-2.7.1.tar.gz -C /tmp/
/tmp/dxvk-2.7.1/setup_dxvk.sh install --prefix "$WINEPREFIX"

# Copy MSXML3 and gdiplus
cp assets/msxml3.dll assets/msxml3r.dll "$WINEPREFIX/drive_c/windows/system32/"
cp assets/gdiplus.dll "$WINEPREFIX/drive_c/windows/system32/"

# Set DLL override
"$WINE" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v msxml3 /d native,builtin /f

# Install core fonts (via bundled winetricks)
./winetricks -q corefonts

# Launch Premiere Pro
cd ~/Music/"Adobe Premiere Pro 2024-cracked"/"Adobe Premiere Pro 2024"
"$WINE" "Adobe Premiere Pro.exe"
