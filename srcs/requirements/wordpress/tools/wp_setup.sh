#!/bin/bash
set -e

# sleep 10

echo "=== Debut de l'initialisation de WordPress ==="

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)

echo "Attente de MariaDB..."
until mysqladmin ping -h mariadb --silent; do
    echo "MariaDB pas encore pret - on attend 2s..."
    sleep 2
done
echo "MariaDB est pret !"

cd /var/www/wordpress

if [ ! -f /var/www/wordpress/wp-config.php ]; then    
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --skip-check \
        --allow-root
    
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    echo "Configuration de WordPress terminee !"

    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --role=author \
        --allow-root
else
    echo "WordPress est deja configure"
fi

chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress
chmod -R 775 /var/www/wordpress/wp-content

echo "Demarrage de PHP-FPM..."
exec php-fpm8.2 -F --fpm-config /etc/php/8.2/fpm/php-fpm.conf