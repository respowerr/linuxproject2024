#!/bin/bash

SUID_FILE="/tmp/suid_files.txt"
SGID_FILE="/tmp/sgid_files.txt"

function fetch_suid_files {
    find / -type f -perm /4000 -print 2>/dev/null > "$SUID_FILE"
}

function fetch_sgid_files {
    find / -type f -perm /2000 -print 2>/dev/null > "$SGID_FILE"
}

[[ ! -f "$SUID_FILE" || ! -f "$SGID_FILE" ]] && {
    echo "Création des fichiers de sauvegarde."
    fetch_suid_files
    fetch_sgid_files
    echo "Fichiers de sauvegarde créés."
    exit 0
}

cp "$SUID_FILE" "${SUID_FILE}.old"
cp "$SGID_FILE" "${SGID_FILE}.old"

fetch_suid_files
fetch_sgid_files

changes_suid=$(diff "${SUID_FILE}.old" "$SUID_FILE")
changes_sgid=$(diff "${SGID_FILE}.old" "$SGID_FILE")

if [[ -n "$changes_suid" || -n "$changes_sgid" ]]; then
    echo "Les fichiers avec SUID ou SGID ont été modifiés."
    echo "Différences pour SUID :"
    echo "$changes_suid"
    echo "Différences pour SGID :"
    echo "$changes_sgid"
    echo "Dates de modification des fichiers litigieux :"
    echo "Fichiers avec SUID modifié :"
    stat -c "%n : %y" $(echo "$changes_suid" | grep '^>')
    echo "Fichiers avec SGID modifié :"
    stat -c "%n : %y" $(echo "$changes_sgid" | grep '^>')
else
    echo "Aucune modification dans les fichiers avec SUID ou SGID."
fi

rm "${SUID_FILE}.old" "${SGID_FILE}.old"