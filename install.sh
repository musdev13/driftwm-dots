#!/usr/bin/env bash

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo ~$REAL_USER)

link_dotconfigs() {
    local source_dir="dotconfig"
    local target_dir="$REAL_HOME/.config"

    if [ ! -d "$source_dir" ]; then
        echo "Error: '$source_dir' directory not found."
        return 1
    fi

    mkdir -p "$target_dir"
    echo "Linking configs from $source_dir to $target_dir..."

    for item in "$source_dir"/*; do
        if [ -d "$item" ]; then
            local name=$(basename "$item")
            local target_path="$target_dir/$name"
            local source_path="$(pwd)/$item"

            if [ -e "$target_path" ] || [ -L "$target_path" ]; then
                if [ -L "$target_path" ]; then
                    rm "$target_path"
                else
                    echo "Skipping $name: exists and is not a symlink."
                    continue
                fi
            fi

            ln -s "$source_path" "$target_path"
            echo "Linked config: $name"
        fi
    done
}

link_usr_bin() {
    local source_dir="usr/bin"
    local target_dir="/usr/bin"

    if [ ! -d "$source_dir" ]; then
        echo "Notice: '$source_dir' directory not found, skipping."
        return 0
    fi

    if [ "$EUID" -ne 0 ]; then
        echo "Error: Linking binaries to $target_dir requires root privileges."
        echo "Please run the script with sudo: sudo ./script.sh"
        return 1
    fi

    echo "Linking binaries from $source_dir to $target_dir..."

    for item in "$source_dir"/*; do
        if [ -f "$item" ]; then
            local name=$(basename "$item")
            local target_path="$target_dir/$name"
            local source_path="$(pwd)/$item"

            if [ -e "$target_path" ] || [ -L "$target_path" ]; then
                if [ -L "$target_path" ]; then
                    rm "$target_path"
                else
                    echo "Skipping $name: exists in $target_dir and is not a symlink."
                    continue
                fi
            fi

            ln -s "$source_path" "$target_path"
            echo "Linked binary: $name"
        fi
    done
}

link_wallpapers() {
    local source_dir="wallpapers"
    local target_dir="$REAL_HOME/Pictures"
    local target_path="$target_dir/wallpapers"
    local source_path="$(pwd)/$source_dir"

    if [ ! -d "$source_dir" ]; then
        echo "Notice: '$source_dir' directory not found, skipping."
        return 0
    fi

    mkdir -p "$target_dir"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        if [ -L "$target_path" ]; then
            rm "$target_path"
        else
            echo "Skipping wallpapers: exists and is not a symlink."
            return 0
        fi
    fi

    ln -s "$source_path" "$target_path"
    echo "Linked wallpapers: $target_path"
}

main() {
    echo "Starting installation..."
    
    link_dotconfigs
    link_usr_bin
    link_wallpapers
    
    echo "Installation completed successfully."
}

main "$@"
