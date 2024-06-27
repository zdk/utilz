#!/bin/bash

ssh-add ~/.ssh/<domain>/aws/demo/deployer
terraform apply -input=false
