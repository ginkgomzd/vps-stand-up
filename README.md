# VPS Stand-Up Util

	LAMP Server Configuration"\n"\ Ubuntu 20.04

## Install

Copy this repo to /var/src/vps-stand-up

``` shell
$> sh install.sh
```

## Configure

You can copy the `example.env` to `.env`, and update the configurations in it. It is included in the main Makefile.

## Run

```shell
$> make stand-up
```
... to run full setup.

Lock-files are created for certain recipes to prevent unecessary re-runs. Use `make reset` to fully remove all lock-files.
Look for *.pkg and conf.* files that are not committed to git to cherry-pick locks to remove.

Files in `/etc` modified by these scripts are backed-up when deployed with the ${REPLACE_ETC} helper. Back-ups of distro configuration files are saved in `./etc-backups` with a timestamp suffix.

## Use the Source
... Luke

## Sub-Makes

Modular install definitions should be placed in the `make/` dir.

The convention is to call these as a sub-make, e.g., `$(MAKE) -f make/php.mk`.

The consequences of this pattern are that:
 - includes in the main make will not be available
 - recipes in the main make will not be available
 - you can export definitions to make them available


## Installing System Packages

There is a pattern-rule that can be used to install deb packages. This is only available in the main Makefile.

e.g. To install, and then configure the postfix package:

``` make
postfix: postfix.pkg
	$(MAKE) -f make/postfix.mk
	@ touch $@
```
