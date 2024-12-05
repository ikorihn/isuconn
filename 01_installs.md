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

export PATH=$PATH:$(go env GOPATH)/bin
EOF

cat << EOF >> ~/.bash_profile
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
EOF

```


## 各種インストール
```shell
# pt-query-digest, htop
sudo apt install -y --fix-missing htop percona-toolkit dstat

# alp
curl -LO https://github.com/tkuchiki/alp/releases/download/v1.0.21/alp_linux_amd64.tar.gz
tar zxvf alp_linux_amd64.tar.gz
sudo install ./alp /usr/local/bin
rm alp_linux_amd64.tar.gz alp


# go install
go install golang.org/x/tools/cmd/goimports@latest
```
