#!/bin/bash

#1 Tomcat
yum -y install java-1.8.0-openjdk.x86_64
yum -y install tomcat tomcat-webapps tomcat-admin-webapps

systemctl start tomcat
systemctl enable tomcat
cp /vagrant/SampleWebApp.war /usr/share/tomcat/webapps/SampleWebApp.war
chmod -R 755 /usr/share/tomcat/
systemctl restart tomcat

#2 Logstash
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cp /vagrant/logstash.repo /etc/yum.repos.d/logstash.repo
yum -y install logstash
cp /vagrant/my.conf /etc/logstash/conf.d/my.conf
systemctl start logstash
systemctl enable logstash
