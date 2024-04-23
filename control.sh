#!/bin/bash

SUID_FILE="/tmp/suid_files.txt"
SGID_FILE="/tmp/sgid_files.txt"

get_suid_files() {
    find / -type f -perm /4000 2>/dev/null > "$SUID_FILE"
}

get_sgid_files() {
    find / -type f -perm /2000 2>/dev/null > "$SGID_FILE"
}

if [ ! -f "$SUID_FILE" ] || [ ! -f "$SGID_FILE" ]; then
    echo "Création des fichiers de sauvegarde..."
    get_suid_files
    get_sgid_files
    echo "Fichiers de sauvegarde créés."
    exit 0
fi

cp "$SUID_FILE" "$SUID_FILE.old"
cp "$SGID_FILE" "$SGID_FILE.old"

get_suid_files
get_sgid_files

diff_suid=$(diff "$SUID_FILE.old" "$SUID_FILE")
diff_sgid=$(diff "$SGID_FILE.old" "$SGID_FILE")

if [ -n "$diff_suid" ] || [ -n "$diff_sgid" ]; then
    echo "Attention : Les fichiers avec SUID ou SGID ont été modifiés !"
    echo "Différences pour SUID :"
    echo "$diff_suid"
    echo "Différences pour SGID :"
    echo "$diff_sgid"
    echo "Dates de modification des fichiers litigieux :"
    echo "Fichiers avec SUID modifié :"
    stat -c "%n : %y" $diff_suid
    echo "Fichiers avec SGID modifié :"
    stat -c "%n : %y" $diff_sgid
else
    echo "Aucune modification détectée dans les fichiers avec SUID ou SGID."
fi

rm "$SUID_FILE.old" "$SGID_FILE.old"
