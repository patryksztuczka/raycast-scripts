# raycast-scripts

Personal [Raycast script commands](https://github.com/raycast/script-commands).

## Setup

1. Clone the repo:

   ```bash
   mkdir -p ~/Documents/personal && cd ~/Documents/personal
   git clone git@github.com:patryksztuczka/raycast-scripts.git
   ```

2. In Raycast: Settings → Extensions → **+** → **Add Script Directory** → pick `~/Documents/personal/raycast-scripts`.

## Scripts

### Toggle Agent Mode (`toggle-agent-mode.sh`)

Switches between two modes:

- **Agent mode**: `pmset -a disablesleep 1`. The Mac never sleeps, including with the lid closed, so long-running agents keep working.
- **Normal mode**: `pmset -a disablesleep 0`. Regular sleep settings apply again.

Don't put the laptop in a bag while agent mode is on. It keeps running and heats up.

#### Skip the password prompt

`pmset` needs root, so by default every toggle asks for the admin password. To allow just these two commands without a password, run once per machine:

```bash
echo "$USER ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1" \
  | sudo tee /etc/sudoers.d/pmset-agent-mode > /dev/null
sudo chmod 440 /etc/sudoers.d/pmset-agent-mode
sudo visudo -cf /etc/sudoers.d/pmset-agent-mode   # should print "parsed OK"
```

Check it works (should print nothing and not ask for a password):

```bash
sudo -n /usr/bin/pmset -a disablesleep 0
```

To remove it later:

```bash
sudo rm /etc/sudoers.d/pmset-agent-mode
```

#### Normal-mode sleep settings

Normal mode only turns `disablesleep` off. The idle timers have to be sane too, otherwise the Mac still never sleeps. Check with `pmset -g custom` that `sleep` isn't `0`. Recommended values:

```bash
sudo pmset -b sleep 10 displaysleep 5    # battery
sudo pmset -c sleep 30 displaysleep 15   # charger
```
