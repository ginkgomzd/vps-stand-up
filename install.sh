#!/bin/sh

DEBIAN_FRONTEND=noninteractive

dpkg -s build-essential || apt-get install -y build-essential
dpkg -s git || apt-get install -y git

test -d ~/.ssh || mkdir ~/.ssh

ssh-keyscan -H github.com >> ~/.ssh/known_hosts

git clone git@github.com:ginkgostreet/make-do.git

pushd make-do
make install
popd 2>/dev/null

