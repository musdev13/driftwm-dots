link_dotconfigs() {
    local source_dir="$PROJECT_ROOT/dotconfig"
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

            if [ -e "$target_path" ] || [ -L "$target_path" ]; then
                if [ -L "$target_path" ]; then
                    rm "$target_path"
                else
                    echo "Skipping $name: exists and is not a symlink."
                    continue
                fi
            fi

            ln -s "$item" "$target_path"
            echo "Linked config: $name"
        fi
    done
}
