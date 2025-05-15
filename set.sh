#!/bin/bash
# Install a custom XKB layout with Colemak base and 8-layer support using LWIN as ISO_Level5_Shift

set -e

# Name of your layout
LAYOUT_NAME="unikeyboard"
LAYOUT_FILE_CONTENT='
partial alphanumeric_keys
xkb_symbols "basis" {

    name[Group1] = "Custom Unikeyboard with Colemak";

    // Left Win as ISO_Level5_Shift
    key <LWIN> {
        type[Group1] = "ONE_LEVEL",
        symbols[Group1] = [ ISO_Level5_Shift ]
    };

    // Example 8-layer Colemak key: AC01 = "a" position
    key <AC01> { type[Group1] = "EIGHT_LEVEL", symbols[Group1] = [ a, A, NoSymbol, NoSymbol, U0250, U1D00, NoSymbol, NoSymbol ] };
    key <AC02> { type[Group1] = "EIGHT_LEVEL", symbols[Group1] = [ r, R, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol ] };
    key <AC03> { type[Group1] = "EIGHT_LEVEL", symbols[Group1] = [ s, S, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol ] };
    key <AC04> { type[Group1] = "EIGHT_LEVEL", symbols[Group1] = [ t, T, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol ] };
    key <AC05> { type[Group1] = "EIGHT_LEVEL", symbols[Group1] = [ d, D, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol, NoSymbol ] };

    // Add the rest of Colemak keys similarly here...

    include "level5(rctrl_switch)"  // Optional extra Level5 support
};
'

# Check root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (e.g. sudo ./install_unikeyboard.sh)"
    exit 1
fi

echo "[*] Installing custom layout..."

# Write layout file
echo "$LAYOUT_FILE_CONTENT" > /usr/share/X11/xkb/symbols/$LAYOUT_NAME

# Optional: Add to evdev.xml for GUI tools
EVDEV_XML="/usr/share/X11/xkb/rules/evdev.xml"
if ! grep -q "$LAYOUT_NAME" "$EVDEV_XML"; then
    echo "[*] Adding layout to $EVDEV_XML..."
    sed -i "/<layoutList>/a \\
    <layout>\\
      <configItem>\\
        <name>$LAYOUT_NAME</name>\\
        <description>Custom Unikeyboard with Colemak and 8 Layers</description>\\
      </configItem>\\
    </layout>" "$EVDEV_XML"
fi

# Set layout immediately
setxkbmap $LAYOUT_NAME

echo "[✓] Custom layout '$LAYOUT_NAME' installed and active."

