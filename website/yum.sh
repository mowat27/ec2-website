# shellcheck disable=SC2164 
# shellcheck disable=SC2148

yum update -y
yum install httpd -y
chkconfig httpd on
service httpd start
cd /var/www/html