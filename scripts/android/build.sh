#!/bin/bash
set -euo pipefail

DEBUG_MODE=false
EXPORT_TYPE="--export-release"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -D|--debug)
            DEBUG_MODE=true
            EXPORT_TYPE="--export-debug"
            shift
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

REPOS_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPOS_ROOT" || { echo "Error: not a git repository"; exit 1; }

PROJECT_DIR="mber-base"
EXPORT_PRESET="Android"
OUTPUT_DIR="dist"
OUTPUT_FILE="mber-base.apk"

mkdir -p "$OUTPUT_DIR"

echo "=== M-BER Build System ==="
echo "Root: $REPOS_ROOT"

# ── Find Godot ──────────────────────────────────────────────────
GODOT_BIN=""
for candidate in godot4 godot; do
    if command -v "$candidate" &>/dev/null; then
        GODOT_BIN=$(command -v "$candidate")
        break
    fi
done

if [ -z "$GODOT_BIN" ]; then
    echo "Error: Godot executable not found in PATH."
    exit 1
fi

# ── Verify Godot version is 4.x ────────────────────────────────
GODOT_VERSION=$("$GODOT_BIN" --version 2>&1 | head -n1)
if ! echo "$GODOT_VERSION" | grep -qE '^4\.'; then
    echo "Error: found Godot but version is not 4.x: $GODOT_VERSION"
    echo "Make sure godot4 or the correct godot binary is in PATH."
    exit 1
fi
echo "Godot: $GODOT_BIN ($GODOT_VERSION)"

# ── Verify Android export templates are installed ───────────────
TEMPLATES_DIR="$HOME/.local/share/godot/export_templates"
if [ ! -d "$TEMPLATES_DIR" ]; then
    # macOS fallback
    TEMPLATES_DIR="$HOME/Library/Application Support/Godot/export_templates"
fi

ANDROID_TEMPLATE_FOUND=false
if [ -d "$TEMPLATES_DIR" ]; then
    if find "$TEMPLATES_DIR" -name "android_release.apk" -o -name "android_debug.apk" 2>/dev/null | grep -q .; then
        ANDROID_TEMPLATE_FOUND=true
    fi
fi

if [ "$ANDROID_TEMPLATE_FOUND" = false ]; then
    echo "Warning: Android export templates may not be installed."
    echo "In Godot editor: Editor > Manage Export Templates > Download."
    echo "Continuing anyway — Godot will produce its own error if templates are missing."
fi

# ── Check JDK ──────────────────────────────────────────────────
if ! command -v java &>/dev/null; then
    echo "Error: Java not found. Install JDK 17."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n1)
echo "Java: $JAVA_VERSION"

# ── Export ─────────────────────────────────────────────────────
if [ "$DEBUG_MODE" = true ]; then
    echo "Mode: DEBUG"
else
    echo "Mode: RELEASE"
fi

echo "Exporting: $PROJECT_DIR → $OUTPUT_DIR/$OUTPUT_FILE"

"$GODOT_BIN" --headless --path "$PROJECT_DIR" \
    "$EXPORT_TYPE" "$EXPORT_PRESET" \
    "../$OUTPUT_DIR/$OUTPUT_FILE"

echo "=== Build successful ==="
echo "Output: $OUTPUT_DIR/$OUTPUT_FILE"
