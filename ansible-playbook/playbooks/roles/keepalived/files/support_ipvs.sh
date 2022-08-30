#!/bin/bash

cat > /etc/sysconfig/modules/ip_vs.modules << EOF
#!/bin/sh
/sbin/modinfo -F filename ip_vs > /dev/null 2>&1
if [ $? -eq 0 ]; then
    /sbin/modprobe ip_vs
fi
EOF
chmod 755 /etc/sysconfig/modules/ip_vs.modules

cat > /etc/sysconfig/modules/xt_set.modules << EOF
#!/bin/sh
/sbin/modinfo -F filename xt_set > /dev/null 2>&1
if [ $? -eq 0 ]; then
    /sbin/modprobe xt_set
fi
EOF
chmod 755 /etc/sysconfig/modules/xt_set.modules
reboot

#lsmod | grep ip_vs
#lsmod | grep xt_set