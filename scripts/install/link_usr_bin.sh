link_usr_bin() {
    local source_dir="$PROJECT_ROOT/usr/bin"
    local target_dir="/usr/bin"

    if [ ! -d "$source_dir" ]; then
        echo "Notice: '$source_dir' directory not found, skipping."
        return 0
    fi

    if [ "$EUID" -ne 0 ]; then
        echo "Error: Linking binaries to $target_dir requires root privileges."
        echo "Please run the script with sudo: sudo ./install.sh"
        return 1
    fi

    echo "Linking binaries from $source_dir to $target_dir..."

    for item in "$source_dir"/*; do
        if [ -f "$item" ]; then
            local name=$(basename "$item")
            local target_path="$target_dir/$name"

            if [ -e "$target_path" ] || [ -L "$target_path" ]; then
                if [ -L "$target_path" ]; then
                    rm "$target_path"
                else
                    echo "Skipping $name: exists in $target_dir and is not a symlink."
                    continue
                fi
            fi

            ln -s "$item" "$target_path"
            echo "Linked binary: $name"
        fi
    done
}
