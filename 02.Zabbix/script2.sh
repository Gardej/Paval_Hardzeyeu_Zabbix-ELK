#!/bin/bash
yum install -y http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm
yum install -y zabbix-agent

cp /vagrant/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent
systemctl start zabbix-agent

#1.2 Active/passive mode configured via zabbix_agentd.conf (look above). Here I have installed zabbix-sender.
yum install -y zabbix-sender
# Configure trap (item) on server with key 'key_for_trapper' 
# zabbix_sender -vv -z 192.168.56.77 -s "Zabbix agent" -k key_for_trapper -o Hello

#2.2 Install tomcat and throw simple webapp
yum -y install java-1.8.0-openjdk.x86_64
yum -y install tomcat tomcat-webapps tomcat-admin-webapps
cp /vagrant/SampleWebApp.war /usr/share/tomcat/webapps/SampleWebApp.war

#2.1 Install tomcat and throw simple webapp
cp /vagrant/tomcat.conf /usr/share/tomcat/conf/tomcat.conf 
cp /vagrant/tomcat-catalina-jmx-remote-7.0.76.jar /usr/share/tomcat/lib/tomcat-catalina-jmx-remote-7.0.76.jar

#2.4 Execute script3.sh.
/vagrant/script3.sh 



