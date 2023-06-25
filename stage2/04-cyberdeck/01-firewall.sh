#!/bin/bash

iptables -F
iptables -X

iptables -A INPUT -p tcp --dport 22 -j ACCEPT #accept ssh
iptables -I INPUT -p tcp --dport 22 -m state --state NEW -j LOG --log-prefix "New SSH connection "
iptables -A INPUT -p tcp --dport 80 -j ACCEPT #accept http
iptables -I INPUT -p tcp --dport 80 -m state --state NEW -j LOG --log-prefix "New HTTP connection "
iptables -A INPUT -p tcp --dport 443 -j ACCEPT #accept https
iptables -I INPUT -p tcp --dport 443 -m state --state NEW -j LOG --log-prefix "New HTTPS connection "
iptables -A INPUT -p tcp --dport 21 -j ACCEPT #accept ftp
iptables -I INPUT -p tcp --dport 21  -m state --state NEW -j LOG --log-prefix "New FTP connection "
iptables -A OUTPUT -p tcp --sport 20 -j ACCEPT #accept ftp
iptables -I INPUT -p tcp --sport 20 -m state --state NEW -j LOG --log-prefix "New FTP connection "
iptables -A INPUT -p tcp --dport 53 -j ACCEPT #accept dns
iptables -I INPUT -p tcp --dport 53 -m state --state NEW -j LOG --log-prefix "New DNS connection "
iptables -A INPUT -p udp --dport 123 -j ACCEPT #accept ntp
iptables -I INPUT -p tcp --dport 123 -m state --state NEW -j LOG --log-prefix "New NTP connection "
iptables -A INPUT -p tcp --dport 161 -j ACCEPT #accept snmp
iptables -I INPUT -p tcp --dport 161 -m state --state NEW -j LOG --log-prefix "New SNMP connection "
iptables -A INPUT -p tcp --dport 23 -j ACCEPT #accept telnet
iptables -I INPUT -p tcp --dport 23 -m state --state NEW -j LOG --log-prefix "New TELNET connection "
iptables -A INPUT -p tcp --dport 25 -j ACCEPT #accept smtp
iptables -I INPUT -p tcp --dport 25 -m state --state NEW -j LOG --log-prefix "New SMTP connection "

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT #accept established connections to continue

iptables -A INPUT -p tcp -m state --state NEW -j LOG --log-prefix "INCOMING connection " # LOG incoming connections to syslog limit flood of messages

iptables-save > /etc/firewall.conf

echo '#!/bin/sh' > /etc/network/if-up.d/iptables
echo "iptables-restore < /etc/firewall.conf" >> /etc/network/if-up.d/iptables
chmod +x /etc/network/if-up.d/iptables