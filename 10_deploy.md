
## rotate logs

```shell
function rotate_log() {
  cp $1 ${1%%.*}_bak.${1#*.}
  truncate -s 0 $1
}
rotate_log /var/log/nginx/access.log
rotate_log /var/log/nginx/error.log
rotate_log /var/log/mysql/slow.log
```

## delete old logs

```shell
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
```

## restart services
```shell
sudo systemctl restart mysql
sudo systemctl restart $APP_SERVICE_NAME
sudo systemctl restart nginx
```
