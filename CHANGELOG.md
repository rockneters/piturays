## 2020-06-11
* 从 v2ray switch to v2fly
* mtproxy Install下线

## 2020-6-5
* Add to ws tls Quantmumult  guide enter 
* Add to 多线程Compile 
* 修复 heavy 复Add to cron 问题
## 2020-6-3
* Add to Nginx ipv6 监听 TLS1.3 0 RTT (merge)
* 适配 Nginx ipv6 监听port modify
*  change Nginx Version 1.16.1 renew 至 1.18.0
*  change ws path 长度从固定8位变 for范围随machine 长度

## 2020-2-16
1.1.0
* 修复 Certificaterenew 后未correct 应用 of 问题
* Add to  old Configuration file save keep
* Add to Install流程 TLS Versionselect select
*  change v2ray_qr_config_file位install
* 修复 v2ray daemon判断逻辑错误
* Add to Nginx 冲突检测

## 2020-2-7
1.0.7
* 修复 since moverenew Certificate Nginx heavy start异常
* 修复 bbr4 combine 1 403 forbidden 问题
* 修复 部分临时 file 清理异常 问题
*  change 默认only save keep TLS1.3
* Add to Uninstall提供 Nginx save keepselect item 
* Add to Nginx Configuration file  XFF 感谢 tg:@Cliwired
* Add to ws DOH Configuration 感谢 tg:@auth_chain_b

## 2020-01-25
* 修复 curl依赖缺失
* Add to MT-proxy-go Install代code，在此感谢 whunt1  of 贡献
* 修复 测试签发 success，正式签发fail，后续heavy 装 guide 致 of 跳过Certificate签发问题

## 2019-12-30 
> 本次renew 内容较多，并exist部分代codeheavy 构 and  combine 并，Please keep意，建议 user use新 Version management script时 先执行Uninstall后 heavy 新Install对应Version
* 新增 交互式菜单，heavy 构 forInstall management script，Version号初始化 for1.0，诸多Function  combine 并
*  combine 并 h2  Version combine 并至主Version并跟随renew ，h2 Version（ old Version）停止dimension Protect
* 新增  changeUUID ALTERID PORT TLS Versionselect item 
* 新增 V2ray 日志record and Check 
* 新增 4 combine 1 bbr sharp speedscript引enter ，感谢 94ish.me 
* 新增 Uninstallselect item 
* 新增 Certificate手moverenew ，原理andScheduled Tasksrenew 相同，CertificateValid period only 小于30天可renew ，默认Do not start用强制renew 

