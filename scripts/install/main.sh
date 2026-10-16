main() {
    echo "Starting installation..."

    link_dotconfigs
    link_usr_bin
    link_wallpapers
    link_etc

    echo "Installation completed successfully."
}
