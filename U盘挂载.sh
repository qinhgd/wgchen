#!/bin/bash

# 挂载点
MOUNT_POINT="/mnt/usb"

# 创建挂载点
sudo mkdir -p "$MOUNT_POINT"

# 检测 U 盘设备
USB_DEVICE=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -e 'part' | grep -v 'mmcblk' | grep -v 'zram' | awk '{print "/dev/"$1}' | sed 's/└─//g' | sed 's/├─//g')

if [ -z "$USB_DEVICE" ]; then
    echo "未检测到 U 盘设备。"
    exit 1
fi

echo "检测到 U 盘设备: $USB_DEVICE"

# 检查是否已挂载
MOUNTED=$(df -h | grep "$USB_DEVICE")
if [ -n "$MOUNTED" ]; then
    echo "U 盘已挂载: $MOUNTED"
    exit 0
fi

# 挂载 U 盘
echo "正在挂载 U 盘到 $MOUNT_POINT ..."
sudo mount "$USB_DEVICE" "$MOUNT_POINT"

if [ $? -eq 0 ]; then
    echo "挂载成功。"
else
    echo "挂载失败，请检查 U 盘文件系统或权限。"
    exit 1
fi

# 获取 UUID
USB_UUID=$(sudo blkid -s UUID -o value "$USB_DEVICE")
if [ -z "$USB_UUID" ]; then
    echo "无法获取 U 盘的 UUID。"
    exit 1
fi

# 配置开机自动挂载
FSTAB_ENTRY="UUID=$USB_UUID $MOUNT_POINT ext4 defaults 0 0"
if grep -q "$MOUNT_POINT" /etc/fstab; then
    echo "/etc/fstab 中已存在 $MOUNT_POINT 的挂载配置。"
else
    echo "正在配置开机自动挂载..."
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab > /dev/null
    if [ $? -eq 0 ]; then
        echo "开机自动挂载配置成功。"
    else
        echo "配置开机自动挂载失败。"
        exit 1
    fi
fi

echo "脚本执行完成。"
