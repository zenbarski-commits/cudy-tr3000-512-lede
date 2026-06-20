# Cudy TR3000 (512MB mod) — LEDE 雲端編譯

為 **硬改 512MB 閃存** 的 Cudy TR3000 v1 編譯固件,完全比照原機運行的 yeung 版重編。

## 規格
- 基底:[coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)(master,OpenWrt 24.10 線)
- 機型 target:`mediatek/filogic` device `cudy_tr3000-mod`
- **分區客製**:ubi `0x5c0000 + 0x1ea00000`(490MB,吃滿 512MB);上游預設僅 112MB
- board_name 維持 `cudy,tr3000-mod`(sysupgrade 相容性不變)

## 客製內容
- `diy-part1.sh`:加入 linkease(istore/nas/nas_luci)+ kenzok8/small-package feed
- `diy-part2.sh`:**DTS ubi 分區 patch 112MB→490MB**、golang 版本替換、重複套件清理、預設 LAN 192.168.8.1 / argon 主題
- `.config`:機型 + 全家桶套件(openclash/passwall/ssr-plus/mosdns/sing-box/xray/istore/quickstart/alist/adguardhome/lucky/samba4/tailscale/zerotier…)

## 觸發編譯
Actions → Build TR3000-mod (512MB) → Run workflow。完成後於 Artifacts 下載
`...cudy_tr3000-mod-squashfs-sysupgrade.bin`。

## ⚠️ 刷機
分區與原機相同 → 走標準 sysupgrade,**不碰 uboot/FIP/Factory**。刷前務必備份 mtd2(Factory/WiFi 校準)。
