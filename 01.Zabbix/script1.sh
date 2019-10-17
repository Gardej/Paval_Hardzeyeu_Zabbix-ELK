#!/bin/bash
yum install -y mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql
systemctl enable mariadb
systemctl start mariadb

mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'mypass'"

yum install -y http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pmypass zabbix

# Conf files and redirect
cp /vagrant/zabbix_server.conf /etc/zabbix/zabbix_server.conf
cp /vagrant/redir.conf /etc/httpd/conf.d/redir.conf
cp /vagrant/zabbix.conf /etc/httpd/conf.d/zabbix.conf

# Enable and start
systemctl enable httpd
systemctl enable zabbix-server
systemctl enable zabbix-agent
systemctl start httpd
systemctl start zabbix-server
systemctl start zabbix-agent

