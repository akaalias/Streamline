# https://github.com/LinusU/node-appdmg
# npm install -g appdmg

# Generate folder with icons (Icon.iconset) with the macOS app

iconutil -c icns ./Icon.iconset

appdmg ./appdmg.json ~/Desktop/Unblah.dmg

