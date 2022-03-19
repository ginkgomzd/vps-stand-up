#!/bin/sh

DEBIAN_FRONTEND=noninteractive

apt-get update

dpkg -s build-essential || apt-get install -y build-essential
dpkg -s git || apt-get install -y git

test -d ~/.ssh || mkdir ~/.ssh

ssh-keyscan -H github.com >> ~/.ssh/known_hosts

pushd /var/src/
git clone https://github.com/ginkgomzd/make-do.git
popd 2>/dev/null

pushd /var/src/make-do
make install
popd 2>/dev/null

