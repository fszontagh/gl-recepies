#!/bin/bash

/usr/sbin/update-pciids


if [ ! -e "/etc/cron.weekly/update-pciids.sh" ]; then

echo "Adding pci update to cron..."
mkdir -pv /etc/cron.weekly/ &>/dev/null

cat > /etc/cron.weekly/update-pciids.sh << EOF
#!/bin/bash
/usr/sbin/update-pciids
EOF


fi;
