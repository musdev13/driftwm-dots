link_etc() {
    local source_dir="$PROJECT_ROOT/etc"
    local target_dir="/etc"

    if [ ! -d "$source_dir" ]; then
        echo "Notice: '$source_dir' directory not found, skipping."
        return 0
    fi

    if [ "$EUID" -ne 0 ]; then
        echo "Error: Installing files to $target_dir requires root privileges."
        return 1
    fi

    echo "Installing files from $source_dir to $target_dir..."

    for dir in "$source_dir"/*/; do
        [ -d "$dir" ] || continue

        local name=$(basename "$dir")
        local target_subdir="$target_dir/$name"
        local source_subdir="${dir%/}"

        mkdir -p "$target_subdir"

        for item in "$source_subdir"/*; do
            [ -f "$item" ] || continue

            local file=$(basename "$item")
            local target_path="$target_subdir/$file"

            cp -f "$item" "$target_path"
            chown root:root "$target_path"

            if [ "$name" = "sudoers.d" ]; then
                chmod 440 "$target_path"
            fi

            echo "Installed: $target_path"
        done
    done
}
