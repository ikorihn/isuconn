実行中のサービス一覧

```shell
systemctl
```

サービス起動
```shell
systectl start [service_name].service
systectl stop [service_name].service
systectl restart [service_name].service
```

サービスの自動起動設定[enable/disable]の一覧
```shell
systemctl list-unit-files -t service
```

サービスの自動起動有効化
```
systemctl enable [service_name].service
systemctl disable [service_name].service
```

journal
```shell
$ journalctl -u [service_name].service
-b 直近の起動ログ
-k エラーを強調する
-f リアルタイムな表示
```
