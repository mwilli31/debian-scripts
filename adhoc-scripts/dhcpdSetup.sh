#!/bin/bash
echo 'ddns-update-style interim;' > /etc/dhcp/dhcpd.conf
echo 'default-lease-time 600;' >> /etc/dhcp/dhcpd.conf
echo 'max-lease-time 7200;' >> /etc/dhcp/dhcpd.conf
echo 'authoritative;' >> /etc/dhcp/dhcpd.conf
echo 'log-facility local7;' >> /etc/dhcp/dhcpd.conf
echo 'subnet 192.168.122.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf
echo '	range 192.168.122.10 192.168.122.20;' >> /etc/dhcp/dhcpd.conf
echo '}' >> /etc/dhcp/dhcpd.conf
