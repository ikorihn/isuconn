
passwordポリシーを無効化したい
```
validate_password.length = 0
validate_password.policy = LOW
```

my.cnfの場所
```
$ mysql --help | grep my.cnf
/etc/my.cnf /etc/mysql/my.cnf /usr/local/etc/my.cnf ~/.my.cnf
```

## バイナリログ無効化

my.cnf
```
disable-log-bin
```


## Slow query

my.cnf
```sql
[mysqld]
slow_query_log = 1
# MySQL 8.0.14 above
# log_slow_extra = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 0
# log_queries_not_using_indexes = 1
```

ログリセット
```shell
truncate -s 0 /var/log/mysql/slow.log
```

## pt-query-digest

http://www.percona.com/downloads/percona-toolkit/LATEST/

```shell
yum install percona-toolkit
apt install percona-toolkit
```

集計
```shell
pt-query-digest /var/log/mysql/slow.log --limit 10 | tee slowq.txt
pt-query-digest --limit 100% --since "`date '+%F %T' -d '-5 minutes' --utc`" /var/log/mysql/slow.log | tee slowq.txt
```



```
# if error was occuered
rm /var/lib/mysql/ib_logfile0
rm /var/lib/mysql/ib_logfile1
```


## その他設定

```
innodb_flush_log_at_trx_commit = 0 // 1に設定するとトランザクション単位でログを出力するが 2 を指定すると1秒間に1回ログファイルに出力するようになる
innodb_flush_method = O_DIRECT //データファイル/ログファイルの読み書き方式を指定
innodb_doublewrite = 0
innodb_log_writer_threads = off
innodb_buffer_pool_size = 128M // インスタンスのメモリサイズを超えるとエラーになるので注意
innodb_flush_log_at_timeout = 3
innodb_redo_log_capacity = 128M
key_buffer_size		= 16M
performance_schema = off
```



Check Parameters
```
mysql> select @@[param_name];
```
Add Index
```
ALTER TABLE [table_name] ADD INDEX [index_name]([column_name])
```
Drop Index
```
ALTER TABLE [table_name] DROP INDEX [index_name]
```
Show Index
```
SHOW INDEX FROM [table_name];
```
Show warning
```
SHOW WARNING\G
```
