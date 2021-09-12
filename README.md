## V2Ray based on Nginx  of  vmess+ws+tls 一key Installscript

> grateful JetBrains supply of Non-commercial open source software open Issue authorization

> Thanks for non-commercial open source development authorization by JetBrains
### Telegram Group
* telegram Exchange group:https://t.me/wulabing_v2ray 
* telegram renew Announcement Channel：https://t.me/wulabing_channel

### Ready to work
* Prepare one domain name ，And will ArecordAdd to good.
* [V2ray Official description](https://www.v2ray.com/)， NS solusion  TLS WebSocket  and  V2ray 相关letter interest
* Install good wget

### Install/renew Way （h2 with ws Versionalready  combine 并）
Vmess+websocket+TLS+Nginx+Website
```
wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/rockneters/piturays/master/install.sh" && chmod +x install.sh && bash install.sh
```

VLESS+websocket+TLS+Nginx+Website
```
wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/rockneters/piturays/dev/install.sh" && chmod +x install.sh && bash install.sh
```

### Notice事item 
* The specific meaning of each item Setup install of in if youDo not NS solusion script, except for removedomain name, please usescriptsupply of default value
* To use this script, you need to have Linux basic and use experience, NS solusion calculation machine network part knowledge, calculation machine basic operation
* Currently supports Debian 9+ / Ubuntu 18.04+ / Centos7+, some Centos templates may exist and are difficult to handle of Compile problems. It is recommended that when you encounter Compile problems, please change to other system templates.
* Group owner only supply is extremely limited of support, if you have any questions, you can ask group friends
* Every Sunday of 3:00 AM, Nginx will since move heavy start with a combine Certificate of issuance timed task. During this period, the node cannot connect normally. The estimated duration is for several seconds to two minutes.

### renew 日志
> renew 内容Please Check  CHANGELOG.md

### 鸣谢
* ~~本script of 另一个分支Version（Use Host）address ： https://github.com/dylanbai8/V2Ray_ws-tls_Website_onekey Please 根据需求进行select select~~ Should 作者可能already 停止dimension Protect
* 本script中 MTProxy-go TLS Versionitem 目引用 https://github.com/whunt1/onekeymakemtg 在此grateful whunt1
* 本script中  sharp speed4 combine 1script原item 目引用 https://www.94ish.me/1635.html 在此grateful
* 本script中  sharp speed4 combine 1scriptmodify Versionitem 目引用 https://github.com/ylx2016/Linux-NetSpeed 在此grateful ylx2016

### Certificate
> If you already have the domain name of Certificate file used by NS you, you can name crt with key file for v2ray.crt v2ray.key and place it in the /data directory (if the directory Do not exist Please create the directory first), Please NoticeCertificate file permissions and CertificateValid period, since the definition of CertificateValid after the period expires Please since line renewal

scriptsupport since move generates let's encrypted Certificate, Valid period is 3 months, theoretically since move generates of Certificate support since move renew

### Check Client Configuration
`cat ~/v2ray_info.txt`

### Introduction to V2ray

* V2Ray is an excellent open source network proxy tool that can help you experience the Internet smoothly. Currently, all platforms support Windows, Mac, Android, IOS, Linux and other operating systems of use.
* This script for a key is a complete Configuration script. After all the processes are running normally, just connect and use Setup install the client according to the output result.
* Please Notice: We still strongly recommend you all aspects of NS solusion and the entire procedure of work flow and principle

### It is recommended that a single server only build a single agent
* This script defaults to Install latest Version of V2ray core
* V2ray core is currently the latest Version for 4.22.1 (At the same time, Please Notice client core of synchronous renew, need save certificate, client core Version >= server core Version)
* It is recommended to use the default of 443port as for connect port
* The content of camouflage can be replaced since line.

### Notice case item
* It is recommended to use this script in a pure environment, if you are a novice, Please Do not use Centos system.
* Before trying this script is indeed Available, Please Do not apply this program in a production environment.
* The Should program relies on Nginx to implement related functions. Please use [LNMP](https://lnmp.org) or other type seems to carry Nginx script. Test, if it exists, subsequent Version may handle this issue).
* Part of the functions of V2Ray of depends on the system time. Please ensure that you use the V2RAY program of the system. The UTC time error is within three minutes, regardless of the time zone.
* This bash relies on [V2ray official Installscript](https://install.direct/go.sh) and [acme.sh](https://github.com/Neilpang/acme.sh) to work.
* Centos system userPlease release program related ports in the firewall in advance (default: 80, 443)


### start upWay 

start up V2ray：`systemctl start v2ray`

Stop V2ray: `systemctl stop v2ray`

start up Nginx: `systemctl start nginx`

Stop Nginx: `systemctl stop nginx`

### Related Directory

Web directory: `/home/wwwroot/3DCEList`

V2ray server configuration: `/etc/v2ray/config.json`

V2ray client Configuration: `~/v2ray_info.inf`

Nginx directory: `/etc/nginx`

Certificate file: `/data/v2ray.key with /data/v2ray.crt` Please NoticeCertificate permission Setup install

### Donate

You can use Me of Bricklayer AFF to buy VPS

https://bandwagonhost.com/aff.php?aff=63939

You can use me of justmysocks AFF to buy a masonry supply of agent

https://justmysocks.net/members/aff.php?aff=17621




