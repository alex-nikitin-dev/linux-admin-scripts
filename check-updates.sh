#!/usr/bin/env bash
set -euo pipefail
export LANG=C

# Ensure sudo exists
command -v sudo >/dev/null 2>&1 || {
    echo "'sudo' is required but not installed."
    exit 1
}

# Parse flags
SILENT=false
for arg in "$@"; do
    case "$arg" in
        --quiet|-q)
            SILENT=true
            ;;
    esac
done

if $SILENT; then
    echo "Checking for updates..."
else
    echo "=== Checking for system updates ==="
    echo "Started at: $(date)"
    echo
    echo "→ Updating package lists from sources..."
fi

if $SILENT; then
    sudo apt-get update -qq
else
    sudo apt-get update
fi

if ! $SILENT; then
    echo
    echo "→ Checking which packages can be upgraded..."
fi

mapfile -t UPGRADABLE_LINES < <(apt-get --just-print upgrade | grep "^Inst" || true)
UPDATES_COUNT=${#UPGRADABLE_LINES[@]}

if (( UPDATES_COUNT > 0 )); then
    if $SILENT; then
        echo "$UPDATES_COUNT package(s) can be upgraded."
    else
        echo
        echo "→ $UPDATES_COUNT package(s) can be upgraded:"
        echo
        for line in "${UPGRADABLE_LINES[@]}"; do
            pkg=$(awk '{print $2}' <<< "$line")
            ver=$(awk -F '[()]' '{print $2}' <<< "$line" | awk '{print $1}')
            printf " - %s (%s)\n" "$pkg" "$ver"
        done
    fi

    echo
    read -rp "Do you want to upgrade now? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        if $SILENT; then
            echo "Upgrading packages..."
            sudo apt-get upgrade -y -qq
            echo "Cleaning up..."
            sudo apt-get autoremove -y -qq
            echo "Upgrade complete."
        else
            echo
            echo "→ Installing available updates..."
            sudo apt-get upgrade -y

            echo
            echo "→ Removing unused packages..."
            sudo apt-get autoremove -y

            echo
            echo "=== Upgrade complete ==="
        fi
        echo "Done at: $(date)"
    else
        $SILENT || echo "Upgrade skipped."
        echo "Done at: $(date)"
    fi
else
    if $SILENT; then
        echo "System is up to date."
    else
        echo
        echo "→ No updates available. System is up to date."
        echo "=== Update check finished ==="
    fi
    echo "Done at: $(date)"
fi
