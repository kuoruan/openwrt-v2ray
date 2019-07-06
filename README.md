# openwrt-v2ray

V2Ray for OpenWrt

OpenWrt/LEDE 上可用的 V2Ray

[![Release Version](https://img.shields.io/github/release/kuoruan/openwrt-v2ray.svg)](https://github.com/kuoruan/openwrt-v2ray/releases/latest) [![Latest Release Download](https://img.shields.io/github/downloads/kuoruan/openwrt-v2ray/latest/total.svg)](https://github.com/kuoruan/openwrt-v2ray/releases/latest) [![Releases Download](https://img.shields.io/github/downloads/kuoruan/openwrt-v2ray/total.svg)](https://github.com/kuoruan/openwrt-v2ray/releases)

For luci-app-v2ray, please head to [kuoruan/luci-app-v2ray](https://github.com/kuoruan/luci-app-v2ray)

## Install

- Download pre build ipk file from [releases](https://github.com/kuoruan/openwrt-v2ray/releases)

- Upload file to your router, install it with ssh command.

```sh
opkg install v2ray-core*.ipk
```

Bin files will install in ```/usr/bin```.

## Custom build

1. Use the latest [OpenWrt SDK](https://downloads.openwrt.org/snapshots/) or with source code in master branch (requires golang modules support, commit [openwrt/packages@7dc1f3e](https://github.com/openwrt/packages/commit/7dc1f3e0293588ebc544e8eee104043dd0dacaf5) and later).

2. Enter root directory of SDK, then download the Makefile:

```sh
git clone https://github.com/kuoruan/openwrt-v2ray.git package/v2ray-core
```

> For Chinese users, ```export GOPROXY=https://goproxy.io``` before build.

Start build:

```sh
./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

Languages ---> Go ---> <M> golang-v2ray-core-dev # Source
Network ---> Project V ---> <*> v2ray-core

make package/v2ray-core/{clean,compile} V=s
```

- You can custom the features in "V2Ray Configuration" option.

## Uninstall

```sh
opkg remove v2ray-core
```
