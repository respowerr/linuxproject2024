#!/bin/bash

calculate_directory_size() {
    du -sh "$1" | awk '{print $1}'
}

primary_group=""
secondary_group=""
is_sudoer=-1
specific_user=""

while getopts "G:g:s:u:" opt; do
    case $opt in
        G) primary_group="$OPTARG" ;;
        g) secondary_group="$OPTARG" ;;
        s) is_sudoer="$OPTARG" ;;
        u) specific_user="$OPTARG" ;;
        \?) echo "Option invalide"; exit 1 ;;
    esac
done

while IFS=':' read -r username _ user_id group_id full_name user_home user_shell; do
    if [[ $user_id -ge 1000 && $user_id -lt 65534 ]]; then
        if [[ -n "$specific_user" && "$specific_user" != "$username" ]]; then
            continue
        fi
        if [[ -n "$primary_group" && "$primary_group" != "$(id -ng "$username")" ]]; then
            continue
        fi
        if [[ -n "$secondary_group" && ! $(id -nG "$username") =~ $secondary_group ]]; then
            continue
        fi
        if [[ $is_sudoer -eq 0 && $(sudo -lU "$username" &>/dev/null) ]]; then
            continue
        elif [[ $is_sudoer -eq 1 && ! $(sudo -lU "$username" &>/dev/null) ]]; then
            continue
        fi
        
        echo "Utilisateur : $username"
        IFS=' ' read -r first_name last_name <<< "$full_name"
        echo "Prénom : $first_name"
        echo "Nom : $last_name"
        echo "Login : $username"
        echo "Groupe primaire : $(id -ng "$username")"
        echo "Groupes secondaires : $(id -Gn "$username" | tr ' ' ',')"
        echo -n "Répertoire personnel : "
        calculate_directory_size "$user_home"
        if $(sudo -lU "$username" &>/dev/null); then
            echo "Sudoer : OUI"
        else
            echo "Sudoer : NON"
        fi
        echo ""
    fi
done < /etc/passwd