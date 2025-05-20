# check-updates.sh

A reliable Bash script for checking and installing system updates on Debian/Ubuntu systems, including WSL.  
Interactive by default, with optional quiet mode for auto-run scenarios.

---

## 🧰 Features

- 🟢 Checks for upgradable packages
- ❓ Asks before upgrading
- 🧹 Runs `autoremove` after upgrade
- 🤫 Optional `--quiet` mode for minimal output (ideal for `.bashrc` / cron)
- 🧾 Outputs clear status messages, with timestamps
- ✅ Designed for WSL/Ubuntu environments

---

## 💻 Usage

```bash
bash check-updates.sh              # Interactive mode (default)
bash check-updates.sh --quiet     # Quiet mode
bash check-updates.sh -q          # Same as --quiet

=== Checking for system updates ===
Started at: Mon May 20 15:12:30
→ Updating package lists from sources...
```

## 🧪 Example (interactive mode)
```bash
→ Checking which packages can be upgraded...

→ 3 package(s) can be upgraded:
 - libfoo (1.2.3)
 - bar-utils (5.6.7)
 - something-core (0.9.0)

Do you want to upgrade now? (y/n): y

→ Installing available updates...
→ Removing unused packages...
=== Upgrade complete ===
Done at: Mon May 20 15:14:10
```

## 🛠 Installation (for auto-run)
To run the script automatically when you open a terminal (e.g. in WSL), add this to your ~/.bashrc:

```bash
if [ -t 1 ]; then
  [[ -f ~/check-updates.sh ]] && bash ~/check-updates.sh --quiet
fi
```

📁 File structure
check-updates.sh — main script

(Optional) Add bindings.json, aliases, or other tools as your admin toolkit grows

⚠️ Requirements
Ubuntu / Debian-based system (incl. WSL)

sudo installed and configured

Bash 4+


