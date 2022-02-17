#!/bin/bash

# Some additional info
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress.html

sudo yum update -y
sudo yum install -y httpd
sudo amazon-linux-extras install -y php7.4
sudo yum install php  php-mbstring php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}

#ImageMagick
sudo yum -y install php-pear php-devel gcc ImageMagick ImageMagick-devel
sudo bash -c "yes '' | pecl install -f imagick"
sudo bash -c "echo 'extension=imagick.so' > /etc/php.d/imagick.ini"

sudo yum install -y mc

sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;


#Install Wordpress /var/www/html/wordpress
curl https://wordpress.org/latest.tar.gz | sudo -u apache tar zx -C /var/www/html

sudo tee /etc/httpd/conf.d/wp.conf <<EOF
DocumentRoot /var/www/html/wordpress
<Directory /var/www/html/wordpress>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Require all granted
</Directory>
<Directory /var/www/html/wordpress/wp-content>
    Options FollowSymLinks
    Require all granted
</Directory>
EOF


sudo systemctl enable httpd
sudo systemctl enable php-fpm

sudo -u apache cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo -u apache sed -i 's/database_name_here/${db_name}/' /var/www/html/wordpress/wp-config.php
sudo -u apache sed -i 's/username_here/${db_user}/' /var/www/html/wordpress/wp-config.php

sudo -u apache sed -i 's/localhost/${db_host}/' /var/www/html/wordpress/wp-config.php
sudo -u apache sed -i 's/password_here/${db_pass}/' /var/www/html/wordpress/wp-config.php

sudo service php-fpm restart
sudo service httpd restart