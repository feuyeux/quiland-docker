#!/bin/bash
sh /tmp/prepare.sh

export PATH=$PATH:/sbin
echo $PATH

if [ "$(hostname)" = "${MDW_HOST}" ]; then
	echo "::gpssh-exkeys::"
	su - gpadmin -c "gpssh-exkeys -f /tmp/gpdb-hosts"
	echo "::source greenplum_path::"
    su - gpadmin -c "source /usr/local/greenplum-db/greenplum_path.sh"
	echo "::gpinitsystem::"
	su - gpadmin -c "gpinitsystem -a -c /tmp/gpinitsystem_config -h /tmp/gpdb-hosts -s ${SMDW_HOST}"	
    echo "::export master directory::"
	su - gpadmin -c "export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1"
	echo "::psql::"
	su - gpadmin -c "psql -d template1 -c \"alter user gpadmin password 'pivotal'\""
	su - gpadmin -c "createdb gpadmin"
	#access from client
	su - gpadmin -c "echo "host all all 0.0.0.0/0 md5" >> /gpdata/master/gpseg-1/pg_hba.conf"
	su - gpadmin -c "gpstart -a"
else
	while true
	do 
	    echo "waiting master..."
	    sleep 30s
    done
fi
