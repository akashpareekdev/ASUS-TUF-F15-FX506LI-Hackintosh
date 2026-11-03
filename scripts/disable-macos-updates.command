#!/bin/bash
# Turns off macOS software updates as completely as macOS allows. Run in macOS Terminal:
#   bash /Volumes/OPENCORE/macos/disable-updates.command
# It asks for your password once (sudo). It changes only update settings and adds a marked block to /etc/hosts.
# Undo: bash disable-updates.command --undo
set -u
MARK_BEGIN="# >>> hackintosh: block Apple software update servers >>>"
MARK_END="# <<< hackintosh: block Apple software update servers <<<"
HOSTS=/etc/hosts
DOMAINS="swscan.apple.com swdist.apple.com swcdn.apple.com mesu.apple.com gdmf.apple.com updates.cdn-apple.com updates-http.cdn-apple.com xp.apple.com gs.apple.com"

sudo -v || { echo "Need an administrator password."; exit 1; }

strip_block() { sudo sed -i '' "/$MARK_BEGIN/,/$MARK_END/d" "$HOSTS"; }

if [ "${1:-}" = "--undo" ]; then
  strip_block
  for k in AutomaticCheckEnabled AutomaticDownload AutomaticallyInstallMacOSUpdates ConfigDataInstall CriticalUpdateInstall; do
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate $k -bool true; done
  sudo softwareupdate --schedule on
  sudo launchctl enable system/com.apple.softwareupdated 2>/dev/null
  echo "Updates re-enabled. Reboot to finish."; exit 0
fi

echo "1/5  System-wide Software Update preferences"
for k in AutomaticCheckEnabled AutomaticDownload AutomaticallyInstallMacOSUpdates ConfigDataInstall CriticalUpdateInstall; do
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate $k -bool false
done
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool false
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool false
sudo softwareupdate --schedule off

echo "2/5  This user's preferences"
for k in AutomaticCheckEnabled AutomaticDownload AutomaticallyInstallMacOSUpdates ConfigDataInstall CriticalUpdateInstall; do
  defaults write com.apple.SoftwareUpdate $k -bool false
done
defaults write com.apple.SoftwareUpdate LastRecommendedMajorOSBundleIdentifier ""
defaults write com.apple.systempreferences AttentionPrefBundleIDs 0   # removes the red badge in System Settings

echo "3/5  Block Apple's update servers in /etc/hosts (marked block, easy to remove)"
strip_block
{
  echo "$MARK_BEGIN"
  for d in $DOMAINS; do echo "0.0.0.0 $d"; done
  echo "$MARK_END"
} | sudo tee -a "$HOSTS" >/dev/null
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder 2>/dev/null

echo "4/5  Stop the update daemon from starting (may be refused with SIP on; that is fine)"
sudo launchctl disable system/com.apple.softwareupdated 2>&1 | sed 's/^/     /'
sudo launchctl bootout system/com.apple.softwareupdated 2>&1 | sed 's/^/     /'

echo "5/5  Refreshing the Dock/System Settings badge"
killall Dock 2>/dev/null; killall "System Settings" 2>/dev/null

echo
echo "Done. Settings now:"
defaults read /Library/Preferences/com.apple.SoftwareUpdate 2>/dev/null | grep -E "Automatic|ConfigData|CriticalUpdate"
echo "Restart the Mac once. OpenCore also blocks Apple firmware updates (BlacklistAppleUpdate)."
echo "Note: this also blocks 'softwareupdate -i' for things like Xcode Command Line Tools; use --undo to allow them."
