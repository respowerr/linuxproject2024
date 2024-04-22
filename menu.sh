#!/bin/bash
echo "==== PROJET LINUX ===="
PS3="Votre choix : "

options=("Créer des utilisateurs" "Afficher les informations des utilisateurs" "Contrôler les fichiers SUID et SGID" "Quitter l'application")

select opt in "${options[@]}"
do
    case $REPLY in
        1) 
            if [ -f "fichier_source.txt" ]; then
                ./create.sh fichier_source.txt
            else
                echo "Le fichier source 'fichier_source.txt' n'existe pas."
            fi
            ;;
        2) ./show.sh ;;
        3) ./control.sh ;;
        4) echo "Au revoir !"; exit ;;
        *) echo "Option invalide";;
    esac
done
