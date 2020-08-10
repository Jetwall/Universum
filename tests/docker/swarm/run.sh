#!/bin/bash

HOSTNAME=swarm
MXHOST=localhost

service rsyslog start
service crond start

if [ ! -e /var/run/configure-swarm ]; then
    /opt/perforce/swarm/sbin/configure-swarm.sh -n \
        -p "$P4PORT" -u "$P4USER" -w "$P4PASSWD" \
        -H $HOSTNAME -e "$MXHOST"
    touch /var/run/configure-swarm
fi
echo '<?php phpinfo(); ?>' > /opt/perforce/swarm/public/phpinfo.php
for i in `seq 20`; do
    test -e /var/run/httpd/httpd.pid && break
    sleep 2
done

exec  --pid=$(cat $PID_FILE) -F /var/log/httpd/*
