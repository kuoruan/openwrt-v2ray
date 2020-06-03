# openwrt-v2ray

V2Ray for OpenWrt

OpenWrt/LEDE 上可用的 V2Ray

[![Release Version](https://img.shields.io/github/release/kuoruan/openwrt-v2ray.svg)](https://github.com/kuoruan/openwrt-v2ray/releases/latest) [![Latest Release Download](https://img.shields.io/github/downloads/kuoruan/openwrt-v2ray/latest/total.svg)](https://github.com/kuoruan/openwrt-v2ray/releases/latest) [![Releases Download](https://img.shields.io/github/downloads/kuoruan/openwrt-v2ray/total.svg)](https://github.com/kuoruan/openwrt-v2ray/releases)

For luci-app-v2ray, please head to [kuoruan/luci-app-v2ray](https://github.com/kuoruan/luci-app-v2ray)

## Install via OPKG

1. Add new opkg key:

```sh
wget -O kuoruan-public.key http://openwrt.kuoruan.net/packages/public.key
opkg-key add kuoruan-public.key
```

2. Add opkg repository:

```sh
echo "src/gz kuoruan_packages http://openwrt.kuoruan.net/packages/releases/$(. /etc/openwrt_release ; echo $DISTRIB_ARCH)" \
  >> /etc/opkg/customfeeds.conf
```

> Replace `http://` with `https://` if you like.

3. Install package:

```sh
opkg update
opkg install v2ray-core
```

For minimal package:

```sh
opkg update
opkg install v2ray-core-mini
```

4. Upgrade package:

```sh
opkg update
opkg upgrade v2ray-core
```

## Manual Install

- Download pre build ipk file from [releases](https://github.com/kuoruan/openwrt-v2ray/releases)

- Upload file to your router, install it with ssh command.

```sh
opkg install v2ray-core*.ipk
```

Depends:

* ca-certificates

Bin files will install in `/usr/bin`.

## Custom build

1. Use the latest [OpenWrt SDK](https://downloads.openwrt.org/snapshots/) or with source code in master branch (requires golang modules support, commit [openwrt/packages@7dc1f3e](https://github.com/openwrt/packages/commit/7dc1f3e0293588ebc544e8eee104043dd0dacaf5) and later).

2. Enter root directory of SDK, then download the Makefile:

```sh
git clone https://github.com/kuoruan/openwrt-v2ray.git package/v2ray-core
```

> For Chinese users, `export GOPROXY=https://goproxy.io` before build.

Start build:

```sh
./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

Network ---> Project V ---> <*> v2ray-core

Network ---> Project V ---> <M> v2ray-core-mini

make package/v2ray-core/{clean,compile} V=s
```

- You can custom the features in `V2Ray Mini Configuration` option.

3. UPX Compress

If you want to build with UPX compress, the UPX package is required.

```sh
git clone -b master --depth 1 https://github.com/kuoruan/openwrt-upx.git package/openwrt-upx
```

## Uninstall

```sh
opkg remove v2ray-core # v2ray-core-mini
```
