#!/bin/bash
IPT=/usr/sbin/iptables

POLICY=DROP
LAN=ens224
WAN=ens192
################x####################
$IPT -F INPUT
$IPT -F

$IPT --flush
$IPT --delete-chain
###################################

$IPT -P INPUT $POLICY
$IPT -P FORWARD $POLICY
$IPT -P OUTPUT $POLICY

###################################
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

#$IPT -A INPUT -i $LAN -j ACCEPT
#$IPT -A OUTPUT -o $LAN -j ACCEPT

#$IPT -A INPUT -i $WAN -j ACCEPT
#$IPT -A OUTPUT -o $WAN -j ACCEPT



$IPT -I INPUT -i $WAN -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -I INPUT -p tcp -s 89.218.153.38  -j ACCEPT

$IPT -A INPUT -j $POLICY


$IPT -I OUTPUT -o $WAN -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
############### DEBUG #############
$IPT -I INPUT -i $WAN -p tcp --dport 22 ! -s 89.218.153.38 -j LOG  --log-prefix "Iptables: SSH 22 ATЕEMPT"

$IPT -L -v
