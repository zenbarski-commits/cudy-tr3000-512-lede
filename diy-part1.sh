#!/bin/bash
#
# diy-part1.sh — 在 feeds update 之前執行:加入第三方套件源
# 目標:重現 yeung 版 TR3000-mod 全家桶(coolsnowwolf/lede 基底)
#

# iStore 生態(istore / quickstart / linkease / nas)— 對應原固件的 istore/nas/nas_luci feeds
sed -i '$a src-git istore https://github.com/linkease/istore;main' feeds.conf.default
sed -i '$a src-git nas https://github.com/linkease/nas-packages.git;master' feeds.conf.default
sed -i '$a src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' feeds.conf.default

# 全家桶代理/工具源(passwall / ssr-plus / openclash / mosdns / adguardhome / alist / lucky / chinadns-ng ...)
# 對應原固件的 "third" feed
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
