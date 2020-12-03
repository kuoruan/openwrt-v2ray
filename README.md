# openwrt-xray

Xray for OpenWrt

## Build Guide

1. Use the latest [OpenWrt SDK](https://downloads.openwrt.org/snapshots/) or with source code in master branch (requires golang modules support, commit [openwrt/packages@7dc1f3e](https://github.com/openwrt/packages/commit/7dc1f3e0293588ebc544e8eee104043dd0dacaf5) and later).

2. Enter root directory of SDK, then download the Makefile:

```sh
git clone https://github.com/MoZhonghua/openwrt-xray
```

> For Chinese users, `export GOPROXY=https://goproxy.io` before build.

Start build:

```sh
./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

Network ---> Project X ---> <*> xray-core

make package/xray-core/{clean,compile} V=s
```

- You can custom the features in `Xray Mini Configuration` option.

3. UPX Compress

If you want to build with UPX compress, the UPX package is required.

```sh
git clone -b master --depth 1 https://github.com/kuoruan/openwrt-upx.git package/openwrt-upx
```

## Uninstall

```sh
opkg remove xray-core
```
