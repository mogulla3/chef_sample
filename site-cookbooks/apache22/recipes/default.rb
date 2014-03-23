#
# Cookbook Name:: apache22
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install
package 'httpd' do
  version '2.2.15-29.el6.centos'
  action :install
end

# Setup
service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
