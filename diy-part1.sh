#!/bin/bash
#
# diy-part1.sh — 在 feeds update 之前執行:加入第三方套件源
# small8(kenzok8/small-package)已內含:istore/quickstart/linkease 全套 +
# 代理全家桶(passwall/openclash/mosdns/adguardhome/alist/lucky/chinadns-ng/sing-box/xray ...)
# 故只需這一個 feed。
#
# 注意:不要對 small8 做 `feeds install -f`(會用 small8 的 opkg/base-files 覆蓋核心,
# 導致 opkg host build 規則消失而編譯失敗)。一律讓 workflow 的 `feeds install -a`
# 自動跳過與核心同名的套件。
#

sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
