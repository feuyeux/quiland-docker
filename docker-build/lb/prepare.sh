#!/bin/sh
sed -r -i "s/NNPP/${NP}/g" /etc/keepalived/keepalived.conf
sed -r -i "s/VIP/${VIP}/g" /etc/keepalived/keepalived.conf
