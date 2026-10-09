#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Agent Mode
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Power
# @raycast.description Agent mode: the Mac never sleeps, even with the lid closed. Run again to go back to normal.

set -euo pipefail

if pmset -g | grep -qE '^\s*SleepDisabled\s+1'; then
  target=0
  message="💤 Normal mode: the Mac can sleep again"
else
  target=1
  message="🤖 Agent mode: sleep disabled (lid close included)"
fi

# Use passwordless sudo if it's set up for pmset, otherwise ask for the admin password.
if ! sudo -n /usr/bin/pmset -a disablesleep "$target" 2>/dev/null; then
  osascript -e "do shell script \"/usr/bin/pmset -a disablesleep $target\" with administrator privileges" >/dev/null
fi

echo "$message"
