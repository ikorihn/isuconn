
[pprotein でボトルネックを探して ISUCON で優勝する](https://zenn.dev/team_soda/articles/20231206000000)

## アプリケーションのpprofを出力する

webサーバーにて

```shell
go get github.com/kaz/pprotein
```

echoの場合

```go
import (
	"github.com/kaz/pprotein/integration/echov4"
)

func main() {
	e := echo.New()
	e.Debug = true
	e.Logger.SetLevel(echolog.DEBUG)
	e.Use(middleware.Logger())
	cookieStore := sessions.NewCookieStore(secret)
	cookieStore.Options.Domain = "*.u.isucon.dev"
	e.Use(session.Middleware(cookieStore))
	// e.Use(middleware.Recover())

	echov4.EnableDebugHandler(e)

    // ...
}
```

chi
```go
import (
	"github.com/kaz/pprotein/integration"
)

func main() {

	r := chi.NewRouter()
	r.Mount("/", integration.NewDebugHandler())

}
```

別のポートで起動する場合

```go
import (
    "github.com/kaz/pprotein/integration/standalone"
)

func main() {

    // ....

    go func() {
        standalone.Integrate(":8888")
    }()

    // ....
}
```


## pproteinを動かすサーバーで実施

9000番ポートで起動する

```shell
sudo apt install -y graphviz gv

cd
wget https://github.com/kaz/pprotein/releases/download/v1.2.4/pprotein_1.2.4_linux_amd64.tar.gz
tar -xvf pprotein_1.2.4_linux_amd64.tar.gz

cat <<'EOF' > pprotein.service
[Unit]
Description=pprotein service

[Service]
ExecStart=/home/isucon/pprotein
WorkingDirectory=/home/isucon
Environment=PATH=$PATH:/usr/local/bin
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
sudo cp pprotein.service /etc/systemd/system/pprotein.service
sudo systemctl enable pprotein.service
sudo systemctl start pprotein.service
```

### Webサーバーで実施

```
# alp
wget https://github.com/tkuchiki/alp/releases/download/v1.0.21/alp_linux_amd64.tar.gz
tar -xvf alp_linux_amd64.tar.gz
sudo mv alp /usr/local/bin/alp
```

nginx.confで、解析できるフォーマットにする

```conf
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

### MySQL serverでagentを動かす
19000番ポートで起動する
```shell
# slp
wget https://github.com/tkuchiki/slp/releases/download/v0.2.1/slp_linux_amd64.tar.gz
tar -xvf slp_linux_amd64.tar.gz
sudo mv slp /usr/local/bin/slp

# pprotein-agent
wget https://github.com/kaz/pprotein/releases/download/v1.2.4/pprotein_1.2.4_linux_amd64.tar.gz
tar -xvf pprotein_1.2.4_linux_amd64.tar.gz

cat <<'EOF' > pprotein-agent.service
[Unit]
Description=pprotein-agent service

[Service]
ExecStart=/home/isucon/pprotein-agent
WorkingDirectory=/home/isucon
Environment=PATH=$PATH:/usr/local/bin
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
sudo cp pprotein-agent.service /etc/systemd/system/pprotein-agent.service
sudo systemctl enable pprotein-agent.service
sudo systemctl start pprotein-agent.service
```

スロークエリ出力を忘れない
/etc/mysql/my.cnf
```
[mysqld]
slow_query_log = 1
# MySQL 8.0.14 above
# log_slow_extra = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 0
# log_queries_not_using_indexes = 1
```

```
sudo chmod +rx /var/log/mysql/
sudo chmod +r /var/log/mysql/mysql-slow.log
```

### pproteinのsetting

```json
[
  {
    "Type": "pprof",
    "Label": "webapp",
    "URL": "http://192.168.1.10:8080/debug/pprof/profile",
    "Duration": 60
  },
  {
    "Type": "httplog",
    "Label": "nginx",
    "URL": "http://192.168.1.10:8080/debug/log/httplog",
    "Duration": 60
  },
  {
    "Type": "slowlog",
    "Label": "mysql",
    "URL": "http://192.168.1.11:19000/debug/log/slowlog",
    "Duration": 60
  }
]
```
