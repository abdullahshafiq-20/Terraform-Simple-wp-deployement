#!/bin/bash

# Basic Installations
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install -y php php-mysqlnd php-gd php-xml php-mbstring php-json

# DB installation
sudo yum install -y mariadb105-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

DB_ROOT_PASSWORD="WordPress@123"
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASSWORD="WordPress@456"

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
sudo mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DROP DATABASE IF EXISTS test;"
sudo mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# Creating wordpress user and pass
sudo mysql -u root -p"${DB_ROOT_PASSWORD}" <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and install WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/

# Set proper permissions
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/

# Create WordPress configuration file
cd /var/www/html/
sudo cp wp-config-sample.php wp-config.php

# Configure WordPress database settings
sudo sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sudo sed -i "s/username_here/${DB_USER}/" wp-config.php
sudo sed -i "s/password_here/${DB_PASSWORD}/" wp-config.php

# Generate unique salt keys
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
sudo sed -i "/$STRING/d" wp-config.php
echo "$SALT" | sudo tee -a wp-config.php > /dev/null

# Remove default Apache welcome page
sudo rm -f /var/www/html/index.html

# Restart Apache to apply changes
sudo systemctl restart httpd

# Create a simple info file for troubleshooting
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null

# Set up log file
echo "WordPress installation completed at $(date)" | sudo tee /var/log/wordpress-install.log

# Print database credentials (for your reference)
cat << EOF | sudo tee /root/wordpress-credentials.txt
WordPress Database Credentials:
================================
Database Name: ${DB_NAME}
Database User: ${DB_USER}
Database Password: ${DB_PASSWORD}
Database Root Password: ${DB_ROOT_PASSWORD}

Access WordPress at: http://YOUR_ALB_DNS/
EOF

echo "Installation complete! Check /root/wordpress-credentials.txt for database details."