#!/usr/bin/env bash

# Please Read the LICENSE and README in the repo: https://github.com/selfup/linux_go.git
# If you are reading this because you forked or cloned the repo you know where to find the files

set -e

if [[ -f .versions.env ]]
then
    source .versions.env
else
    curl -sSf https://raw.githubusercontent.com/selfup/bootstrapper/master/.versions.env
    source .versions.env
    rm .versions.env
fi

if [[ -d $HOME/go ]]
then
    rm -rf $HOME/go
fi

if [[ -d /usr/local/go ]]
then
    echo 'password might be required because go was found in /usr/local/go'
    
    sleep 1s
    
    sudo rm -rf /usr/local/go
fi

if [[ ! -f $GO_DL_VERSION.darwin-amd64.tar.gz ]]
then
    wget https://dl.google.com/go/$GO_DL_VERSION.darwin-amd64.tar.gz
fi

tar -C $HOME -xzf $GO_DL_VERSION.darwin-amd64.tar.gz

mkdir -p $HOME/golang/src/github.com
mkdir -p $HOME/golang/src/gitlab.com
mkdir -p $HOME/golang/src/bitbucket.org

touch $HOME/.bash_profile

GO_ROOT_SET=$(cat $HOME/.bash_profile | grep -q 'GOROOT=$HOME/go' || echo '9042')
GO_PATH_SET=$(cat $HOME/.bash_profile | grep -q 'GOPATH=$HOME/golang' || echo '9042')
PATH_GO_SET=$(cat $HOME/.bash_profile | grep -q 'PATH=$PATH:$GOROOT/bin:$GOPATH/bin' || echo '9042')

if [[ $GO_ROOT_SET -eq '9042' ]]
then
    echo 'export GOROOT=$HOME/go' >> $HOME/.bash_profile
fi

if [[ $GO_PATH_SET -eq '9042' ]]
then
    echo 'export GOPATH=$HOME/golang' >> ~/.bash_profile
fi

if [[ $PATH_GO_SET -eq '9042' ]]
then
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bash_profile
fi

source $HOME/.bash_profile

rm $GO_DL_VERSION.darwin-amd64.tar.gz

go version
