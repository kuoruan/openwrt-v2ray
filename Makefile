#
# Copyright (C) 2019-2020 Xingwang Liao
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=v2ray-core
PKG_VERSION:=4.28.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/v2fly/v2ray-core/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=e78446333fd28ef8a3ec2c25612458bfc024a226008888ed5277201136f4ca97

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Xingwang Liao <kuoruan@gmail.com>

PKG_BUILD_DEPENDS:=golang/host PACKAGE_v2ray-core-mini:upx/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_json_v2ctl \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_json_internal \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_json_none \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_exclude_v2ctl \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_exclude_assets \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_compress_upx \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_custom_features \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_dns \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_log \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_tls \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_udp \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_policy \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_reverse \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_routing \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_statistics \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_blackhole_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_dns_proxy \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_dokodemo_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_freedom_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_mtproto_proxy \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_http_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_shadowsocks_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_socks_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_vmess_proto \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_tcp_trans \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_mkcp_trans \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_websocket_trans \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_http2_trans \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_domain_socket_trans \
	CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_quic_trans

GO_PKG:=v2ray.com/core
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	v2ray.com/core.version=$(PKG_VERSION) \
	v2ray.com/core.build=R$(PKG_RELEASE) \
	v2ray.com/core.codename=OpenWrt

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/v2ray-core/Default
  TITLE:=A platform for building proxies to bypass network restrictions.
  URL:=https://www.v2fly.org
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Project V
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-certificates
endef

define Package/v2ray-core/Default/description
  Project V is a set of network tools that help you to build your own computer network.
  It secures your network connections and thus protects your privacy.
endef

define Package/v2ray-core
$(call Package/v2ray-core/Default)
  TITLE+= (Full)
  VARIANT:=full
  DEFAULT_VARIANT:=1
  PROVIDES:=v2ray
endef

define Package/v2ray-core/description
$(call Package/v2ray-core/Default/description)
  This package contains v2ray, v2ctl, geoip.dat and geosite.dat.
endef

define Package/v2ray-core-mini
$(call Package/v2ray-core/Default)
  TITLE+= (Minimal)
  VARIANT:=mini
  PROVIDES:=v2ray
endef

define Package/v2ray-core-mini/description
$(call Package/v2ray-core/Default/description)
  This package contains only v2ray.
endef

define Package/v2ray-core-mini/config
	source "$(SOURCE)/Config-mini.in"
endef

V2RAY_SED_ARGS:=

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_json_internal),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/main/json",// &,; \
	s,// \(_ "v2ray.com/core/main/jsonem"\),\1,;
else ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_json_none),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/main/json",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_custom_features),y)

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_dns),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/app/dns",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_log),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/app/log",// &,; \
	s,_ "v2ray.com/core/app/log/command",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_tls),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/tls",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_udp),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/udp",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_policy),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/app/policy",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_reverse),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/app/reverse",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_routing),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/app/router",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_statistics),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/app/stats",// &,; \
	s,_ "v2ray.com/core/app/stats/command",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_blackhole_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/blackhole",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_dns_proxy),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/dns",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_dokodemo_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/dokodemo",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_freedom_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/freedom",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_mtproto_proxy),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/mtproto",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_http_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/http",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_shadowsocks_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/shadowsocks",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_socks_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/socks",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_vmess_proto),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/proxy/vmess/inbound",// &,; \
	s,_ "v2ray.com/core/proxy/vmess/outbound",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_tcp_trans),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/tcp",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_mkcp_trans),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/kcp",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_websocket_trans),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/websocket",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_http2_trans),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/http",// &,; \
	s,_ "v2ray.com/core/transport/internet/headers/http",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_domain_socket_trans),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/domainsocket",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_quic_trans),y)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/quic",// &,;
endif

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_mkcp_trans)$(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_without_quic_trans),yy)
V2RAY_SED_ARGS += \
	s,_ "v2ray.com/core/transport/internet/headers/noop",// &,; \
	s,_ "v2ray.com/core/transport/internet/headers/srtp",// &,; \
	s,_ "v2ray.com/core/transport/internet/headers/tls",// &,; \
	s,_ "v2ray.com/core/transport/internet/headers/utp",// &,; \
	s,_ "v2ray.com/core/transport/internet/headers/wechat",// &,; \
	s,_ "v2ray.com/core/transport/internet/headers/wireguard",// &,;
endif

endif # custom features

GEOIP_VER:=latest
GEOIP_FILE:=geoip-$(GEOIP_VER).dat

define Download/geoip.dat
  URL:=https://github.com/v2fly/geoip/releases/$(GEOIP_VER)/download
  URL_FILE:=geoip.dat
  FILE:=$(GEOIP_FILE)
  HASH:=skip
endef

GEOSITE_VER:=latest
GEOSITE_FILE:=geosite-$(GEOSITE_VER).dat

define Download/geosite.dat
  URL:=https://github.com/v2fly/domain-list-community/releases/$(GEOSITE_VER)/download
  URL_FILE:=dlc.dat
  FILE:=$(GEOSITE_FILE)
  HASH:=skip
endef

define Build/Prepare
	$(call Build/Prepare/Default)

ifneq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_exclude_assets),y)
	# move file to make sure download new file every build
	mv -f $(DL_DIR)/$(GEOIP_FILE) $(PKG_BUILD_DIR)/release/config/geoip.dat
	mv -f $(DL_DIR)/$(GEOSITE_FILE) $(PKG_BUILD_DIR)/release/config/geosite.dat
endif

ifneq ($(V2RAY_SED_ARGS),)
	( \
		$(SED) \
			'$(V2RAY_SED_ARGS)' \
			$(PKG_BUILD_DIR)/main/distro/all/all.go ; \
	)
endif
endef

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=v2ray.com/core/main)
	$(call GoPackage/Build/Compile)
	mv -f $(GO_PKG_BUILD_BIN_DIR)/main $(GO_PKG_BUILD_BIN_DIR)/v2ray

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_compress_upx),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/v2ray || true
endif

ifneq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_exclude_v2ctl),y)
	$(eval GO_PKG_BUILD_PKG:=v2ray.com/core/infra/control/main)
	$(call GoPackage/Build/Compile)
	mv -f $(GO_PKG_BUILD_BIN_DIR)/main $(GO_PKG_BUILD_BIN_DIR)/v2ctl

ifeq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_compress_upx),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/v2ctl || true
endif
endif
endef

define Package/v2ray-core/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))

	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/v2ray $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/v2ctl $(1)/usr/bin

	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/release/config/{geoip,geosite}.dat \
		$(1)/usr/bin
endef

define Package/v2ray-core-mini/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))

	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/v2ray $(1)/usr/bin

ifneq ($(CONFIG_PACKAGE_v2ray_mini_exclude_v2ctl),y)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/v2ctl $(1)/usr/bin
endif

ifneq ($(CONFIG_PACKAGE_v2ray_mini_exclude_assets),y)
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/release/config/{geoip,geosite}.dat \
		$(1)/usr/bin
endif
endef

ifneq ($(CONFIG_PACKAGE_v2ray_$(BUILD_VARIANT)_exclude_assets),y)
$(eval $(call Download,geoip.dat))
$(eval $(call Download,geosite.dat))
endif

$(eval $(call GoBinPackage,v2ray-core))
$(eval $(call BuildPackage,v2ray-core))
$(eval $(call GoBinPackage,v2ray-core-mini))
$(eval $(call BuildPackage,v2ray-core-mini))
