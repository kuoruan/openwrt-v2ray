# openwrt-frp

V2Ray for OpenWrt

OpenWrt/LEDE 上可用的 V2Ray

[![Release Version](https://img.shields.io/github/release/kuoruan/openwrt-v2ray.svg)](https://github.com/kuoruan/openwrt-v2ray/releases/latest) [![Latest Release Download](https://img.shields.io/github/downloads/kuoruan/openwrt-v2ray/total.svg)](https://github.com/kuoruan/openwrt-v2ray/releases/latest)

## 安装说明

- 到 [release](https://github.com/kuoruan/openwrt-v2ray/releases) 页面下载最新版的编译文件（注：请根据你的路由器架构下载对应版本）

通常下载 ```v2ray-core_*.ipk``` 即可

### 文件说明

| 文件名 | 内容 | 说明 |
| ----- | --- | --- |
| v2ray_*.ipk | 仅含 v2ray | 只支持 Protobuf 格式配置文件 |
| v2ctl_*.ipk | 仅含 v2ctl | V2Ray 辅助工具 |
| v2ray-assets_*.ipk | 包含 geoip.dat 和 geosite.dat | IP 数据文件和域名数据文件 |
| v2ray-core_*.ipk | 完整包 | 包含以上所有内容 |

- 将文件上传到你的路由器上，进行安装

```sh
opkg install v2*.ipk
```

安装完毕，你可以在 ```/usr/bin``` 目录下找到对应的二进制文件。

## 编译说明

请使用最新版的 OpenWrt SDK 或 master 版源代码。

进入 SDK 根目录或源码根目录，执行命令下载 Makefile：

```sh
git clone https://github.com/kuoruan/openwrt-v2ray.git package/v2ray
```

编译流程：

```sh
./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

Languages  ---> Go  ---> <M> golang-v2ray-core-dev # 源码包，通常并不需要
Network  ---> Web Servers/Proxies  ---> <*> v2ray-core

make package/v2ray/{clean,compile} V=s
```

## 卸载说明

```sh
opkg remove v2ray-core
```
