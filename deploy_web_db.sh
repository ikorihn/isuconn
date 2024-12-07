#!/bin/bash
set -eux

date -R
echo "Deploying..."

# replace mysqld.cnf
if [ -e ~/etc/mysql/mysqld.cnf ]; then
  sudo cp ~/etc/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
fi

# replace nginx.conf
if [ -e ~/etc/nginx/nginx.conf ]; then
  sudo cp ~/etc/nginx/nginx.conf /etc/nginx/nginx.conf
fi

if [ -e ~/etc/nginx/sites-enabled ]; then
  sudo cp ~/etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/ || true
fi

if [ -e ~/etc/nginx/sites-available ]; then
  sudo cp ~/etc/nginx/sites-available/* /etc/nginx/sites-available/
fi

# replace limits.conf
if [ -e ~/etc/security/limits.conf ]; then
  sudo cp ~/etc/security/limits.conf /etc/security/limits.conf
fi

# delete old logs
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s

# restart services
sudo systemctl restart mysql
sudo systemctl restart nginx

date -R
echo "Finished deploying."
