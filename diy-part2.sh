#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# golang 1.22.x
rm -rfv feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# remove v2ray-geodata package from feeds (openwrt-22.03 & master)
rm -rfv feeds/packages/net/v2ray-geodata
git clone https://github.com/Ljzkirito/v2ray-geodata feeds/packages/net/v2ray-geodata
rm -rfv feeds/packages/net/mosdns
find ./ | grep Makefile | grep luci-app-mosdns | xargs rm -fv
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

# Replace Smartdns
./scripts/feeds uninstall luci-app-smartdns smartdns
./scripts/feeds install -a -p customsd

# Replace luci-app-ssr-plus & Depends
Replace_package="xray-core xray-plugin v2ray-core v2ray-plugin hysteria ipt2socks microsocks redsocks2 chinadns-ng dns2socks dns2tcp naiveproxy simple-obfs tcping tuic-client luci-app-ssr-plus"
./scripts/feeds uninstall ${Replace_package}
./scripts/feeds install -f -p helloworld ${Replace_package}

# Replace shadowsocks-rust
rm -rfv feeds/packages/net/shadowsocks-rust
git clone https://github.com/Ljzkirito/shadowsocks-rust feeds/packages/net/shadowsocks-rust

# Replace adguardhome
rm -rfv feeds/packages/net/adguardhome
git clone https://github.com/Ljzkirito/adguardhome-openwrt feeds/packages/net/adguardhome

sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate
sed -i "s/hostname='ImmortalWrt'/hostname='T360'/g" package/base-files/files/bin/config_generate
sed -i "s/timezone='UTC'/timezone='Asia\/Ho_Chi_Minh'/g" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='time1.apple.com'/add_list system.ntp.server='0.asia.pool.ntp.org'/g" package/base-files/files/bin/config_generate
sed -i "s/add_list system.ntp.server='time1.google.com'/add_list system.ntp.server='1.asia.pool.ntp.org'/g" package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION='OpenWrt By NILE $(date +"%Y%m%d")'/g" package/base-files/files/etc/openwrt_release
