#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

if [[ ! -f "manifest.json" ]]; then
    echo "Error: manifest.json not found in current directory" >&2
    exit 1
fi

VERSION=$(python3 -c "import json,sys; print(json.load(open('manifest.json'))['version'])" 2>/dev/null) || {
    echo "Error: failed to parse manifest.json or extract version" >&2
    exit 1
}
echo "Found version: $VERSION"

OUTPUT_FILENAME="Steamgifts_Companion_v${VERSION}.zip"

if [[ -f "$OUTPUT_FILENAME" ]]; then
    rm -f "$OUTPUT_FILENAME"
    echo "Removed existing $OUTPUT_FILENAME"
fi

mapfile -t ITEMS < <(find . -maxdepth 1 -mindepth 1 \
    ! -name "$OUTPUT_FILENAME" \
    ! -name "$SCRIPT_NAME" \
    ! -name "*.ps1" \
    ! -name ".gitignore" \
    ! -name ".git" \
    ! -name "compress.ps1" \
    -printf '%f\n' | sort)

if [[ ${#ITEMS[@]} -eq 0 ]]; then
    echo "Warning: no files found to compress" >&2
    exit 1
fi

echo "Files to compress:"
for item in "${ITEMS[@]}"; do
    echo "  - $item"
done

zip -r "$OUTPUT_FILENAME" "${ITEMS[@]}"
echo ""
echo "Successfully created: $OUTPUT_FILENAME"

SIZE=$(du -k "$OUTPUT_FILENAME" | cut -f1)
echo "File size: ${SIZE} KB"
