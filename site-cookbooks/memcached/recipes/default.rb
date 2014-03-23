#
# Cookbook Name:: memcached
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'memcached' do
  action :install
end

template "memcached" do
  path "/etc/sysconfig/memcached"
  source "memcached.erb"
  owner "root"
  group "root"
  mode 0644
end

service "memcached" do
  action :restart
end
