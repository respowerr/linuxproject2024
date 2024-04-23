# Projet d'Administration Linux

## Partie bash

Ensemble de scripts permettant la création et l'affichage d'utilisateurs GNU/Linux avec leurs groupes.

#### UTILISATION
- `git clone https://github.com/respowerr/linuxproject2024`

- `cd linuxproject2024`

- `create "users.txt" with users and groups informations`

- `sudo ./menu.sh`

#### OPTIONS DANS SHOW.SH
- g : groupe : affiche uniquement les informations des utilisateurs dont un des groupes secondaires est groupe. 
- G : groupe : affiche uniquement les informations des utilisateurs dont le groupe primaire est groupe. 
- s : val : si val=0, affiche les informations des utilisateurs qui ne sont pas sudoers, si val=1, c’est l’inverse.
- u : nom : affiche toutes les informations sur l’utilisateur nom et seulement lui. 

## Partie serveur DNS

#### Creation du serveur DNS

- `apt-get install bind9`
- `Changement de l'adresse IP en statique dans /etc/network/interfaces`
- `Ajoutez dans /etc/dhcp/dhclient.conf la ligne : supersede domain-name-servers adresse_de_votre_DNS`
- `Mise en place du serveur Cache dans /etc/bind/db.root`
- `Mise en place du serveur Primaire : créer le fichier /etc/bind/db.principal.callidos`
- `Dans /etc/bind/named.conf.local indiquer la nature du serveur, le nom de notre zone et la localisation du fichier correspondant`
- `Compléter le fichier de zone /etc/bind/db.principal.callidos. `
- `Configurer la zone reverse`
- `Mise en place du serveur Secondaire en le déclarant dans : /etc/bind/named.conf.local`
- `Rajouter dans la déclaration de zone "masterfile-format text;"`
- `Configuration pour l'interraction entre le serveur Primaire et Secondaire`
- `Ajout de "notify yes;" ainsi que "allow-transfer { 100.0.2.4; };"`
- `TEST : Modifier le numéro de série SOA du serveur primaire et voir si le secondaire le télécharge correctement. Ainsi que mettre hors ligne le serveur primaire secondaire pour voir si les requests DNS des machines local soient bien résolues par le serveur secondaire.`

2024 - Respowerr && Amlezia && SnikiEP