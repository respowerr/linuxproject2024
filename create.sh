#!/bin/bash

create_secure_password() {
    openssl rand -base64 12 | tr -cd 'A-Za-z0-9' | cut -c1-12
}

if [ ! -e "$1" ]; then
    echo "Erreur: fichier source inexistant"
    exit 1
fi

while IFS=':' read -r first_name last_name group_list sudo password; do
    username="${first_name:0:1}${last_name}".lower()
    
    if id "$username" &>/dev/null; then
        index=1
        while id "${username}${index}" &>/dev/null; do
            ((index++))
        done
        username="${username}${index}"
    fi
    
    primary_group="${group_list%%,*}"
    [[ ! $(grep "^$primary_group:" /etc/group) ]] && sudo groupadd "$primary_group"
    
    secondary_groups="${group_list#*,}"
    IFS=',' read -ra groups_array <<< "$secondary_groups"
    for group in "${groups_array[@]}"; do
        [[ ! $(grep "^$group:" /etc/group) ]] && sudo groupadd "$group"
    done
    
    sudo useradd -m -c "${first_name} ${last_name}" -g "$primary_group" -G "${secondary_groups}" -s /bin/bash "$username"
    echo "$username:$password" | sudo chpasswd
    sudo chage -d 0 "$username"
    
    user_dir="/home/$username"
    mkdir -p "$user_dir"
    num_files=$(((RANDOM % 6) + 5))
    for ((i=0; i<num_files; i++)); do
        file_size=$(((RANDOM % 46) + 5))
        dd if=/dev/urandom of="$user_dir/file_$i" bs=1M count="$file_size" status=none
    done
    
done < "$1"

echo "Utilisateurs créés avec succès"