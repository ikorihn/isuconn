
```shell
# install
curl -LO https://github.com/tkuchiki/alp/releases/download/v1.0.21/alp_linux_amd64.tar.gz
tar -zxvf alp_linux_amd64.tar.gz
sudo install alp /usr/local/bin/alp
alp --version

cat /var/log/nginx/access.log | alp ltsv -r --sort=sum --output="count,method,uri,sum"
cat /var/log/nginx/access.log | alp ltsv -r --sort=sum --output="count,method,uri,sum" -m "/items/[0-9]+.json,/upload/[0-9a-z]+.jpg"
cat /var/log/nginx/access.log | alp ltsv -m "^/items/\d+\.json" --sort=sum --reverse --filters 'Time > TimeAgo("5m")'
cat /var/log/nginx/access.log | alp ltsv -m "^/items/\d+\.json","^/new_items/\d+\.json","/users/\d+\.json","/transactions/\d+.png","/upload/[0-9a-f]+\.jpg" --sort=sum --reverse --filters 'Time > TimeAgo("5m")' | notify_slack -snippet -filetype txt

truncate -s 0 /var/log/nginx/access.log
```

## nginxのログフォーマットを変更する

```
http {
  log_format ltsv "time:$time_local"
    "\thost:$remote_addr"
    "\tforwardedfor:$http_x_forwarded_for"
    "\treq:$request"
    "\tstatus:$status"
    "\tmethod:$request_method"
    "\turi:$request_uri"
    "\tsize:$body_bytes_sent"
    "\treferer:$http_referer"
    "\tua:$http_user_agent"
    "\treqtime:$request_time"
    "\tcache:$upstream_http_x_cache"
    "\truntime:$upstream_http_x_runtime"
    "\tapptime:$upstream_response_time"
    "\tvhost:$host";
  access_log /var/log/nginx/access.log ltsv;
}
```

```shell
nginx -t
sudo systemctl restart nginx
```

## 設定ファイル

```yaml
---
file: /var/log/nginx/access.log            # string
sort: sum            # max|min|avg|sum|count|uri|method|max-body|min-body|avg-body|sum-body|p1|p50|p99|stddev
reverse: true         # boolean
query_string: true
output: count,2xx,3xx,4xx,5xx,method,uri,min,max,sum,avg,p99

matching_groups:            # array
  - /api/isu/.+/icon
  - /api/isu/.+/graph
  - /api/isu/.+/condition
  - /api/isu/[-a-z0-9]+
  - /api/condition/[-a-z0-9]+
  - /api/catalog/.+

  - /isu/.+/graph
  - /isu/.+/condition
  - /isu/[-a-z0-9]+

  - \?jwt


# file:                       # string
# query_string_ignore_values: # boolean
# decode_uri:                 # boolean
# format:                     # string
# limit:                      # 5000
# noheaders:                  # boolean
# show_footers:               # boolean
# filters:                    # string
# pos_file:                   # string
# nosave_pos:                 # boolean
# percentiles:                # array
# ltsv:
#   apptime_label: # apptime
#   status_label:  # status code
#   size_label:    # size
#   method_label:  # method
#   uri_label:     # uri
#   time_label:    # time
# json:
#   uri_key:           # string
#   method_key:        # string
#   time_key:          # string
#   response_time_key: # string
#   body_bytes_key:    # string
#   status_key:        # string
# regexp:
#   pattern:              # string
#   uri_subexp:           # string
#   method_subexp:        # string
#   time_subexp:          # string
#   response_time_subexp: # string
#   body_bytes_subexp:    # string
#   status_subexp:        # string
# pcap:
#   server_ips:  # array
#   server_port: # number
```

