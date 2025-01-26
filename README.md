以下是将每个命令分开整理的版本，确保每个步骤清晰明了：

---

### **1. 安装 Tailscale**
```bash
# 安装 Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
```

```bash
# 启动 Tailscale
tailscale up
```

```bash
# 启用 IP 转发
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

```bash
# 广告路由（例如本地网络）
sudo tailscale up --advertise-routes=192.168.31.0/24,192.168.1.0/24
```

```bash
# 广告出口节点
sudo tailscale up --advertise-exit-node
```

```bash
# 卸载 Tailscale
sudo apt remove tailscale
```

---

### **2. 安装 AdGuardHome**
```bash
# 安装 AdGuardHome
curl -sSL https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh
```

```bash
# 设置开机启动
sudo systemctl enable AdGuardHome
```

```bash
# 配置 iptables 规则
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5353
ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 5353
ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5353
```

```bash
# 启动 AdGuardHome
sudo systemctl start AdGuardHome
```

```bash
# 停止 AdGuardHome
sudo systemctl stop AdGuardHome
```

```bash
# 卸载 AdGuardHome
sudo /opt/AdGuardHome/AdGuardHome -s uninstall
```

---

### **3. 停用 systemd-resolved**
```bash
# 停用 systemd-resolved
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
sudo systemctl daemon-reload
```

```bash
# 重新启用 systemd-resolved（如果需要）
sudo systemctl enable systemd-resolved.service
sudo systemctl start systemd-resolved.service
```

---

### **4. 安装 nftables**
```bash
# 安装 nftables
sudo apt update
sudo apt install nftables
```

```bash
# 启动 nftables
sudo systemctl start nftables
```

```bash
# 设置开机启动
sudo systemctl enable nftables
```

```bash
# 停止 nftables
sudo systemctl stop nftables
```

```bash
# 卸载 nftables
sudo apt remove nftables
```

---

### **5. 安装 ShellCrash**
```bash
# 安装 ShellCrash
export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master' && wget -q --no-check-certificate -O /tmp/install.sh $url/install.sh  && bash /tmp/install.sh && source /etc/profile &> /dev/null
```

```bash
# 启动 ShellCrash
shellcrash start
```

```bash
# 停止 ShellCrash
shellcrash stop
```

```bash
# 卸载 ShellCrash
shellcrash uninstall
```

---

### **6. 安装 1Panel**
```bash
# 安装 1Panel
curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
```

```bash
# 启动 1Panel
1pctl start
```

```bash
# 停止 1Panel
1pctl stop
```

```bash
# 卸载 1Panel
1pctl uninstall
```

---

### **7. 安装 Lucky**
```bash
# 安装 Lucky
curl -o /tmp/install.sh https://6.66666.host:66/files/golucky.sh && sh /tmp/install.sh https://6.66666.host:66/files 2.13.4
```

```bash
# 启动 Lucky
lucky start
```

```bash
# 停止 Lucky
lucky stop
```

```bash
# 卸载 Lucky
lucky uninstall
```

---

### **8. 安装 Alist**
```bash
# 安装 Alist（默认路径）
curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install
```

```bash
# 安装到自定义路径（例如 /root）
curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install /root
```

```bash
# 更新 Alist
curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s update
```

```bash
# 卸载 Alist
curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s uninstall
```

```bash
# 启动 Alist
systemctl start alist
```

```bash
# 停止 Alist
systemctl stop alist
```

```bash
# 查看状态
systemctl status alist
```

```bash
# 重启 Alist
systemctl restart alist
```

```bash
# 获取管理员密码（低于 v3.25.0 版本）
./alist admin
```

```bash
# 随机生成密码（v3.25.0 及以上版本）
./alist admin random
```

```bash
# 手动设置密码（v3.25.0 及以上版本）
./alist admin set NEW_PASSWORD
```

---

### **9. 其他订阅链接**
以下是你提供的订阅链接，可以用于配置代理工具（如 V2Ray 或 Clash）：
```

---

### **总结**
每个命令都已分开，方便你逐步执行和管理。如果有其他需求或问题，可以随时补充！
