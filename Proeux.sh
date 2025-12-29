#!/bin/bash
# =========================================================
# Gemini ppro-gnux V8: UI & MENU ACCELERATION (INTEL)
# =========================================================

# --- PATHS ---
export WINEPREFIX="$HOME/.wine_ppro2024"
export WINE_DIR="$PWD/assets/wine"
export PREMIERE_DIR="$HOME/Music/Adobe Premiere Pro 2024-cracked/Adobe Premiere Pro 2024"
export WINE="$WINE_DIR/bin/wine"

# --- 1. INTEL iGPU & MESA TWEAKS ---
export LIBVA_DRIVER_NAME=iHD
export MESA_LOADER_DRIVER_OVERRIDE=iris
export WINEESYNC=1
export WINEFSYNC=1

# --- 2. THE UI LAG KILLERS (Crucial) ---
export WINEDEBUG=-all
# These two variables tell Wine to stop waiting for the Window Manager to draw menus
export WINE_X11_NO_MITSHM=0
export WINE_NO_ASLR=1 

# --- 3. DLL OVERRIDES (For Menus & Export) ---
# gdiplus = Fixes UI anti-aliasing lag
# msxml3 = Fixes the Export panel data loading
# ir50_32 = Keeps that Intel codec crash away
export WINEDLLOVERRIDES="winemenubuilder.exe=d;mscoree=d;mshtml=d;ir50_32=d;gdiplus=n,b;msxml3=n,b"

# --- 4. PREPARE SYSTEM DLLS ---
# Ensuring the high-performance GDI+ and MSXML3 are in the right place
cp assets/gdiplus.dll assets/msxml3.dll "$WINEPREFIX/drive_c/windows/system32/" 2>/dev/null

# --- 5. REGISTRY: DISABLE UI EFFECTS ---
# We are turning off the "pretty" UI animations that choke the Intel iGPU
echo "🔧 Optimizing UI Performance..."
"$WINE" reg add 'HKEY_CURRENT_USER\Software\Adobe\Adobe Premiere Pro\24.0\Display' /v 'DisplayColorManagement' /t REG_DWORD /d 0 /f
"$WINE" reg add 'HKEY_CURRENT_USER\Software\Adobe\Common\Misc\Privacy' /v 'OptInToAnalytics' /t REG_DWORD /d 0 /f

# --- 6. LAUNCH ---
echo "🎬 Launching Premiere (Snappy UI Mode)..."
cd "$PREMIERE_DIR"

# Launching with 'stdbuf' to ensure the UI thread isn't being throttled
stdbuf -oL -eL "$WINE" "Adobe Premiere Pro.exe"

echo "Done."
