#
# Cookbook:: mongo
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
# package "mongodb" do
#   action [ :install ]
# end
#
# service "mongodb" do
#   action [ :enable, :start]
# end

apt_update 'update' do
  action [ :update ]
end

apt_repository 'mongodb-org' do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "xenial/mongodb-org/3.2"
  components ["multiverse"]
  keyserver "hkp://keyserver.ubuntu.com:80"
  key "EA312927"
end

package 'mongodb-org' do
  action [:install, :upgrade]
end

service 'mongod' do
  supports status: true, restart: true, reload: true
  action [ :enable, :start]
end

template '/etc/proxy.conf' do
  source 'proxy.conf.erb'
  # variables proxy_port: node['mongodb-org']['proxy_port']
  # notifies :restart, 'service[mongodb-org]'
end

link '/etc/proxy.conf' do
  to 'home/ubuntu/environment/proxy.conf'
  # notifies :restart, 'service[mongodb-org]'
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  # notifies :restart, 'service[mongodb-org]'
end
