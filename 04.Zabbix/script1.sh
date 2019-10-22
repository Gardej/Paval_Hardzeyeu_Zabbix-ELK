#!/bin/bash
#1 Elastic
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cp /vagrant/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
yum -y install elasticsearch

#2 Kibana
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cp /vagrant/kibana.repo /etc/yum.repos.d/kibana.repo
yum -y install kibana

systemctl start elasticsearch
systemctl enable elasticsearch
systemctl start kibana
systemctl enable kibana

cp /vagrant/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
cp /vagrant/kibana.yml /etc/kibana/kibana.yml

systemctl restart elasticsearch
systemctl restart kibana

