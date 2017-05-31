#!/bin/bash

if [ ! -n "${MDW_HOST}" ]; then
	echo "ERROR: MDW_IP, MDW_HOST cannot be null"
else
	echo "hostname=$(hostname)"
	echo "MDW_IP=${MDW_IP}, MDW_HOST=${MDW_HOST}"
	echo "SMDW_IP=${SMDW_IP}, SMDW_HOST=${SMDW_HOST}"
	echo "SDW1_IP=${SDW1_IP}, SDW1_HOST=${SDW1_HOST}"
	echo "SDW2_IP=${SDW2_IP}, SDW2_HOST=${SDW2_HOST}"
	
	echo "${MDW_IP} ${MDW_HOST}" >> /etc/hosts
	echo "${SMDW_IP} ${SMDW_HOST}" >> /etc/hosts
	echo "${SDW1_IP} ${SDW1_HOST}" >> /etc/hosts
	echo "${SDW2_IP} ${SDW2_HOST}" >> /etc/hosts
	
	touch /tmp/gpdb-hosts
	echo "${SMDW_HOST}" >> /tmp/gpdb-hosts
	echo "${SDW1_HOST}" >> /tmp/gpdb-hosts
	echo "${SDW2_HOST}" >> /tmp/gpdb-hosts
fi 

if [ ! -d "/gpdata/master" ]; then
    mkdir -p /gpdata/master /gpdata/gpdatap1 /gpdata/gpdatap2 /gpdata/gpdatam1 /gpdata/gpdatam2
	chown -R gpadmin: /gpdata
fi
service sshd start