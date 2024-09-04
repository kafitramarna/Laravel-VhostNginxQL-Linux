#!/bin/bash

WORKDIR_FILE="workdir.txt"

# Fungsi untuk memeriksa apakah direktori kerja ada
is_working_directory_exist() {
    if [ -f "$WORKDIR_FILE" ] && [ -s "$WORKDIR_FILE" ]; then
        return 0
    else
        return 1
    fi
}

# Fungsi untuk memulai layanan dengan umpan balik
start_service_with_feedback() {
    local service_name=$1
    if sudo systemctl start "$service_name"; then
        echo "Layanan $service_name berhasil dimulai."
    else
        echo "Error: Gagal memulai $service_name."
        exit 1
    fi
}

# Fungsi untuk menghentikan layanan dengan umpan balik
stop_service_with_feedback() {
    local service_name=$1
    if sudo systemctl stop "$service_name"; then
        echo "Layanan $service_name berhasil dihentikan."
    else
        echo "Error: Gagal menghentikan $service_name."
        exit 1
    fi
}

# Fungsi untuk me-restart layanan dengan umpan balik
restart_service_with_feedback() {
    local service_name=$1
    if sudo systemctl restart "$service_name"; then
        echo "Layanan $service_name berhasil dimulai kembali."
    else
        echo "Error: Gagal me-restart $service_name."
        exit 1
    fi
}

# Fungsi untuk membuat virtual host
create_virtual_host() {
    if ! is_working_directory_exist; then
        echo "Error: Direktori kerja tidak dipilih!"
        exit 1
    fi

    workdir=$(cat "$WORKDIR_FILE")

    folders=$(ls -d "$workdir"/*/)

    nginx_conf_dir="/etc/nginx/sites-available/"
    nginx_enabled_dir="/etc/nginx/sites-enabled/"

    for folder in $folders; do
        folder_name=$(basename "$folder")
        vhost_conf="
server {
    listen 80;
    server_name dev.$folder_name.test;
    root $folder/public;
    index index.php index.html index.htm;
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    location ~ /\.ht {
        deny all;
    }
}
        "

        vhost_conf_path="${nginx_conf_dir}dev.${folder_name}.test"

        echo "$vhost_conf" | sudo tee "$vhost_conf_path" > /dev/null
        
        symlink_path="${nginx_enabled_dir}dev.${folder_name}.test"
        if [ ! -L "$symlink_path" ]; then
            sudo ln -s "$vhost_conf_path" "$symlink_path"
        fi
        
        hosts_entry="127.0.0.1 dev.${folder_name}.test"
        if ! grep -q "$hosts_entry" /etc/hosts; then
            echo "$hosts_entry" | sudo tee -a /etc/hosts > /dev/null
        fi

        sudo chown -R www-data:www-data "$folder"
        sudo chmod -R 777 "$folder"
    done

    echo "Virtual hosts telah dibuat."
}

# Pilih aksi
case "$1" in
    start)
        if is_working_directory_exist; then
            create_virtual_host
            start_service_with_feedback "nginx"
            start_service_with_feedback "php8.3-fpm"
            start_service_with_feedback "mysql"
        else
            echo "Error: Direktori kerja tidak dipilih!"
        fi
        ;;
    stop)
        stop_service_with_feedback "nginx"
        stop_service_with_feedback "php8.3-fpm"
        stop_service_with_feedback "mysql"
        ;;
    restart)
        restart_service_with_feedback "nginx"
        restart_service_with_feedback "php8.3-fpm"
        restart_service_with_feedback "mysql"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

