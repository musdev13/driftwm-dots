link_wallpapers() {
    local source_dir="$PROJECT_ROOT/wallpapers"
    local target_dir="$REAL_HOME/Pictures"
    local target_path="$target_dir/wallpapers"

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

    ln -s "$source_dir" "$target_path"
    echo "Linked wallpapers: $target_path"
}