## 2019-11-28
* Add to依赖 rng-tools haveged 提高系统熵池 of 补充速率
* 又双叒叕...修复 Nginx heavy start后无法open machine since start问题
## 2019-11-27
* 调整Certificate签发检测 从周日凌晨0点 至 周日凌晨3点
* Add to参数 boost 可以直connect use 四 combine 一 bbr/ sharp speed script
* 调整参数 tls_modify 兼容 TLS1.1 按需select select
## 2019-11-26
>  本Version有可能解决 ws tls  of 祖传断流玄学问题，如有需要Please 执行Installscript进行renew 
* TLS Configurationmodify forsupport 1.2 1.3 可通过 tls_modify select item 切换
* UninstallFunction support  可通过 uninstall select item Uninstall
### 2019-10-17
> 建议遇到问题 of  userheavy install系统后heavy 新Install
*  change Add to Nginx systemd serverfile
* 修复 又双叒叕尝试修复 Nginx open machine since start up问题
### 2019-10-16
* 适配 Centos8 Debian10 Ubuntu19.04
* 修复 部分系统下 Scheduled TasksDo not 生效 of 问题
* 修复 Time synchronization service 在 Centos8 下无法Install of 错误
* 修复 部分系统下 CertificateDo not 会since moverenew  of 问题
* 修复 部分系统下 Nginx open machine since start Configuration失效 of 问题
*  change heavy 复Install时，将Do not 对相同 of domain name 进行heavy 复 of Certificate申Please ，防止出现 Let's encrypt API 次数限制
*  change 默认 alterID 64 -> 4 ，减少资source占用
*  change nginx Install方式从source获pick  change for Compile Install，并 use新 VersionOpenssl，support tls1.3
*  change nginx  Configuration file  ssl_protocols ssl_ciphers，适配 tls1.3
*  change pick消对Debian8 Ubuntu 16.04  of 适配工作（本Version可能依 oldAvailable）
*  change 默认页面camouflage  for html5 小游戏
* 新增 InstallFinish，节点 Configurationletter interestkeep档
* 新增  usesince 定义Certificate
* 新增 chain connect方式 guide enter  guide enter 
* 新增 二dimension code方式 guide enter 
## 2018-04-10
* vmess+http2 over tls scriptrenew 
## 2018-04-08
v3.3.1（Beta）
* Install依赖小幅调整
* Readme内容调整
## 2018-04-06
v3.3(Beta)
* 修复 Ubuntu 16.04/17.10 Install后 of Nginxstart upfail
* 修复 由于heavy 复执行script guide 致 of  Nginx Installsource of heavy 复Add to问题
* 修复 由于heavy 复执行script guide 致 of  Nginx  Configuration file 异常，从而 guide 致 Nginx start upfail of 问题
* 修复 Nginx Ubuntu source错误Add to guide 致 of  Nginx Version问题
## 2018-04-03
V3.2(Beta)
* Nginx Versionrenew 至mainlineVersion
* Nginx  Configuration中Add to TLS1.3 http2
## 2018-03-26
V3.1(Beta)
* 1.去remove无关 of 依赖
* 2.Install顺序 change，SSL生成放在程序末尾
* 3.NGINX InstallVersion统一 for latest  stable Version（ for将来可能进行 of  http2  and  tls1.3 适配做好准备,debian source默认 NGINX Version过低Do not support  http2）
## 2018-03-18
V3.0(Stable)
* 1.修复 Path 分流时访问特定 of camouflage  Path 时出现 of  Bad Request 问题 （统一 for404 Not Found）
## 2018-03-10
V3.0(beta)
* 1.部分Function 进行代codeheavy 构
* 2.Add to NS  301 heavy 定向，即 http 强制跳转 https 
* 3.Add to NS  页面camouflage （一个计算器程序）
* 4.camouflage path 从原来 of /ray/ 变 for 随machine 生成
## 2018-03-05
V2.1.1(stable)
* 1. change detectedPort occupation后，尝试since movekill相关进程
* 2.尝试修复 GCE 默认纯净模板80Port occupation问题（等待更多反馈）
## 2018-02-04
V2.1.1(stable)
* 1. change local_ip 判断方式，从 本地网卡获pick  change至 命令获pick public net IP。
* 1.修复 domain name dns resolve IP and Native IP Do not match 误报问题
## 2018-01-28
v2.1.1(stable)
* 1.修复 缺乏 lsof 依赖 guide 致 of Port occupation判断异常问题
## 2018-01-27
v2.1.1(stable）
* 1.修复 部分machine 型因缺乏 crontab （Scheduled Tasks）依赖 guide 致 of Installfail问题
* 2.完善 Port occupation 判断
## 2017-12-06
V2.1（stable）
* 1.修复 Centos7 找Do not 到 Nginx Install包 of 问题
* 2.完善 SElinux  Configuration process提醒标识

V2.0（stable）
* 1.增加 Centos7 系统support 
* 2.增加 since 定义port  和 since 定义alterID
* 3.完善 Install所需依赖
* 4.修复 Ubuntu 系列系统Version判断异常 guide 致 of Installation interrupted问题
* 5.修复 bug

V1.02（beta）
* 1.增加 系统判定，目前打算only support 带systemd of 较新主流open 发 Version系统
* 2.Native  IP 获pick方式heavy 构

## 2017-12-05

V1.01（beta）
* 1.完善 support  Debian9
* 2.修复 由于 Debian9 默认未Install net-tools  guide 致 of Native ip判定错误
* 3.修复 bc Install问题
* 4.增加 ip 判定Do not 一致时continue Install of select item （由于某些vps情况比较特殊，判定到内网IPor本身网卡letter interest，orpublic net ipand服务期内letter interestDo not 一致等情况）

V1.0（beta）
* 1.目前only support  Debian 8+ / Ubuntu 16.04+ 
* 2.逐渐完善中
