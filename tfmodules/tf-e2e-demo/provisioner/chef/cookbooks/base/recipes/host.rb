# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2018, Cybernetes.co
#
# All rights reserved - Do Not Redistribute
#

execute 'hostnamectl set-hostname web-demo-basic' do
  user 'root'
  live_stream true
  action :run
end
