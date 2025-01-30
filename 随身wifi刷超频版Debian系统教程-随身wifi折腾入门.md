这是一篇非常详细的Debian系统折腾记录。为了让内容更清晰易读，我对其进行了重新整理和优化：

### 1. 更新和升级系统中已安装的软件包
```bash
apt-get update && apt-get upgrade && apt-get update --fix-missing
```
- `apt-get update`：更新可用软件包的列表。
- `apt-get upgrade`：升级已安装的软件包。
- `apt-get update --fix-missing`：修复软件源列表信息不完整的问题。

**注**：建议使用国内源，更换源脚本可以在网上搜索。

### 2. 安装常用软件包
```bash
apt-get install curl wget nano vim busybox iptables iproute2 cpufrequtils
```
- `curl`：命令行数据传输工具。
- `wget`：命令行下载工具。
- `nano`：简单易用的文本编辑器。
- `vim`：强大的文本编辑器。
- `busybox`：嵌入式系统工具集。
- `iptables`：Linux防火墙配置工具。
- `iproute2`：网络管理工具。
- `cpufrequtils`：CPU频率管理工具。

### 3. 清理系统中不需要的软件包和日志文件
```bash
apt-get autoremove && apt-get clean && apt-get autoclean && journalctl --vacuum-size=5M
```
- `apt-get autoremove`：卸载不再需要的软件包。
- `apt-get clean`：清理已下载的软件包文件。
- `apt-get autoclean`：清理过期的软件包。
- `journalctl --vacuum-size=5M`：缩减系统日志文件。

### 4. 创建swap/zram虚拟内存
#### 创建swap虚拟内存
```bash
dd if=/dev/zero of=/root/swapfile bs=1M count=512
mkswap /root/swapfile
swapon /root/swapfile
```
- 创建一个大小为512MB的虚拟内存文件并启用。

#### 创建zram虚拟内存
```bash
modprobe zram num_devices=1
zramctl --find --size 512M --algorithm lz4 --streams 4
mkswap /dev/zram1
swapon -p 0 /dev/zram1
```
- 加载zram内核模块，创建并启用512MB大小的zram设备。

### 5. 修改CPU频率
```bash
apt-get install cpufrequtils
cpufreq-set -g conservative
cpufreq-set -d 200000
cpufreq-set -u 800000
```
- 安装cpufrequtils工具，设置CPU模式为保守模式，并调整频率上下限。

### 6. TRIM优化
```bash
fstrim -v /
```
- 清理SSD硬盘上的闲置块，提高性能和寿命。

### 7. 关闭LED
```bash
echo none > /sys/class/leds/red:os/trigger
echo none > /sys/class/leds/blue:wifi/trigger
echo none > /sys/class/leds/green:internet/trigger
```
- 关闭系统LED指示灯。

### 8. 开机自启配置
```bash
sudo chmod +x /etc/rc.local
nano /etc/rc.local
```
在`/etc/rc.local`文件中添加以下内容：
```bash
sleep 5
mkswap /root/swapfile
swapon /root/swapfile
modprobe zram num_devices=1
zramctl --find --size 512M --algorithm lz4 --streams 4
mkswap /dev/zram1
swapon -p 0 /dev/zram1
sysctl -w vm.swappiness=100
sync && echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3
sleep 35
echo none > /sys/class/leds/red:os/trigger
echo none > /sys/class/leds/blue:wifi/trigger
sudo cpufreq-set -g conservative
sudo cpufreq-set -d 200000
sudo cpufreq-set -u 800000
fstrim -v /
journalctl --vacuum-size=5M
```

### 9. 修改系统登录SSH时显示信息
编辑文件：`nano /etc/motd`
```bash
欢迎登录 Debian 服务器！
```
编辑文件：`nano /etc/update-motd.d/10-uname`
```bash
#!/bin/sh
echo "-------------------------- 系统信息 --------------------------"
echo "操作系统: $(echo "$(sed 's/\\n//g;s/\\l//g' /etc/issue)")" || echo "操作系统: $(uname -o)"
echo "主机名称: $(hostname)"
echo "内核版本: $(uname -r)"
echo "软件包数量: $(dpkg --list | wc -l)"
echo "CPU架构: $(lscpu| awk '/Architecture:/ {print $NF}')"
echo "CPU核心数: $(lscpu| awk '/^CPU\(s\)/ {print $2}')"
echo "核心线程数: $(lscpu| awk '/Thread\(s\) per core:/ {print $NF}')"
echo "CPU温度: $(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print int($1/1000)}')°C"
```

### 10. 配置内核参数
编辑文件：`nano /etc/sysctl.conf`
```bash
vm.swappiness=100
vm.vfs_cache_pressure=50
vm.panic_on_oom=0
vm.dirty_ratio=50
vm.dirty_background_ratio=30
vm.min_free_kbytes=10240
vm.max_map_count=262144
vm.dirty_expire_centisecs=3000
vm.dirty_writeback_centisecs=15000
net.ipv6.conf.all.forwarding=1
net.ipv6.conf.all.proxy_ndp=1
net.ipv6.conf.all.accept_ra=2
net.ipv4.ip_forward=1
net.core.somaxconn=2048
net.ipv4.tcp_max_syn_backlog=8192
net.core.netdev_max_backlog=32768
net.ipv4.tcp_keepalive_time=600
net.ipv4.icmp_echo_ignore_all=0
net.ipv4.tcp_abort_on_overflow=0
net.ipv4.tcp_fack=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=3
net.ipv4.ip_default_ttl=128
net.core.message_burst=10
net.core.busy_read=50
net.core.optmem_max=20480
net.ipv4.tcp_challenge_ack_limit=9999
net.ipv4.tcp_max_orphans=32768
net.ipv4.tcp_max_tw_buckets=32768
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192
net.ipv4.ip_local_port_range=1024 65000
net.ipv4.tcp_mem=131072 262144 524288
net.ipv4.udp_mem=262144 524288 1048576
net.ipv4.tcp_wmem=8760 256960 4088000
net.ipv4.tcp_rmem=8760 256960 4088000
net.core.rmem_default=524288
net.core.rmem_max=8388608
net.core.wmem_default=524288
net.core.wmem_max=8388608
```
运行以下命令使其生效：
```bash
sysctl -p
```

希望这些优化和整理对你有帮助！如果有其他问题或需要进一步的帮助，请随时告诉我。
