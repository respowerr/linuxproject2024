# Projet d'Administration Linux

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

2024 - Respowerr && Amlezia && SnikiEP