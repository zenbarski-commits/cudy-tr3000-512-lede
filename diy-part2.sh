#!/bin/bash
#
# diy-part2.sh — 在 feeds install 之後執行
# 1) 關鍵:把 cudy_tr3000-mod 的 ubi 分區從 112MB 改成 490MB(吃滿你的 512MB 閃存)
# 2) 全家桶編譯常見雷的處理(golang 版本、重複套件)
# 3) 預設值(LAN IP / 主題 / 主機名)
#

set -e

DTS="target/linux/mediatek/dts/mt7981b-cudy-tr3000-mod.dts"

echo ">>> [1/4] Patch DTS: ubi 112MB -> 490MB (0x1ea00000)"
# 你機器實測:partition@5c0000 ubi reg = <0x5c0000 0x1ea00000>
sed -i 's|reg = <0x5c0000 0x7000000>;|reg = <0x5c0000 0x1ea00000>;|' "$DTS"
# model 字串照你機器(純顯示,可選)
sed -i 's|model = "Cudy TR3000 (U-Boot mod)";|model = "Cudy TR3000v1 512MB rom versions";|' "$DTS"
echo "    patched DTS:"
grep -nE 'model =|reg = <0x5c0000' "$DTS" || true

echo ">>> [2/4] golang: 用 small8 的較新版本(sing-box/xray 需要)"
if [ -d feeds/small8/golang ]; then
  rm -rf feeds/packages/lang/golang
  cp -a feeds/small8/golang feeds/packages/lang/golang
fi

echo ">>> [3/4] 移除與 small8 重複的內建套件,避免 duplicate 定義"
for p in mosdns adguardhome xray-core xray-plugin sing-box v2ray-core v2ray-geodata \
         shadowsocks-rust naiveproxy hysteria chinadns-ng dns2socks microsocks \
         geoview tailscale ; do
  rm -rf feeds/packages/net/$p 2>/dev/null || true
done
rm -rf feeds/luci/applications/luci-app-mosdns 2>/dev/null || true
# 重新指向 small8 提供的版本
./scripts/feeds install -p small8 -f -a >/dev/null 2>&1 || true

echo ">>> [4/4] 預設值:LAN IP 192.168.8.1 / 主題 argon / 主機名"
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate || true
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile 2>/dev/null || true

echo ">>> diy-part2 完成"
