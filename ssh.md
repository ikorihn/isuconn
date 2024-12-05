
`~/.ssh/config`
```
Host isu1
  HostName xxxxxx
  IdentityFile ~/.ssh/id_rsa_isucon
  User isucon
  ServerAliveInterval 60
  LocalForward  11234 localhost:1234
  LocalForward  19999 localhost:19999
Host isu2
  HostName xxxxx
  IdentityFile ~/.ssh/id_rsa_isucon
  User isucon
  ServerAliveInterval 60
  LocalForward  21234 localhost:1234
  LocalForward  29999 localhost:19999
Host isu3
  HostName xxxxx
  IdentityFile ~/.ssh/id_rsa_isucon
  User isucon
  ServerAliveInterval 60
  LocalForward  31234 localhost:1234
  LocalForward  39999 localhost:19999

Host isu-pprotein
  HostName xxxxxxx
  IdentityFile ~/.ssh/private-isu-webapp-key.pem
  ServerAliveInterval 60
  User isucon
  LocalForward  11234 localhost:1234
  LocalForward  19999 localhost:19999
```

`/etc/hosts`

```
xxxxx isu1
xxxxx isu2
xxxxx isu3
```
