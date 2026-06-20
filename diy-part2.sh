#!/bin/bash
#
# diy-part2.sh — 在 feeds install 之後執行
# 1) 關鍵:把 cudy_tr3000-mod 的 ubi 分區從 112MB 改成 490MB(吃滿 512MB 閃存)
# 2) golang:用 small8 較新版本(sing-box/xray 需要)
# 3) 預設值(LAN IP / 主題)
#
# 重要:絕不對 small8 做 feeds install -f(會覆蓋核心 opkg/base-files 而壞掉 build)
#

set -e

DTS="target/linux/mediatek/dts/mt7981b-cudy-tr3000-mod.dts"

echo ">>> [1/3] Patch DTS: ubi 112MB -> 490MB (0x1ea00000)"
sed -i 's|reg = <0x5c0000 0x7000000>;|reg = <0x5c0000 0x1ea00000>;|' "$DTS"
sed -i 's|model = "Cudy TR3000 (U-Boot mod)";|model = "Cudy TR3000v1 512MB rom versions";|' "$DTS"
echo "    patched DTS:"
grep -nE 'model =|reg = <0x5c0000' "$DTS" || true

echo ">>> [2/3] golang: 用 small8 的較新版本(若存在)"
if [ -d feeds/small8/golang ]; then
  rm -rf feeds/packages/lang/golang
  cp -a feeds/small8/golang feeds/packages/lang/golang
  echo "    golang 已替換為 small8 版"
else
  echo "    small8 無 golang,沿用核心版"
fi

echo ">>> [3/3] 預設值:LAN IP 192.168.8.1 / 主題 argon"
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate || true
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile 2>/dev/null || true

echo ">>> diy-part2 完成"
