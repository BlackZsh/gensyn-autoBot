# gensyn-autoBot
一键部署gensyn脚本
<h2 align=center>Gensyn Testnet Node Guide</h2>

## 💻 系统要求

| Requirement                         | Details                                                     |
|-------------------------------------|-------------------------------------------------------------|
| **CPU Architecture**                | `arm64` or `amd64`                                          |
| **Recommended RAM**                 | 24 GB                                                       |
| **CUDA Devices (Recommended)**      | `RTX 3090`, `RTX 4070`, `RTX 4090`, `A100`, `H100`          |
| **Python Version**                  | Python >= 3.10 (For Mac, you may need to upgrade)           |


## 🌐  租用GPU
> [!Note]
> [!注意]
> **租用GPU并非必须，您仍可在VPS或WSL上运行本节点，但可能遇到内存溢出错误且获胜率较低，因此建议尽可能租用GPU**
1. 打开 : [VAST-AI官网](https://cloud.vast.ai/?ref_id=118050) **20%优惠链接**
2. 使用邮箱注册账号
3. 前往邮箱验证账户
4. 点击角落的`Add`按钮充值
5. 支持加密货币（通过Metamask）或信用卡支付
6. 在`template`版块选择`Ubuntu 22.04 jammy`
7. 点击`Select GPU`搜索并选择`RTX 4090`
8. 选择GPU后点击`Create POD`
9. 服务器部署完成后，点击`Connect`选择`Web终端连接`
10. 其他GPU提供商请使用下方SSH连接方式

## 🛜 SSH连接（仅GPU节点）

1. **打开终端**  
   支持WSL/Codespace/CMD等终端环境

2. **生成SSH密钥**
```bash
ssh-keygen
```
一路回车
![Screenshot 2025-04-08 081948](https://github.com/user-attachments/assets/035803da-c5bb-454e-9db4-4459e2123128)

配置GPU服务商

登录GPU供应商网站
在账户设置中粘贴公钥并保存
连接GPU服务器
使用服务商提供的SSH命令连接（示例）：
```
ssh -p 69 root@69.69.69.69
```

📥 安装流程
```bash
安装sudo权限
apt update && apt install -y sudo
安装系统依赖
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof nano unzip
安装Node环境
curl -sSL https://raw.githubusercontent.com/zunxbt/installation/main/node.sh | bash
创建后台会话
screen -S gensyn  # 创建名为gensyn的会话
启动训练集群
cd $HOME && rm -rf gensyn-testnet && git clone https://github.com/zunxbt/gensyn-testnet.git && chmod +x gensyn-testnet/gensyn.sh && ./gensyn-testnet/gensyn.sh
```
当出现以下提示时输入N：
![Screenshot 2025-04-01 061641](https://github.com/user-attachments/assets/b5ed9645-16a2-4911-8a73-97e21fdde274)

7. **后台运行**
- 按`Ctrl + A` 后 `D` 脱离会话.

 ## 🔄️ 备份 `swarm.pem`
节点运行后，**必须**将远程服务器（GPU/VPS）中的`swarm.pem`文件备份至本地电脑。该文件一旦丢失，所有贡献记录将无法找回。我们提供两种备份方案：


### 方法1（简易备份）
1. 进入`rl-swarm`目录执行：
```bash
[ -f backup.sh ] && rm backup.sh; curl -sSL -O https://raw.githubusercontent.com/zunxbt/gensyn-testnet/main/backup.sh && chmod +x backup.sh && ./backup.sh
```
终端将显示备份入口（如下图所示）：
![image](https://github.com/user-attachments/assets/489b02a8-40e1-4c91-b29b-9d9c30604e8c)

1️⃣服务器→本地备份
必须备份swarm.pem，可选备份userData.json和userApiKey.json：

直接访问生成的URL（不要执行下方命令）
按 Ctrl + S 保存文件至本地
🔹 服务器→服务器迁移
在目标服务器执行生成的备份命令

🟢 节点状态监控
1. 实时日志查看
Bash
screen -r gensyn  # 重新接入会话
Ctrl + A → D      # 退出会话（每次查看后必须执行）
2. 收益查询
访问节点统计站：https://gensyn-node.vercel.app/
输入日志中显示的Peer-ID
获胜次数越多，收益越高
[!警告]
当Connected EOA Address显示全零地址（0x0000...0000）时：

表示贡献未被记录
需使用全新邮箱重新部署节点
操作前必须删除现有swarm.pem文件
