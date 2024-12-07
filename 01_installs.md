```shell
sudo apt update -y
sudo apt install -y --fix-missing git vim

cat << EOF >> ~/.vimrc
set nobackup
set noswapfile
set hidden
set showcmd
set number
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
syntax enable
set expandtab
set tabstop=4
set shiftwidth=4
set incsearch
set wrapscan
set hlsearch
set smartcase
EOF


cat << EOF >> ~/.bashrc
alias ls='ls -FG'
alias ll='ls -alFG --color=auto'

alias jcapp='sudo jounalctl -u ${APP_SERVICE_NAME}'
alias sc='sudo systemctl'
alias scl='sudo systemctl list-unit-files --type=service'
alias scla='sudo systemctl list-units --type=service --state=running'
alias scs='sudo systemctl status'
alias scr='sudo systemctl restart'
alias scsn='sudo systemctl status nginx'
alias scrn='sudo systemctl restart nginx'
alias scsm='sudo systemctl status mysql'
alias scrm='sudo systemctl restart mysql'
alias scss='sudo systemctl status ${APP_SERVICE_NAME}'
alias scrs='sudo systemctl restart ${APP_SERVICE_NAME}'

alias cdapp='cd ${APP_DIR}'

export PATH=$PATH:$(go env GOPATH)/bin

HISTSIZE=10000
EOF

cat << EOF >> ~/.bash_profile
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
EOF

```

```shell
echo 'export APP_SERVICE_NAME='<Goのサービス名>' >> ~/.bash_profile
echo 'export APP_DIR=/home/isucon/webapp/go' >> ~/.bash_profile
```

## 各種インストール

[./pprotein](./pprotein.md)

## etcをホームにコピーする

```
# nginx
mkdir -p ~/etc/nginx
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
sudo cp /etc/nginx/nginx.conf ~/etc/nginx/nginx.conf
sudo chmod a+w ~/etc/nginx/nginx.conf
# sudo ln -s ~/etc/nginx/nginx.conf /etc/nginx/nginx.conf

mkdir -p ~/etc/nginx/sites-enabled
sudo cp -r /etc/nginx/sites-enabled /etc/nginx/sites-enabled.org
sudo cp -r /etc/nginx/sites-enabled/* ~/etc/nginx/sites-enabled/
sudo chmod a+w ~/etc/nginx/sites-enabled/*

mkdir -p ~/etc/nginx/sites-available
sudo cp -r /etc/nginx/sites-available /etc/nginx/sites-available.org
sudo cp -r /etc/nginx/sites-available/* ~/etc/nginx/sites-available/
sudo chmod a+w ~/etc/nginx/sites-available/*


# mysql
mkdir -p ~/etc/mysql
sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.org
sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf ~/etc/mysql/
sudo chmod a+w ~/etc/mysql/mysqld.cnf

## ulimit
mkdir -p ~/etc/security
sudo cp /etc/security/limits.conf /etc/security/limits.conf.org
sudo cp /etc/security/limits.conf ~/etc/security/limits.conf
sudo chmod a+w ~/etc/security/limits.conf
```
