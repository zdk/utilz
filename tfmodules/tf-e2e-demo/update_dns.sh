#!/bin/bash

sudo gsed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$1/ /usr/local/etc/dnsmasq.d/track.conf
sudo gsed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$1/ /usr/local/etc/dnsmasq.d/track-api.conf
sudo brew services restart dnsmasq; sudo killall -HUP mDNSResponder
sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache
