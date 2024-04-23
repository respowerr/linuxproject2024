#!/bin/bash

generate_password() {
    openssl rand -base64 12 | tr -d '/+=' | cut -c1-12
}

if [ ! -f "$1" ]; then
    echo "Erreur: fichier source inexistant"
    exit 1
fi

while IFS=':' read -r first_name last_name groups sudo password; do
    username="${first_name:0:1}${last_name}"
    if id "$username" &>/dev/null; then
        i=1
        while id "${username}${i}" &>/dev/null; do
            ((i++))
        done
        username="${username}${i}"
    fi
    
    primary_group="${groups%,*}"
    if ! grep -q "^$primary_group:" /etc/group; then
        sudo groupadd "$primary_group"
    fi
    
    secondary_groups="${groups#*,}"
    IFS=',' read -ra secondary_groups_array <<< "$secondary_groups"
    for group in "${secondary_groups_array[@]}"; do
        if ! grep -q "^$group:" /etc/group; then
            sudo groupadd "$group"
        fi
    done
    
    sudo useradd -m -c "$first_name $last_name" -g "$primary_group" -G "${secondary_groups//,/}" -s /bin/bash "$username"
    
    echo "$username:$password" | sudo chpasswd
    
    sudo chage -d 0 "$username"
    
    user_dir="/home/$username"
    mkdir -p "$user_dir"
    num_files=$((RANDOM % 6 + 5))
    for ((i=0; i<num_files; i++)); do
        file_size=$((RANDOM % 46 + 5))
        dd if=/dev/urandom of="$user_dir/file_$i" bs=1M count="$file_size" status=none
    done
    
done < "$1"

echo "Utilisateurs créés avec succès"