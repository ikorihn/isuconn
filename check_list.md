# ISUCON チェックリスト

- [ ] CloudFormation による構築準備
- [ ] 前年度のマニュアル読んで手順確認
- [ ] ssh/configを作っておく

## 開始直後

### 環境構築

- [ ] ssh/config
- [ ] tmuxから3つのサーバーに接続して同時実行できるようにしておく
- [ ] authorized_keysをisuconユーザーのホームディレクトリにコピーしてisuconユーザーでsshできるようにする
```
sudo -u isucon mkdir -p /home/isucon/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /home/isucon/.ssh/authorized_keys
sudo chown isucon:isucon /home/isucon/.ssh/authorized_keys
```

- [ ] ツールのインストール
- [ ] pproteinのセットアップ
  
- [ ] webサーバが何か確認する

```bash
sudo systemctl list-units --type=service --state=running
```

- [ ] 言語をgoに変更する

- [ ] gitにsshできるようにする
    - 既に存在する鍵を利用する
```
scp ~/.ssh/git_rsa isu1:.ssh/id_rsa
scp ~/.ssh/git_rsa isu2:.ssh/id_rsa
scp ~/.ssh/git_rsa isu3:.ssh/id_rsa
```

- ssh できることを確認
```
ssh -T git@github.com
```


- [ ] リポジトリにソースをpush
    - ホームディレクトリを git root とする
    -  `du -sh *` で大きなファイルが有る場合はgitignoreする
    - `GOPATH` 配下もgitignoreすべし

```.gitignore
.*
!.gitignore
/pprof
```

- [ ] etcをレポジトリに追加する
    - /etcからファイルを移動し、シンボリックリンクをはる
    - mysqlはシンボリックリンクだと設定が反映されないため、デプロイスクリプトで ~/etc から /etc にコピーする運用とする


- benchが動くことを一応確認しておく

ベンチ実行して問題なければOK

- [ ] レポジトリを他のサーバーにpullする
2台目、3台目のサーバーで以下の手順を実施
```
git init
git remote add origin レポジトリURL
git fetch origin main
git reset --hard origin/main
git branch -M main
git branch --set-upstream-to=origin/main main
```

2台目、3台目でデプロイしてベンチが通ればOK


## 計測

- [ ] nginxのログフォーマットを変更する

```nginx.conf
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

- [ ] nginx再起動 `sudo systemctl restart nginx` 
- [ ] alp.yml の設定で path parameter のあるAPIをまとめる
/xxx/:id
/xxx/:id/yyy
のような場合は、 /xxx/:id を最後に記載するとうまくいく

(ex)
```
- '/api/user/.+/theme'
- '/api/user/.+/statistics'
- '/api/user/.+/icon'
- '/api/user/.+'
```


### slow log

- [ ] mysql でslow log を設定

[./mysql.md](./mysql.md)

- [ ] mysql再起動 `scrm`

- [ ] mysql で以下のコマンドを実行し、設定が変わっていることを確認
```
show variables like  'slow_query%';
show variables like  'long%';
```

### pprotein

[./pprotein.md](./pprotein.md)

- [ ] ビルド

## とりあえずやっとく

### /etc/mysql/my.cnf

- [ ] mysql8対策
```
disable-log-bin 
innodb_doublewrite = 0 
innodb_flush_log_at_trx_commit = 0
```

### too many open files 対策
1: ulimit の数を上げる
/etc/security/limits.conf
```
* soft nproc 65535
* hard nproc 65535
* hard nofile 65535
* soft nofile 65535
```

`sudo reboot`

`ulimit -n` して値が65535になっていればOK


2: nginx.conf をいじる

worker数は woker_processes で決まる。
auto になっている時は、 `ps aux | grep nginx` でプロセス数を数えればOK。autoであればCPU のコア数と同じになるはず。

```
worker_rlimit_nofile {65535 / worker数};
events {
    worker_connections {worker_rlimit_nofile / 2};
}
```

worker数が2の場合
```
worker_rlimit_nofile 32768;
events {
    worker_connections 16384;
}
```

worker数が4の場合
```
worker_rlimit_nofile 16384;
events {
    worker_connections 8192;
}
```

### 再起動対策

```
	// db.Open() が成功した直後にこれを入れる.
	for {
		err := db.Ping()
		if err == nil {
			break
		}
		log.Print(err)
		time.Sleep(time.Second * 2)
	}
	log.Print("DB ready!")
```


### DBへのCRUDの可視化
https://github.com/mazrean/isucrud/
```
go install github.com/mazrean/isucrud@latest
```
isucrud ./...


## やることなくなったら

### app
- [ ] コネクションプールの数を増やしてみる
- [ ] GOMAXPROCS の値を確認する

### nginx

- [ ] error log を確認して対応する
- [ ] 秘伝のタレのパラメータ試してみる

### mysql
- [ ] 秘伝のタレのパラメータ試してみる
- [ ] mysqltuner試してみる

## 再起動試験
- [ ] ベンチ実施後、全台で `sudo reboot` を実行する
- [ ] 起動後、アプリを操作し、ベンチによる変更が保存されていることを確認する

## 提出前

- [ ] slowlog を切る
- [ ] nginx のアクセスログの出力をオフにする (http > `access_log off;` )
- [ ] pproteinを落とす
```
sudo systemctl stop pprotein
sudo systemctl disable pprotein
sudo systemctl stop pprotein-agent
sudo systemctl disable pprotein-agent
```

- [ ] appのログを切る (go の middlewareのコード削除など)
