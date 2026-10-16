SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo ~"$REAL_USER")
