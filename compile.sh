#!/bin/sh -ex
#
# Copyright (C) 2021-2024 Xingwang Liao
#

dir="$(cd "$(dirname "$0")" ; pwd)"

package_name="v2ray-core"
golang_commit="$OPENWRT_GOLANG_COMMIT"

cache_dir=${CACHE_DIR:-"~/cache"}

sdk_url_path=${SDK_URL_PATH:-"https://downloads.openwrt.org/snapshots/targets/x86/64"}
sdk_name=${SDK_NAME:-"-sdk-x86-64_"}

sdk_home=${SDK_HOME:-"~/sdk"}

sdk_home_dir="$(eval echo "$sdk_home")"

test -d "$sdk_home_dir" || mkdir -p "$sdk_home_dir"

sdk_dir="$(eval echo "$cache_dir/sdk")"
dl_dir="$(eval echo "$cache_dir/dl")"
feeds_dir="$(eval echo "$cache_dir/feeds")"

test -d "$sdk_dir" || mkdir -p "$sdk_dir"
test -d "$dl_dir" || mkdir -p "$dl_dir"
test -d "$feeds_dir" || mkdir -p "$feeds_dir"

cd "$sdk_dir"

if ! ( curl -L -s "$sdk_url_path/sha256sums" | \
	grep -- "$sdk_name" > sha256sums.small 2>/dev/null ) ; then
	echo "Can not find ${sdk_name} file in sha256sums."
	exit 1
fi

sdk_file="$(cut -d' ' -f2 < sha256sums.small | sed 's/*//g')"

if ! sha256sum -c ./sha256sums.small >/dev/null 2>&1 ; then
	curl -L -s -o "$sdk_file" "$sdk_url_path/$sdk_file"

	if ! sha256sum -c ./sha256sums.small >/dev/null 2>&1 ; then
		echo "SDK can not be verified!"
		exit 1
	fi
fi

cd "$dir"

file "$sdk_dir/$sdk_file"

case "$sdk_file" in
	*.tar.xz)
		untar="tar -Jxf"
		;;
	*.tar.gz)
		untar="tar -zxf"
		;;
	*.tar.bz2)
		untar="tar -jxf"
		;;
	*.tar)
		untar="tar -xf"
		;;
	*.tar.zst)
		untar="tar -I zstd -xf"
		;;
	*)
		echo "Unknown file format: $sdk_file"
		exit 1
		;;
esac

$untar "$sdk_dir/$sdk_file" -C "$sdk_home_dir" --strip=1

cd "$sdk_home_dir"

( test -d "dl" && rm -rf "dl" ) || true
( test -d "feeds" && rm -rf "feeds" ) || true

ln -sf "$dl_dir" "dl"
ln -sf "$feeds_dir" "feeds"

cp -f feeds.conf.default feeds.conf

sed -i '
s#git.openwrt.org/openwrt/openwrt#github.com/openwrt/openwrt#
s#git.openwrt.org/feed/packages#github.com/openwrt/packages#
s#git.openwrt.org/project/luci#github.com/openwrt/luci#
s#git.openwrt.org/feed/routing#github.com/openwrt/routing#
s#git.openwrt.org/feed/telephony#github.com/openwrt/telephony#
' feeds.conf

./scripts/feeds update -a

( test -d "feeds/packages/net/$package_name" && \
	rm -rf "feeds/packages/net/$package_name" ) || true

# replace golang with version defined in env
if [ -n "$golang_commit" ] ; then
	( test -d "feeds/packages/lang/golang" && \
		rm -rf "feeds/packages/lang/golang" ) || true

	curl "https://codeload.github.com/openwrt/packages/tar.gz/$golang_commit" | \
		tar -xz -C "feeds/packages/lang" --strip=2 "packages-$golang_commit/lang/golang"
fi

if [ -h "package/${package_name}" ] ; then
	rm -f "package/${package_name}"
fi

ln -s "$dir" "package/${package_name}"

if [ ! -d "package/openwrt-upx" ] ; then
	git clone -b master --depth 1 \
		https://github.com/kuoruan/openwrt-upx.git package/openwrt-upx
fi

./scripts/feeds install -a

make defconfig

make package/${package_name}/clean

cores=$(nproc)

if ! ( make package/${package_name}/compile -j$(expr $cores + 1) ) ; then
	make package/${package_name}/compile -j1 V=s
fi

cd "$dir"

find "$sdk_home_dir/bin/" -type f -exec ls -lh {} \;

find "$sdk_home_dir/bin/" -type f -name "${package_name}*.ipk" -exec cp -f {} "$dir" \;
