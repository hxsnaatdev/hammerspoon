#!/bin/bash
#
# switch_audio.sh - Cycle to the next audio device using SwitchAudioSource
# (https://github.com/deweller/switchaudio-osx)
#
# Usage:
#   switch_audio.sh output          # cycle output devices
#   switch_audio.sh input           # cycle input devices
#   switch_audio.sh output "MacBook Pro Speakers"   # jump straight to a named device
#
# Prints the name of the device that was switched TO (so Hammerspoon can
# show it in a notification).
#
# Requires: brew install switchaudio-osx

set -euo pipefail

SWITCH_BIN="$(command -v SwitchAudioSource || echo /opt/homebrew/bin/SwitchAudioSource)"

if [ ! -x "$SWITCH_BIN" ]; then
  echo "SwitchAudioSource not found. Install with: brew install switchaudio-osx" >&2
  exit 1
fi

TYPE="${1:-output}" # "output" or "input"
TARGET="${2:-}"     # optional: jump directly to this device name

if [[ "$TYPE" != "output" && "$TYPE" != "input" ]]; then
  echo "First argument must be 'output' or 'input'" >&2
  exit 1
fi

# If a specific device name was passed, just switch to it directly.
if [ -n "$TARGET" ]; then
  "$SWITCH_BIN" -t "$TYPE" -s "$TARGET"
  echo "$TARGET"
  exit 0
fi

# Get current device and full device list (one per line, in stable order).
CURRENT="$("$SWITCH_BIN" -t "$TYPE" -c)"
DEVICES=()
while IFS= read -r line; do
  [ -n "$line" ] && DEVICES+=("$line")
done < <("$SWITCH_BIN" -a -t "$TYPE")

COUNT=${#DEVICES[@]}
if [ "$COUNT" -eq 0 ]; then
  echo "No $TYPE devices found" >&2
  exit 1
fi

# Find index of current device in the list.
CURRENT_INDEX=-1
for i in "${!DEVICES[@]}"; do
  if [ "${DEVICES[$i]}" == "$CURRENT" ]; then
    CURRENT_INDEX=$i
    break
  fi
done

# Move to the next device, wrapping around to the start.
NEXT_INDEX=$(((CURRENT_INDEX + 1) % COUNT))
NEXT_DEVICE="${DEVICES[$NEXT_INDEX]}"

"$SWITCH_BIN" -t "$TYPE" -s "$NEXT_DEVICE"
echo "$NEXT_DEVICE"
