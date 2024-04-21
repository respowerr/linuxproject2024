#!/bin/bash

format_size() {
    du -sh "$1" | cut -f1
}

group_primary=""
group_secondary=""
sudoer=-1
user=""

while getopts "G:g:s:u:" opt; do
    case $opt in
        G) group_primary="$OPTARG" ;;
        g) group_secondary="$OPTARG" ;;
        s) sudoer="$OPTARG" ;;
        u) user="$OPTARG" ;;
        *) echo "Option invalide"; exit 1 ;;
    esac
done

while IFS=':' read -r username _ uid gid comment home shell; do
    if [ "$uid" -ge 1000 ] && [ "$uid" -lt 65534 ]; then
        if [ -n "$user" ] && [ "$user" != "$username" ]; then
            continue
        fi
        if [ -n "$group_primary" ] && [ "$group_primary" != "$(id -ng "$username")" ]; then
            continue
        fi
        if [ -n "$group_secondary" ]; then
            if id -nG "$username" | grep -q "$group_secondary"; then
                :
            else
                continue
            fi
        fi
        if [ "$sudoer" -eq 0 ]; then
            if sudo -lU "$username" &>/dev/null; then
                continue
            fi
        elif [ "$sudoer" -eq 1 ]; then
            if ! sudo -lU "$username" &>/dev/null; then
                continue
            fi
        fi
        
        echo "Utilisateur : $username"
        IFS=' ' read -r first_name last_name <<< "$comment"
        echo "Prénom : $first_name"
        echo "Nom : $last_name"
        echo "Login : $username"
        echo "Groupe primaire : $(id -ng "$username")"
        echo "Groupes secondaires : $(id -Gn "$username" | tr ' ' ',')"
        echo -n "Répertoire personnel : "
        format_size "$home"
        if sudo -lU "$username" &>/dev/null; then
            echo "Sudoer : OUI"
        else
            echo "Sudoer : NON"
        fi
        echo ""
    fi
done < /etc/passwd
