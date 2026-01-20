#!/bin/zsh

PATCH_DIR="./patch"

if [[ ! -d "$PATCH_DIR" ]]; then
    echo "Fehler: Verzeichnis $PATCH_DIR nicht gefunden!"
    exit 1
fi

echo "Wende Änderungen auf das Test-Verzeichnis an..."

# 1. Alle Patches anwenden
if [[ -d "$PATCH_DIR/patches" ]]; then
    for p in "$PATCH_DIR"/patches/*.patch; do
        echo "Wende an: ${p:t}"
        patch -p1 -N < "$p"
    done
fi

# 2. Neue Dateien rüberkopieren
if [[ -d "$PATCH_DIR/new_files" ]]; then
    echo "Kopiere neue Dateien..."
    # Kopiert den Inhalt von new_files (enthält plt-2.5a/...) in das aktuelle Verzeichnis
    rsync -av --exclude='.DS_Store' "$PATCH_DIR"/new_files/ .
fi

echo "Update abgeschlossen."