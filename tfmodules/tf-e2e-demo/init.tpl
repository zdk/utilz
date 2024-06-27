#!/bin/bash

set -e -o pipefail

curl -O https://packages.chef.io/files/stable/chef/14.5.33/ubuntu/18.04/chef_14.5.33-1_amd64.deb
sudo dpkg -i chef_14.5.33-1_amd64.deb
