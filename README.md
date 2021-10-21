# VPS Stand-Up Util

	LAMP Server Configuration"\n"\

## Install

Copy this repo to /root/vps-stand-up

``` shell
$> sh install.sh
```

### GitHub Authentication

Add your github SSH keys to `/root/.ssh`, with proper permissions.

Create `/root/.ssh/config`
``` shell
Host github.com
	user git
	IdentityFile ~/.ssh/github_key

```

## Run

```shell
$> make stand-up
```
... to run full setup.

## Use the Source
... Luke
