## V2Ray 基于 Nginx  of  vmess+ws+tls 一键Installscript

> 感谢 JetBrains 提供 of 非商业open source软件open 发授权

> Thanks for non-commercial open source development authorization by JetBrains
### Telegram 群组
* telegram 交流群:https://t.me/wulabing_v2ray 
* telegram renew 公告频道：https://t.me/wulabing_channel

### 准备工作
* 准备一个domain name ，并将ArecordAdd to好。
* [V2ray官方说明](https://www.v2ray.com/)， NS 解 TLS WebSocket  and  V2ray 相关letter interest
* Install好 wget

### Install/renew 方式（h2 和 ws Versionalready  combine 并）
Vmess+websocket+TLS+Nginx+Website
```
wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/rockneters/piturays/master/install.sh" && chmod +x install.sh && bash install.sh
```

VLESS+websocket+TLS+Nginx+Website
```
wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/rockneters/piturays/dev/install.sh" && chmod +x install.sh && bash install.sh
```

### Notice事item 
* if youDo not  NS 解script中各item Setup install of 具体含义，removedomain name 外，Please  usescript提供 of 默认值
*  use本script需要you拥有 Linux 基础 and  use经验， NS 解计算machine 网络部分知识，计算machine 基础操作
* 目前support Debian 9+ / Ubuntu 18.04+ / Centos7+ ，部分Centos模板可能exist难以处理 of Compile 问题，建议遇到Compile 问题时，Please 更换至other 系统模板
* 群主only 提供极其有限 of support ，如有问题可以询问群友
* 每周日 of 凌晨3点，Nginx 会since moveheavy start以配 combine Certificate of 签发定时任务进行，在此期间，节点无法正常连connect，预计持续时间 for若干秒至两分钟

### renew 日志
> renew 内容Please Check  CHANGELOG.md

### 鸣谢
* ~~本script of 另一个分支Version（Use Host）address ： https://github.com/dylanbai8/V2Ray_ws-tls_Website_onekey Please 根据需求进行select select~~ Should 作者可能already 停止dimension Protect
* 本script中 MTProxy-go TLS Versionitem 目引用 https://github.com/whunt1/onekeymakemtg 在此感谢 whunt1
* 本script中  sharp speed4 combine 1script原item 目引用 https://www.94ish.me/1635.html 在此感谢
* 本script中  sharp speed4 combine 1scriptmodify Versionitem 目引用 https://github.com/ylx2016/Linux-NetSpeed 在此感谢 ylx2016

### Certificate
> if youalready 经拥有 NS you所 usedomain name  of Certificate file ，可以将 crt 和 key  file 命名 for v2ray.crt v2ray.key 放在 /data 目录下（若目录Do not existPlease 先建目录），Please NoticeCertificate file 权限 and CertificateValid period ，since 定义CertificateValid period 过期后Please since 行续签

scriptsupport since move生成 let's encrypted Certificate，Valid period 3个月，理论上since move生成 of Certificatesupport since move续签

### Check 客户端 Configuration
`cat ~/v2ray_info.txt`

### V2ray 简介

* V2Ray是一个优秀 of open source网络代理工具，可以帮助you畅爽体验互联网，目前already 经全平台support Windows、Mac、Android、IOS、Linux等操作系统 of  use。
* 本script for一键完全 Configurationscript，在所有流程正常运行完毕后，直connect按照输出结果Setup install客户端即可 use
* Please Notice：我们依然强烈建议you全方面 of  NS 解整个程序 of 工作流程 and 原理

### 建议单服务器only 搭建单个代理
* 本script默认Install latest Version of V2ray core
* V2ray core 目前 latest Version for 4.22.1（同时Please Notice客户端 core  of 同步renew ，需要save 证客户端内核Version >= 服务端内核Version）
* 建议 use默认 of 443port 作 for连connectport 
* camouflage 内容可since 行替换。

### Notice事item 
* 推荐在纯净环境下 use本script，if you是新手，Please Do not 要 useCentos系统。
* 在尝试本script确实Available之前，Please Do not 要将本程序应用于生产环境中。
* Should 程序依赖 Nginx 实现相关Function ，Please  use [LNMP](https://lnmp.org) orother type似携带 Nginx scriptInstall过 Nginx  of  user特别keep意， use本script可能会 guide 致无法预知 of 错误（未测试，若exist，后续Version可能会处理本问题）。
* V2Ray  of 部分Function 依赖于系统时间，please ensure 您 useV2RAY程序 of 系统 UTC 时间误差在三分钟之内，时区无关。
* 本 bash 依赖于 [V2ray 官方Installscript](https://install.direct/go.sh)  and  [acme.sh](https://github.com/Neilpang/acme.sh) 工作。
* Centos 系统 userPlease 预先在防火墙中放行程序相关port （默认：80，443）


### start up方式

start up V2ray：`systemctl start v2ray`

停止 V2ray：`systemctl stop v2ray`

start up Nginx：`systemctl start nginx`

停止 Nginx：`systemctl stop nginx`

### 相关目录

Web 目录：`/home/wwwroot/3DCEList`

V2ray 服务端 Configuration：`/etc/v2ray/config.json`

V2ray 客户端 Configuration: `~/v2ray_info.inf`

Nginx 目录： `/etc/nginx`

Certificate file : `/data/v2ray.key 和 /data/v2ray.crt` Please NoticeCertificate权限Setup install

### 捐赠

您可以 use我 of  搬瓦工 AFF 购买 VPS

https://bandwagonhost.com/aff.php?aff=63939

您可以 use我 of  justmysocks AFF 购买搬瓦工提供 of 代理

https://justmysocks.net/members/aff.php?aff=17621




