#!/bin/bash

__create_ssh_user() {
# Create a user to SSH into as.
/usr/sbin/useradd $SSH_USERNAME
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_USERNAME)
echo ssh $SSH_USERNAME password: $SSH_USERPASS
}

__fix_ssh_root() {
# Change root password and SSH login fix. Otherwise user is kicked off after login (uncomment sed for Ubuntu)
echo root:$SSH_ROOTPASS
echo root:$SSH_ROOTPASS | chpasswd
mkdir /var/run/sshd
/usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
/usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
#sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
}

__show_variables() {
echo "========================================================================"
echo "    You can now connect to this SSH Server using:"
echo "    While runing container please use -p 2222:22 option"
echo "    ssh -p 2222 root:$SSH_ROOTPASS@HostIP "
echo ""
echo "    Please remember to change the above password as soon as possible!"
echo "========================================================================"
}

__get_metabase() {
mkdir /app
cd /app
wget $METABASE_LATEST
}

__supervisord_config() {
mkdir -p /var/log/supervisor
cat <<EOF >/etc/supervisord.conf
; Sample supervisor config file.

[unix_http_server]
file=/tmp/supervisor.sock   ; (the path to the socket file)

[supervisord]
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10           ; (num of main logfile rotation backups;default 10)
loglevel=info                ; (log level;default info; others: debug,warn,trace)
pidfile=/tmp/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false               ; (start in foreground if true;default false)
minfds=1024                  ; (min. avail startup file descriptors;default 1024)
minprocs=200                 ; (min. avail process descriptors;default 200)

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket

[program:sshd]
command=/usr/sbin/sshd -D
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
autorestart=true

[program:metabase]
command=java -jar /app/metabase.jar
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
autorestart=true

## Add more startup services below
EOF
}

# Call all functions
__create_ssh_user
__fix_ssh_root
__get_metabase
__supervisord_config
__show_variables
