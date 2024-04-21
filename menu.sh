#!/bin/bash

PS3="Sélectionnez un script à exécuter : "

options=("Créer des utilisateurs" "Afficher les informations des utilisateurs" "Contrôler les fichiers SUID et SGID" "Quitter")

select opt in "${options[@]}"
do
    case $REPLY in
        1) ./create_users.sh ;;
        2) ./show_users.sh ;;
        3) ./check_suid_sgid.sh ;;
        4) echo "Au revoir !"; exit ;;
        *) echo "Option invalide";;
    esac
done
