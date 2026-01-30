#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# add date in output file name
sed -i -e '/^IMG_PREFIX:=/i BUILD_DATE := $(shell date +%Y%m%d)' \
       -e '/^IMG_PREFIX:=/ s/\($(SUBTARGET)\)/\1-$(BUILD_DATE)/' include/image.mk

# set ubi to 122M
sed -i 's/reg = <0x5c0000 0x7000000>;/reg = <0x5c0000 0x7a40000>;/' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts

# Add OpenClash Meta
# mkdir -p files/etc/openclash/core

# wget -qO "clash_meta.tar.gz" "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
# tar -zxvf "clash_meta.tar.gz" -C files/etc/openclash/core/
# mv files/etc/openclash/core/clash files/etc/openclash/core/clash_meta
# chmod +x files/etc/openclash/core/clash_meta
# rm -f "clash_meta.tar.gz"

BIN_DIR="$GITHUB_WORKSPACE/openwrt/files/usr/bin"
mkdir -p "$BIN_DIR"
# -------- 下载并解压 sing-box ARM64 -------
echo "Downloading sing-box..."
SINGBOX_VER="1.12.17"
curl -L -o sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VER}/sing-box-${SINGBOX_VER}-linux-arm64.tar.gz
TMP_DIR=$(mktemp -d)
tar -xzf sing-box.tar.gz -C "$TMP_DIR"
mv "$TMP_DIR"/sing-box-${SINGBOX_VER}-linux-arm64/sing-box "$BIN_DIR"/sing-box
chmod +x "$BIN_DIR/sing-box"
rm -rf "$TMP_DIR"
rm sing-box.tar.gz

# -------- 下载并解压 easytier ARM64 -------
echo "Downloading easytier..."
EASYTIER_VER="2.5.0"
curl -L -o easytier.zip https://github.com/EasyTier/EasyTier/releases/download/v2.5.0/easytier-linux-aarch64-v${EASYTIER_VER}.zip
TMP_DIR=$(mktemp -d)
unzip -d "$TMP_DIR" easytier.zip
rm "$TMP_DIR"/easytier-linux-aarch64/easytier-web-embed
mv "$TMP_DIR"/easytier-linux-aarch64/* "$BIN_DIR/"
chmod +x "$BIN_DIR"/easytier-*
rm -rf "$TMP_DIR"
rm easytier.zip
