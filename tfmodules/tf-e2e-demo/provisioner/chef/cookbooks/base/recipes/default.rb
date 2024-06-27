# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2018, Cybernetes.co
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'base::host'
include_recipe 'base::essential'
include_recipe 'base::nodejs'
include_recipe 'base::nginx'
