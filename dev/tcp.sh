#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================
#	System Required: CentOS 7/8,Debian/ubuntu,oraclelinux
#	Description: BBR+BBRplus+Lotserver
#	Version: 1.3.2.94
#	Author: 千影,cx9208,YLX
#	更 new 内容及反馈:  https://blog.ylx.me/archives/783.html
#=================================================

# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# SKYBLUE='\033[0;36m'
# PLAIN='\033[0m'

sh_ver="1.3.2.94"
github="raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master"

imgurl=""
headurl=""

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Information]${Font_color_suffix}"
Error="${Red_font_prefix}[Mistake]${Font_color_suffix}"
Tip="${Green_font_prefix}[Notice]${Font_color_suffix}"

if [ -f "/etc/sysctl.d/bbr.conf" ]; then
  rm -rf /etc/sysctl.d/bbr.conf
fi

# Check check连接
checkurl() {
  url=$(curl --max-time 5 --retry 3 --retry-delay 2 --connect-timeout 2 -s --head $1 | head -n 1)
  if [[ ${url} == *200* || ${url} == *302* || ${url} == *308* ]]; then
    echo "Download address check OK，Continue！"
  else
    echo "Download address check Error，Quit！"
    exit 1
  fi
}

# Install BBRKernel
installbbr() {
  kernel_version="5.9.6"
  bit=$(uname -m)
  rm -rf bbr
  mkdir bbr && cd bbr || exit

  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        echo -e "If the download address Error，May be currently being updated，More than half a day or Error Please feedback，The mainland solves the pollution problem on its own"
        #github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}' | awk -F '[_]' '{print $3}')
        github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Centos_Kernel' | grep '_latest_bbr_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
        github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}')
        echo -e " Acquired  The version number is :${github_ver}"
        kernel_version=$github_ver
        detele_kernel_head
        headurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}')
        imgurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep -v 'headers' | grep -v 'devel' | awk -F '"' '{print $4}')
        #headurl=https://github.com/ylx2016/kernel/releases/download/$github_tag/kernel-headers-${github_ver}-1.x86_64.rpm
        #imgurl=https://github.com/ylx2016/kernel/releases/download/$github_tag/kernel-${github_ver}-1.x86_64.rpm
        echo -e "Checking headers Download link...."
        checkurl $headurl
        echo -e "Checking Kernel Download link...."
        checkurl $imgurl
        wget -N -O kernel-headers-c7.rpm $headurl
        wget -N -O kernel-c7.rpm $imgurl
        yum install -y kernel-c7.rpm
        yum install -y kernel-headers-c7.rpm
      else
        echo -e "${Error} Not support x86_64 Outside system !" && exit 1
      fi
    fi

  elif [[ "${release}" == "ubuntu" || "${release}" == "debian" ]]; then
    if [[ ${bit} == "x86_64" ]]; then
      echo -e "If the download address Error，May be currently being updated，More than half a day or Error Please feedback，The mainland solves the pollution problem on its own"
      github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Ubuntu_Kernel' | grep '_latest_bbr_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
      github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}' | awk -F '[_]' '{print $1}')
      echo -e " Acquired  The version number is :${github_ver}"
      kernel_version=$github_ver
      detele_kernel_head
      headurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep 'headers' | awk -F '"' '{print $4}')
      imgurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep -v 'headers' | grep -v 'devel' | awk -F '"' '{print $4}')
      #headurl=https://github.com/ylx2016/kernel/releases/download/$github_tag/linux-headers-${github_ver}_${github_ver}-1_amd64.deb
      #imgurl=https://github.com/ylx2016/kernel/releases/download/$github_tag/linux-image-${github_ver}_${github_ver}-1_amd64.deb
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O linux-headers-d10.deb $headurl
      wget -N -O linux-image-d10.deb $imgurl
      dpkg -i linux-image-d10.deb
      dpkg -i linux-headers-d10.deb
    elif [[ ${bit} == "aarch64" ]]; then
      echo -e "If the download address Error，May be currently being updated，More than half a day or Error Please feedback，The mainland solves the pollution problem on its own"
      github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Ubuntu_Kernel' | grep '_arm64_' | grep '_bbr_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
      github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}' | awk -F '[_]' '{print $1}')
      echo -e " Acquired  The version number is :${github_ver}"
      kernel_version=$github_ver
      detele_kernel_head
      headurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep 'headers' | awk -F '"' '{print $4}')
      imgurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep -v 'headers' | grep -v 'devel' | awk -F '"' '{print $4}')
      #headurl=https://github.com/ylx2016/kernel/releases/download/$github_tag/linux-headers-${github_ver}_${github_ver}-1_amd64.deb
      #imgurl=https://github.com/ylx2016/kernel/releases/download/$github_tag/linux-image-${github_ver}_${github_ver}-1_amd64.deb
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O linux-headers-d10.deb $headurl
      wget -N -O linux-image-d10.deb $imgurl
      dpkg -i linux-image-d10.deb
      dpkg -i linux-headers-d10.deb
    else
      echo -e "${Error} Not support x86_64及arm64/aarch64 Outside system !" && exit 1
    fi
  fi

  cd .. && rm -rf bbr

  detele_kernel
  BBR_grub
  echo -e "${Tip} ${Red_font_prefix}Please check if there is Kernel Information，without Kernel Never restart ${Font_color_suffix}"
  echo -e "${Tip} ${Red_font_prefix}rescue Not normal Kernel， To exclude this ${Font_color_suffix}"
  echo -e "${Tip}  Reboot VPS later ， Please re-run the script to open ${Red_font_prefix}BBR${Font_color_suffix}"
  stty erase '^H' && read -p " Need  Reboot VPS later ， To open BBR， Is it now  Reboot  ? [Y/n] :" yn
  [ -z "${yn}" ] && yn="y"
  if [[ $yn == [Yy] ]]; then
    echo -e "${Info} VPS  Reboot  middle ..."
    reboot
  fi
  #echo -e "${Tip} Kernel Install  over  complete，Please参考上面的Information Check check是否 Install become achievement及手动调整Kernel start up 顺序"
}

# Install BBRplusKernel 4.14.129
installbbrplus() {
  kernel_version="4.14.160-bbrplus"
  bit=$(uname -m)
  rm -rf bbrplus
  mkdir bbrplus && cd bbrplus || exit
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        kernel_version="4.14.129_bbrplus"
        detele_kernel_head
        headurl=https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/centos/7/kernel-headers-4.14.129-bbrplus.rpm
        imgurl=https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/centos/7/kernel-4.14.129-bbrplus.rpm
        echo -e "Checking headers Download link...."
        checkurl $headurl
        echo -e "Checking Kernel Download link...."
        checkurl $imgurl
        wget -N -O kernel-headers-c7.rpm $headurl
        wget -N -O kernel-c7.rpm $imgurl
        yum install -y kernel-c7.rpm
        yum install -y kernel-headers-c7.rpm
      else
        echo -e "${Error} Not support x86_64 Outside system !" && exit 1
      fi
    fi

  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    if [[ ${bit} == "x86_64" ]]; then
      kernel_version="4.14.129-bbrplus"
      detele_kernel_head
      headurl=https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/debian-ubuntu/x64/linux-headers-4.14.129-bbrplus.deb
      imgurl=https://github.com/cx9208/Linux-NetSpeed/raw/master/bbrplus/debian-ubuntu/x64/linux-image-4.14.129-bbrplus.deb
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O linux-headers.deb $headurl
      wget -N -O linux-image.deb $imgurl

      dpkg -i linux-image.deb
      dpkg -i linux-headers.deb
    else
      echo -e "${Error} Not support x86_64 Outside system !" && exit 1
    fi
  fi

  cd .. && rm -rf bbrplus
  detele_kernel
  BBR_grub
  echo -e "${Tip} ${Red_font_prefix}Please check if there is KernelInformation，without Kernel Never restart ${Font_color_suffix}"
  echo -e "${Tip} ${Red_font_prefix}rescue Not normal Kernel， To exclude this ${Font_color_suffix}"
  echo -e "${Tip}  Reboot VPS later ，Please re-run the script to open ${Red_font_prefix}BBRplus${Font_color_suffix}"
  stty erase '^H' && read -p "Need Reboot VPS later ， To open BBRplus， Is it now  Reboot  ? [Y/n] :" yn
  [ -z "${yn}" ] && yn="y"
  if [[ $yn == [Yy] ]]; then
    echo -e "${Info} VPS  Reboot  middle ..."
    reboot
  fi
  #echo -e "${Tip} Kernel Install  over  complete，Please参考上面的Information Check check是否 Install become achievement及手动调整Kernel start up 顺序"
}

# Install LotserverKernel
installlot() {
  bit=$(uname -m)
  if [[ ${bit} != "x86_64" ]]; then
    echo -e "${Error} Not support x86_64 Outside system !" && exit 1
  fi
  if [[ ${bit} == "x86_64" ]]; then
    bit='x64'
  fi
  if [[ ${bit} == "i386" ]]; then
    bit='x32'
  fi
  if [[ "${release}" == "centos" ]]; then
    rpm --import http://${github}/lotserver/${release}/RPM-GPG-KEY-elrepo.org
    yum remove -y kernel-firmware
    yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-firmware-${kernel_version}.rpm
    yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-${kernel_version}.rpm
    yum remove -y kernel-headers
    yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-headers-${kernel_version}.rpm
    yum install -y http://${github}/lotserver/${release}/${version}/${bit}/kernel-devel-${kernel_version}.rpm
  fi

  if [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    deb_issue="$(cat /etc/issue)"
    deb_relese="$(echo $deb_issue | grep -io 'Ubuntu\|Debian' | sed -r 's/(.*)/\L\1/')"
    os_ver="$(dpkg --print-architecture)"
    [ -n "$os_ver" ] || exit 1
    if [ "$deb_relese" == 'ubuntu' ]; then
      deb_ver="$(echo $deb_issue | grep -o '[0-9]*\.[0-9]*' | head -n1)"
      if [ "$deb_ver" == "14.04" ]; then
        kernel_version="3.16.0-77-generic" && item="3.16.0-77-generic" && ver='trusty'
      elif [ "$deb_ver" == "16.04" ]; then
        kernel_version="4.8.0-36-generic" && item="4.8.0-36-generic" && ver='xenial'
      elif [ "$deb_ver" == "18.04" ]; then
        kernel_version="4.15.0-30-generic" && item="4.15.0-30-generic" && ver='bionic'
      else
        exit 1
      fi
      url='archive.ubuntu.com'
      urls='security.ubuntu.com'
    elif [ "$deb_relese" == 'debian' ]; then
      deb_ver="$(echo $deb_issue | grep -o '[0-9]*' | head -n1)"
      if [ "$deb_ver" == "7" ]; then
        kernel_version="3.2.0-4-${os_ver}" && item="3.2.0-4-${os_ver}" && ver='wheezy' && url='archive.debian.org' && urls='archive.debian.org'
      elif [ "$deb_ver" == "8" ]; then
        kernel_version="3.16.0-4-${os_ver}" && item="3.16.0-4-${os_ver}" && ver='jessie' && url='archive.debian.org' && urls='deb.debian.org'
      elif [ "$deb_ver" == "9" ]; then
        kernel_version="4.9.0-4-${os_ver}" && item="4.9.0-4-${os_ver}" && ver='stretch' && url='deb.debian.org' && urls='deb.debian.org'
      else
        exit 1
      fi
    fi
    [ -n "$item" ] && [ -n "$urls" ] && [ -n "$url" ] && [ -n "$ver" ] || exit 1
    if [ "$deb_relese" == 'ubuntu' ]; then
      echo "deb http://${url}/${deb_relese} ${ver} main restricted universe multiverse" >/etc/apt/sources.list
      echo "deb http://${url}/${deb_relese} ${ver}-updates main restricted universe multiverse" >>/etc/apt/sources.list
      echo "deb http://${url}/${deb_relese} ${ver}-backports main restricted universe multiverse" >>/etc/apt/sources.list
      echo "deb http://${urls}/${deb_relese} ${ver}-security main restricted universe multiverse" >>/etc/apt/sources.list

      apt-get --allow-releaseinfo-change update
      apt-get install --no-install-recommends -y linux-image-${item}
    elif [ "$deb_relese" == 'debian' ]; then
      echo "deb http://${url}/${deb_relese} ${ver} main" >/etc/apt/sources.list
      echo "deb-src http://${url}/${deb_relese} ${ver} main" >>/etc/apt/sources.list
      echo "deb http://${urls}/${deb_relese}-security ${ver}/updates main" >>/etc/apt/sources.list
      echo "deb-src http://${urls}/${deb_relese}-security ${ver}/updates main" >>/etc/apt/sources.list

      if [ "$deb_ver" == "8" ]; then
        dpkg -l | grep -q 'linux-base' || {
          wget --no-check-certificate -qO '/tmp/linux-base_3.5_all.deb' 'http://snapshot.debian.org/archive/debian/20120304T220938Z/pool/main/l/linux-base/linux-base_3.5_all.deb'
          dpkg -i '/tmp/linux-base_3.5_all.deb'
        }
        wget --no-check-certificate -qO '/tmp/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb' 'http://snapshot.debian.org/archive/debian/20171008T163152Z/pool/main/l/linux/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb'
        dpkg -i '/tmp/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb'

        if [ $? -ne 0 ]; then
          exit 1
        fi
      elif [ "$deb_ver" == "9" ]; then
        dpkg -l | grep -q 'linux-base' || {
          wget --no-check-certificate -qO '/tmp/linux-base_4.5_all.deb' 'http://snapshot.debian.org/archive/debian/20160917T042239Z/pool/main/l/linux-base/linux-base_4.5_all.deb'
          dpkg -i '/tmp/linux-base_4.5_all.deb'
        }
        wget --no-check-certificate -qO '/tmp/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb' 'http://snapshot.debian.org/archive/debian/20171224T175424Z/pool/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb'
        dpkg -i '/tmp/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb'
        ##备选
        #https://sys.if.ci/download/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb
        #http://mirror.cs.uchicago.edu/debian-security/pool/updates/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb
        #https://debian.sipwise.com/debian-security/pool/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb
        #http://srv24.dsidata.sk/security.debian.org/pool/updates/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb
        #https://pubmirror.plutex.de/debian-security/pool/updates/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb
        #https://packages.mendix.com/debian/pool/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3_amd64.deb
        #http://snapshot.debian.org/archive/debian/20171224T175424Z/pool/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3+deb9u1_amd64.deb
        #http://snapshot.debian.org/archive/debian/20171231T180144Z/pool/main/l/linux/linux-image-4.9.0-4-amd64_4.9.65-3_amd64.deb
        if [ $? -ne 0 ]; then
          exit 1
        fi
      else
        exit 1
      fi
    fi
    apt-get autoremove -y
    [ -d '/var/lib/apt/lists' ] && find /var/lib/apt/lists -type f -delete
  fi

  detele_kernel
  BBR_grub
  echo -e "${Tip} ${Red_font_prefix}Please check if there is KernelInformation，without Kernel Never restart ${Font_color_suffix}"
  echo -e "${Tip} ${Red_font_prefix}rescue Not normal Kernel， To exclude this ${Font_color_suffix}"
  echo -e "${Tip}  Reboot VPS later ， Please re-run the script to open ${Red_font_prefix}Lotserver${Font_color_suffix}"
  stty erase '^H' && read -p " Need  Reboot VPS later ， To open Lotserver， Is it now  Reboot  ? [Y/n] :" yn
  [ -z "${yn}" ] && yn="y"
  if [[ $yn == [Yy] ]]; then
    echo -e "${Info} VPS  Reboot middle ..."
    reboot
  fi
  #echo -e "${Tip} Kernel Install  over  complete，Please参考上面的Information Check check是否 Install become achievement及手动调整Kernel start up 顺序"
}

# Install xanmodKernel  from xanmod.org
installxanmod() {
  kernel_version="5.5.1-xanmod1"
  bit=$(uname -m)
  if [[ ${bit} != "x86_64" ]]; then
    echo -e "${Error} Not support x86_64 Outside system !" && exit 1
  fi
  rm -rf xanmod
  mkdir xanmod && cd xanmod || exit
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        echo -e "If the download address Error，May be currently being updated，More than half a day or Error Please feedback，The mainland solves the pollution problem on its own"
        github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Centos_Kernel' | grep '_lts_latest_' | grep 'xanmod' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
        github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}')
        echo -e " Acquired  The version number is :${github_ver}"
        kernel_version=$github_ver
        detele_kernel_head
        headurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}')
        imgurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep -v 'headers' | grep -v 'devel' | awk -F '"' '{print $4}')
        echo -e "Checking headers Download link...."
        checkurl $headurl
        echo -e "Checking Kernel Download link...."
        checkurl $imgurl
        wget -N -O kernel-headers-c7.rpm $headurl
        wget -N -O kernel-c7.rpm $imgurl
        yum install -y kernel-c7.rpm
        yum install -y kernel-headers-c7.rpm
      else
        echo -e "${Error} Not support x86_64 Outside system !" && exit 1
      fi
    elif [[ ${version} == "8" ]]; then
      echo -e "If the download address Error，May be currently being updated，More than half a day or Error Please feedback，The mainland solves the pollution problem on its own"
      github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Centos_Kernel' | grep '_lts_C8_latest_' | grep 'xanmod' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
      github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}')
      echo -e " Acquired  The version number is :${github_ver}"
      kernel_version=$github_ver
      detele_kernel_head
      headurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}')
      imgurl=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep -v 'headers' | grep -v 'devel' | awk -F '"' '{print $4}')
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O kernel-headers-c8.rpm $headurl
      wget -N -O kernel-c8.rpm $imgurl
      yum install -y kernel-c8.rpm
      yum install -y kernel-headers-c8.rpm
    fi

  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then

    if [[ ${bit} == "x86_64" ]]; then
      # kernel_version="5.11.4-xanmod"
      # xanmod_ver_b=$(rm -rf /tmp/url.tmp && curl -o /tmp/url.tmp 'https://dl.xanmod.org/dl/changelog/?C=N;O=D' && grep folder.gif /tmp/url.tmp | head -n 1 | awk -F "[/]" '{print $5}' | awk -F "[>]" '{print $2}')
      # xanmod_ver_s=$(rm -rf /tmp/url.tmp && curl -o /tmp/url.tmp 'https://dl.xanmod.org/changelog/${xanmod_ver_b}/?C=M;O=D' && grep $xanmod_ver_b /tmp/url.tmp | head -n 3 | awk -F "[-]" '{print $2}')
      sourceforge_xanmod_lts_ver=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/lts/ | grep 'class="folder ">' | head -n 1 | awk -F '"' '{print $2}')
      sourceforge_xanmod_lts_file_img=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/lts/${sourceforge_xanmod_lts_ver}/ | grep 'linux-image' | head -n 1 | awk -F '"' '{print $2}')
      sourceforge_xanmod_lts_file_head=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/lts/${sourceforge_xanmod_lts_ver}/ | grep 'linux-headers' | head -n 1 | awk -F '"' '{print $2}')
      # sourceforge_xanmod_stable_ver=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/stable/ | grep 'class="folder ">' | head -n 1 | awk -F '"' '{print $2}')
      # sourceforge_xanmod_stable_file_img=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/stable/${sourceforge_xanmod_stable_ver}/ | grep 'linux-image' | head -n 1 | awk -F '"' '{print $2}')
      # sourceforge_xanmod_stable_file_head=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/stable/${sourceforge_xanmod_stable_ver}/ | grep 'linux-headers' | head -n 1 | awk -F '"' '{print $2}')
      # sourceforge_xanmod_cacule_ver=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/cacule/ | grep 'class="folder ">' | head -n 1 | awk -F '"' '{print $2}')
      # sourceforge_xanmod_cacule_file_img=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/cacule/${sourceforge_xanmod_cacule_ver}/ | grep 'linux-image' | head -n 1 | awk -F '"' '{print $2}')
      # sourceforge_xanmod_cacule_file_head=$(curl -s https://sourceforge.net/projects/xanmod/files/releases/cacule/${sourceforge_xanmod_cacule_ver}/ | grep 'linux-headers' | head -n 1 | awk -F '"' '{print $2}')
      echo -e " Acquired xanmod lts The version number is :${sourceforge_xanmod_lts_ver}"
      # kernel_version=$sourceforge_xanmod_stable_ver
      # detele_kernel_head
      # headurl=https://sourceforge.net/projects/xanmod/files/releases/stable/${sourceforge_xanmod_stable_ver}/${sourceforge_xanmod_stable_file_head}/download
      # imgurl=https://sourceforge.net/projects/xanmod/files/releases/stable/${sourceforge_xanmod_stable_ver}/${sourceforge_xanmod_stable_file_img}/download
      kernel_version=$sourceforge_xanmod_lts_ver
      detele_kernel_head
      #headurl=https://sourceforge.net/projects/xanmod/files/releases/cacule/${sourceforge_xanmod_cacule_ver}/${sourceforge_xanmod_cacule_file_head}/download
      #imgurl=https://sourceforge.net/projects/xanmod/files/releases/cacule/${sourceforge_xanmod_cacule_ver}/${sourceforge_xanmod_cacule_file_img}/download
      headurl=https://sourceforge.net/projects/xanmod/files/releases/lts/${sourceforge_xanmod_lts_ver}/${sourceforge_xanmod_lts_file_head}/download
      imgurl=https://sourceforge.net/projects/xanmod/files/releases/lts/${sourceforge_xanmod_lts_ver}/${sourceforge_xanmod_lts_file_img}/download
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O linux-headers-d10.deb $headurl
      wget -N -O linux-image-d10.deb $imgurl
      dpkg -i linux-image-d10.deb
      dpkg -i linux-headers-d10.deb
    else
      echo -e "${Error} Not support x86_64 Outside system !" && exit 1
    fi
  fi

  cd .. && rm -rf xanmod
  detele_kernel
  BBR_grub
  echo -e "${Tip} ${Red_font_prefix}Please check if there is KernelInformation，without Kernel Never restart ${Font_color_suffix}"
  echo -e "${Tip} ${Red_font_prefix}rescue Not normal Kernel， To exclude this ${Font_color_suffix}"
  echo -e "${Tip}  Reboot VPS later ， Please re-run the script to open ${Red_font_prefix}BBR${Font_color_suffix}"
  stty erase '^H' && read -p " Need  Reboot VPS later ， To open BBR， Is it now  Reboot  ? [Y/n] :" yn
  [ -z "${yn}" ] && yn="y"
  if [[ $yn == [Yy] ]]; then
    echo -e "${Info} VPS  Reboot  middle ..."
    reboot
  fi
  #echo -e "${Tip} Kernel Install  over  complete，Please参考上面的Information Check check是否 Install become achievement及手动调整Kernel start up 顺序"
}

# Install bbr2Kernel 集become到xanmodKernel了
# Install bbrplus  new Kernel
#2021.3.15 Start 由https://github.com/UJX6N/bbrplus-5.10 替换bbrplusnew
#2021.4.12 地址更 new 为https://github.com/ylx2016/kernel/releases
#2021.9.2 再次改为https://github.com/UJX6N/bbrplus-5.10

installbbrplusnew() {
  github_ver_plus=$(curl -s https://api.github.com/repos/UJX6N/bbrplus-5.10/releases  | grep /bbrplus-5.10/releases/tag/  | head -1 | awk -F "[/]" '{print $8}' | awk -F "[\"]" '{print $1}')
  github_ver_plus_num=$(curl -s https://api.github.com/repos/UJX6N/bbrplus-5.10/releases  | grep /bbrplus-5.10/releases/tag/  | head -1 | awk -F "[/]" '{print $8}' | awk -F "[\"]" '{print $1}' | awk -F "[-]" '{print $1}')
  echo -e " Acquired UJX6N的bbrplus-5.10 The version number is :${github_ver_plus}"
  echo -e "If the download address Error，May be currently being updated，More than half a day or Error Please feedback，The mainland solves the pollution problem on its own"
  echo -e "Feedback here for installation failure，Kernel Questions to UJX6N feedback"
  # kernel_version=$github_ver_plus

  bit=$(uname -m)
  #if [[ ${bit} != "x86_64" ]]; then
  #  echo -e "${Error} Not support x86_64 Outside system !" && exit 1
  #fi
  rm -rf bbrplusnew
  mkdir bbrplusnew && cd bbrplusnew || exit
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        #github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Centos_Kernel' | grep '_latest_bbrplus_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
        #github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}' | awk -F '[_]' '{print $1}')
        #echo -e " Acquired  The version number is :${github_ver}"
        kernel_version=${github_ver_plus_num}_bbrplus
        detele_kernel_head
        headurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'rpm' | grep 'headers'  | grep 'el7' | awk -F '"' '{print $4}')
        imgurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'rpm' | grep -v 'devel'  | grep -v 'headers'  | grep -v 'Source' | grep 'el7' | awk -F '"' '{print $4}')
        echo -e "Checking headers Download link...."
        checkurl $headurl
        echo -e "Checking Kernel Download link...."
        checkurl $imgurl
        wget -N -O kernel-c7.rpm $headurl
        wget -N -O kernel-headers-c7.rpm $imgurl
        yum install -y kernel-c7.rpm
        yum install -y kernel-headers-c7.rpm
      else
        echo -e "${Error} Not support x86_64 Outside system !" && exit 1
      fi
    fi
    if [[ ${version} == "8" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        #github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Centos_Kernel' | grep '_latest_bbrplus_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
        #github_ver=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'rpm' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}' | awk -F '[_]' '{print $1}')
        #echo -e " Acquired  The version number is :${github_ver}"
        kernel_version=${github_ver_plus_num}_bbrplus
        detele_kernel_head
        headurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'rpm' | grep 'headers'  | grep 'el8' | awk -F '"' '{print $4}')
        imgurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'rpm' | grep -v 'devel'  | grep -v 'headers'  | grep -v 'Source' | grep 'el8' | awk -F '"' '{print $4}')
        echo -e "Checking headers Download link...."
        checkurl $headurl
        echo -e "Checking Kernel Download link...."
        checkurl $imgurl
        wget -N -O kernel-c8.rpm $headurl
        wget -N -O kernel-headers-c8.rpm $imgurl
        yum install -y kernel-c8.rpm
        yum install -y kernel-headers-c8.rpm
      else
        echo -e "${Error} Not support x86_64 Outside system !" && exit 1
      fi
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    if [[ ${bit} == "x86_64" ]]; then
      #github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Ubuntu_Kernel' | grep '_latest_bbrplus_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
      #github_ver=$(curl -s 'http s://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}' | awk -F '[_]' '{print $1}')
      #echo -e " Acquired  The version number is :${github_ver}"
      kernel_version=${github_ver_plus_num}-bbrplus
      detele_kernel_head
      headurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'https' | grep 'amd64.deb' | grep 'headers' | awk -F '"' '{print $4}')
      imgurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'https' | grep 'amd64.deb' | grep 'image' | awk -F '"' '{print $4}')
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O linux-headers-d10.deb $headurl
      wget -N -O linux-image-d10.deb $imgurl
      dpkg -i linux-image-d10.deb
      dpkg -i linux-headers-d10.deb
    elif [[ ${bit} == "aarch64" ]]; then
      #github_tag=$(curl -s 'https://api.github.com/repos/ylx2016/kernel/releases' | grep 'Ubuntu_Kernel' | grep '_latest_bbrplus_' | head -n 1 | awk -F '"' '{print $4}' | awk -F '[/]' '{print $8}')
      #github_ver=$(curl -s 'http s://api.github.com/repos/ylx2016/kernel/releases' | grep ${github_tag} | grep 'deb' | grep 'headers' | awk -F '"' '{print $4}' | awk -F '[/]' '{print $9}' | awk -F '[-]' '{print $3}' | awk -F '[_]' '{print $1}')
      #echo -e " Acquired  The version number is :${github_ver}"
      kernel_version=${github_ver_plus_num}-bbrplus
      detele_kernel_head
      headurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'https' | grep 'arm64.deb' | grep 'headers' | awk -F '"' '{print $4}')
      imgurl=$(curl -s 'https://api.github.com/repos/UJX6N/bbrplus-5.10/releases' | grep ${github_ver_plus} | grep 'https' | grep 'arm64.deb' | grep 'image' | awk -F '"' '{print $4}')
      echo -e "Checking headers Download link...."
      checkurl $headurl
      echo -e "Checking Kernel Download link...."
      checkurl $imgurl
      wget -N -O linux-headers-d10.deb $headurl
      wget -N -O linux-image-d10.deb $imgurl
      dpkg -i linux-image-d10.deb
      dpkg -i linux-headers-d10.deb
    else
      echo -e "${Error} Not support x86_64及arm64/aarch64 Outside system !" && exit 1
    fi
  fi

  cd .. && rm -rf bbrplusnew
  detele_kernel
  BBR_grub
  echo -e "${Tip} ${Red_font_prefix}Please check if there is KernelInformation，without Kernel Never restart ${Font_color_suffix}"
  echo -e "${Tip} ${Red_font_prefix}rescue Not normal Kernel， To exclude this ${Font_color_suffix}"
  echo -e "${Tip}  Reboot VPS later ， Please re-run the script to open ${Red_font_prefix}BBRplus${Font_color_suffix}"
  stty erase '^H' && read -p " Need  Reboot VPS later ， To open BBRplus， Is it now  Reboot  ? [Y/n] :" yn
  [ -z "${yn}" ] && yn="y"
  if [[ $yn == [Yy] ]]; then
    echo -e "${Info} VPS  Reboot  middle ..."
    reboot
  fi
  #echo -e "${Tip} Kernel Install  over  complete，Please参考上面的Information Check check是否 Install become achievement及手动调整Kernel start up 顺序"

}

#启用BBR+fq
startbbrfq() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=fq" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBR+FQ Successfully modified， Reboot to take effect！"
}

#启用BBR+fq_pie
startbbrfqpie() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=fq_pie" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBR+FQ_PIE Successfully modified， Reboot to take effect！"
}

#启用BBR+cake
startbbrcake() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=cake" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBR+cake Successfully modified， Reboot to take effect！"
}

#启用BBRplus
startbbrplus() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=fq" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbrplus" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBRplus Successfully modified， Reboot to take effect！"
}

#启用Lotserver
startlotserver() {
  remove_bbr_lotserver
  if [[ "${release}" == "centos" ]]; then
    yum install ethtool -y
  else
    apt-get --allow-releaseinfo-change update
    apt-get install ethtool -y
  fi
  #bash <(wget -qO- https://git.io/lotServerInstall.sh) install
  echo | bash <(wget --no-check-certificate -qO- https://github.com/xidcn/LotServer_Vicer/raw/master/Install.sh) install
  sed -i '/advinacc/d' /appex/etc/config
  sed -i '/maxmode/d' /appex/etc/config
  echo -e "advinacc=\"1\"
maxmode=\"1\"" >>/appex/etc/config
  /appex/bin/lotServer.sh restart
  start_menu
}

#启用BBR2+FQ
startbbr2fq() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=fq" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr2" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBR2 Successfully modified， Reboot to take effect！"
}

#启用BBR2+FQ_PIE
startbbr2fqpie() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=fq_pie" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr2" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBR2 Successfully modified， Reboot to take effect！"
}

#启用BBR2+CAKE
startbbr2cake() {
  remove_bbr_lotserver
  echo "net.core.default_qdisc=cake" >>/etc/sysctl.d/99-sysctl.conf
  echo "net.ipv4.tcp_congestion_control=bbr2" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}BBR2 Successfully modified， Reboot to take effect！"
}

#Turn on ecn
startecn() {
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf

  echo "net.ipv4.tcp_ecn=1" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}Turn on ecn结束！"
}

# Closure ecn
closeecn() {
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf

  echo "net.ipv4.tcp_ecn=0" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info} Closure ecn结束！"
}

#Uninstall bbr+Sharp speed
remove_bbr_lotserver() {
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
  sysctl --system

  rm -rf bbrmod

  if [[ -e /appex/bin/lotServer.sh ]]; then
    echo | bash <(wget -qO- https://git.io/lotServerInstall.sh) uninstall
  fi
  clear
  # echo -e "${Info}:清除bbr/lotserver Speed Up  over  become。"
  # sleep 1s
}

#Uninstall all Speed Up 
remove_all() {
  rm -rf /etc/sysctl.d/*.conf
  #rm -rf /etc/sysctl.conf
  #touch /etc/sysctl.conf
  if [ ! -f "/etc/sysctl.conf" ]; then
    touch /etc/sysctl.conf
  else
    cat /dev/null >/etc/sysctl.conf
  fi
  sysctl --system
  sed -i '/DefaultTimeoutStartSec/d' /etc/systemd/system.conf
  sed -i '/DefaultTimeoutStopSec/d' /etc/systemd/system.conf
  sed -i '/DefaultRestartSec/d' /etc/systemd/system.conf
  sed -i '/DefaultLimitCORE/d' /etc/systemd/system.conf
  sed -i '/DefaultLimitNOFILE/d' /etc/systemd/system.conf
  sed -i '/DefaultLimitNPROC/d' /etc/systemd/system.conf

  sed -i '/soft nofile/d' /etc/security/limits.conf
  sed -i '/hard nofile/d' /etc/security/limits.conf
  sed -i '/soft nproc/d' /etc/security/limits.conf
  sed -i '/hard nproc/d' /etc/security/limits.conf

  sed -i '/ulimit -SHn/d' /etc/profile
  sed -i '/ulimit -SHn/d' /etc/profile
  sed -i '/required pam_limits.so/d' /etc/pam.d/common-session

  systemctl daemon-reload

  rm -rf bbrmod
  sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.conf
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
  sed -i '/fs.file-max/d' /etc/sysctl.conf
  sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
  sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
  sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
  sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
  sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
  sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
  sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
  sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
  sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
  sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
  sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
  sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
  sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
  if [[ -e /appex/bin/lotServer.sh ]]; then
    bash <(wget -qO- https://git.io/lotServerInstall.sh) uninstall
  fi
  clear
  echo -e "${Info}:清除 Speed Up  over  become。"
  sleep 1s
}

#优化System 配置
optimizing_system() {
  if [ ! -f "/etc/sysctl.conf" ]; then
    touch /etc/sysctl.conf
  fi
  sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
  sed -i '/fs.file-max/d' /etc/sysctl.conf
  sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
  sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
  sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
  sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
  sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
  sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
  sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf

  echo "net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
#net.ipv4.ip_forward = 1" >>/etc/sysctl.conf
  sysctl -p
  echo "*               soft    nofile           1000000
*               hard    nofile          1000000" >/etc/security/limits.conf
  echo "ulimit -SHn 1000000" >>/etc/profile
  read -p " Need  Reboot VPS later ，才能to take effectSystem 优化配置， Is it now  Reboot  ? [Y/n] :" yn
  [ -z "${yn}" ] && yn="y"
  if [[ $yn == [Yy] ]]; then
    echo -e "${Info} VPS  Reboot  middle ..."
    reboot
  fi
}

optimizing_system_johnrosen1() {
  if [ ! -f "/etc/sysctl.d/99-sysctl.conf" ]; then
    touch /etc/sysctl.d/99-sysctl.conf
  fi
  sed -i '/kernel.pid_max/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/vm.nr_hugepages/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.optmem_max/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.route_localnet/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.forwarding/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.forwarding/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.forwarding/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.forwarding/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.lo.forwarding/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.accept_ra/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.accept_ra/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.accept_ra/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.netdev_budget/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.netdev_budget_usecs/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/fs.file-max /d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.rmem_max/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.wmem_max/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.rmem_default/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.wmem_default/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.somaxconn/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.icmp_echo_ignore_all/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.icmp_echo_ignore_broadcasts/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.icmp_ignore_bogus_error_responses/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.accept_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.accept_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.secure_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.secure_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.send_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.send_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.rp_filter/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.rp_filter/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_keepalive_intvl/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_keepalive_probes/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_rfc1337/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.udp_rmem_min/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.udp_wmem_min/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.arp_ignore /d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.arp_ignore/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.all.arp_announce/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.conf.default.arp_announce/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_autocorking/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.core.default_qdisc/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_notsent_lowat/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_no_metrics_save/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_ecn/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_ecn_fallback/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.tcp_frto/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.accept_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.accept_redirects/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/vm.swappiness/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.ip_unprivileged_port_start/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/vm.overcommit_memory/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.neigh.default.gc_thresh3/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.neigh.default.gc_thresh2/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv4.neigh.default.gc_thresh1/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.neigh.default.gc_thresh3/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.neigh.default.gc_thresh2/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.neigh.default.gc_thresh1/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.netfilter.nf_conntrack_max/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.nf_conntrack_max/d' /etc/sysctl.d/99-sysctl.conf

  cat >'/etc/sysctl.d/99-sysctl.conf' <<EOF
#!!! Do not change these settings unless you know what you are doing !!!
net.ipv4.conf.all.route_localnet=1
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.default.forwarding = 1

net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.lo.forwarding = 1

net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0

net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.default.accept_ra = 2

net.core.netdev_max_backlog = 100000
net.core.netdev_budget = 50000
net.core.netdev_budget_usecs = 5000
#fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 67108864
net.core.wmem_default = 67108864
net.core.optmem_max = 65536
net.core.somaxconn = 10000

net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.all.rp_filter = 0
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_rfc1337 = 0
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_max_tw_buckets = 2000000
#net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_mtu_probing = 0

#net.ipv4.conf.all.arp_ignore = 2
#net.ipv4.conf.default.arp_ignore = 2
#net.ipv4.conf.all.arp_announce = 2
#net.ipv4.conf.default.arp_announce = 2

net.ipv4.tcp_autocorking = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 30000
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_ecn_fallback = 1
net.ipv4.tcp_frto = 0

net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
vm.swappiness = 1
#net.ipv4.ip_unprivileged_port_start = 0
vm.overcommit_memory = 1
#vm.nr_hugepages=1280
kernel.pid_max=64000
net.ipv4.neigh.default.gc_thresh3=8192
net.ipv4.neigh.default.gc_thresh2=4096
net.ipv4.neigh.default.gc_thresh1=2048
net.ipv6.neigh.default.gc_thresh3=8192
net.ipv6.neigh.default.gc_thresh2=4096
net.ipv6.neigh.default.gc_thresh1=2048
net.ipv4.tcp_max_syn_backlog = 262144
net.netfilter.nf_conntrack_max = 262144
net.nf_conntrack_max = 262144
EOF
  sysctl --system
  echo madvise >/sys/kernel/mm/transparent_hugepage/enabled

  sed -i '/DefaultTimeoutStartSec/d' /etc/systemd/system.conf
  sed -i '/DefaultTimeoutStopSec/d' /etc/systemd/system.conf
  sed -i '/DefaultRestartSec/d' /etc/systemd/system.conf
  sed -i '/DefaultLimitCORE/d' /etc/systemd/system.conf
  sed -i '/DefaultLimitNOFILE/d' /etc/systemd/system.conf
  sed -i '/DefaultLimitNPROC/d' /etc/systemd/system.conf

  cat >'/etc/systemd/system.conf' <<EOF
[Manager]
#DefaultTimeoutStartSec=90s
DefaultTimeoutStopSec=30s
#DefaultRestartSec=100ms
DefaultLimitCORE=infinity
DefaultLimitNOFILE=65535
DefaultLimitNPROC=65535
EOF

  sed -i '/soft nofile/d' /etc/security/limits.conf
  sed -i '/hard nofile/d' /etc/security/limits.conf
  sed -i '/soft nproc/d' /etc/security/limits.conf
  sed -i '/hard nproc/d' /etc/security/limits.conf
  cat >'/etc/security/limits.conf' <<EOF
* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535
EOF
  if grep -q "ulimit" /etc/profile; then
    :
  else
    sed -i '/ulimit -SHn/d' /etc/profile
    sed -i '/ulimit -SHn/d' /etc/profile
    echo "ulimit -SHn 65535" >>/etc/profile
    echo "ulimit -SHu 65535" >>/etc/profile
  fi
  if grep -q "pam_limits.so" /etc/pam.d/common-session; then
    :
  else
    sed -i '/required pam_limits.so/d' /etc/pam.d/common-session
    echo "session required pam_limits.so" >>/etc/pam.d/common-session
  fi
  systemctl daemon-reload
  echo -e "${Info}johnrosen1优化方案application 结束，可能 Need  Reboot ！"
}

#更 new  script 
Update_Shell() {
  echo -e "Current  Version 本为 [ ${sh_ver} ]，Start  Check 测最 new  Version 本..."
  sh_new_ver=$(wget -qO- "https://git.io/coolspeeda" | grep 'sh_ver="' | awk -F "=" '{print $NF}' | sed 's/\"//g' | head -1)
  [[ -z ${sh_new_ver} ]] && echo -e "${Error}  Check 测最 new  Version 本fail !" && start_menu
  if [ ${sh_new_ver} != ${sh_ver} ]; then
    echo -e "发现 new  Version 本[ ${sh_new_ver} ]，是否更 new ？[Y/n]"
    read -p "(默认: y):" yn
    [[ -z "${yn}" ]] && yn="y"
    if [[ ${yn} == [Yy] ]]; then
      wget -N "https://${github}/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
      echo -e " script Already更 new 为最 new  Version 本[ ${sh_new_ver} ] !"
    else
      echo && echo "	Already取消..." && echo
    fi
  else
    echo -e "Current Already是最 new  Version 本[ ${sh_new_ver} ] !"
    sleep 2s && ./tcp.sh
  fi
}

#Switch to not uninstall Kernel Version 本
gototcpx() {
  clear
  wget -O tcpx.sh "https://git.io/JYxKU" && chmod +x tcpx.sh && ./tcpx.sh
}

#切换到秋水逸冰BBR Install  script 
gototeddysun_bbr() {
  clear
  wget https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

#切换到一键DD Install System  script   new 手勿入
gotodd() {
  clear
  wget -qO ~/Network-Reinstall-System-Modify.sh 'https://github.com/ylx2016/reinstall/raw/master/Network-Reinstall-System-Modify.sh' && chmod a+x ~/Network-Reinstall-System-Modify.sh && bash ~/Network-Reinstall-System-Modify.sh -UI_Options
}

#Disable IPv6
closeipv6() {
  clear
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.conf

  echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}Disable IPv6结束，可能 Need  Reboot ！"
}

#Turn on IPv6
openipv6() {
  clear
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.d/99-sysctl.conf
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
  sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.conf

  echo "net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" >>/etc/sysctl.d/99-sysctl.conf
  sysctl --system
  echo -e "${Info}Turn on IPv6结束，可能 Need  Reboot ！"
}

#Start 菜单
start_menu() {
  clear
  echo && echo -e " TCP Speed Up  一 Key installation management script  ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix} from blog.ylx.me Use with caution for hens
 ${Green_font_prefix}0.${Font_color_suffix} Upgrade script
 ${Green_font_prefix}9.${Font_color_suffix} Switch to not uninstall Kernel Version 本	${Green_font_prefix}10.${Font_color_suffix} Switch to one-click DD system script
 ${Green_font_prefix}1.${Font_color_suffix}  Install BBR Original  Version Kernel
 ${Green_font_prefix}2.${Font_color_suffix}  Install BBRplus Version Kernel		${Green_font_prefix}5.${Font_color_suffix}  Install  BBRplus new  Version Kernel
 ${Green_font_prefix}3.${Font_color_suffix}  Install Lotserver (Sharp speed) Kernel	${Green_font_prefix}6.${Font_color_suffix}  Install  xanmod Version Kernel
 ${Green_font_prefix}11.${Font_color_suffix} Use BBR+FQ Speed Up 		${Green_font_prefix}12.${Font_color_suffix} Use BBR+FQ_PIE Speed Up  
 ${Green_font_prefix}13.${Font_color_suffix} Use BBR+CAKE Speed Up 
 ${Green_font_prefix}14.${Font_color_suffix} Use BBR2+FQ Speed Up 	 	${Green_font_prefix}15.${Font_color_suffix} Use BBR2+FQ_PIE Speed Up  
 ${Green_font_prefix}16.${Font_color_suffix} Use BBR2+CAKE Speed Up 
 ${Green_font_prefix}17.${Font_color_suffix} Turn on ECN	 		${Green_font_prefix}18.${Font_color_suffix}  Closure ECN
 ${Green_font_prefix}19.${Font_color_suffix} Use BBRplus+FQ Version  Speed Up  
 ${Green_font_prefix}20.${Font_color_suffix} Use Lotserver(Sharp speed) Speed Up  
 ${Green_font_prefix}21.${Font_color_suffix} System Configuration optimization	 	${Green_font_prefix}22.${Font_color_suffix} application johnrosen1 Optimization plan
 ${Green_font_prefix}23.${Font_color_suffix} Disable IPv6	 		${Green_font_prefix}24.${Font_color_suffix} Turn on IPv6  
 ${Green_font_prefix}25.${Font_color_suffix} Uninstall all Speed Up 	 	${Green_font_prefix}99.${Font_color_suffix} Quit script  
————————————————————————————————————————————————————————————————" &&
    check_status
  get_system_info
  echo -e " System Information: ${Font_color_suffix}$opsy ${Green_font_prefix}$virtual${Font_color_suffix} $arch ${Green_font_prefix}$kern${Font_color_suffix} "
  if [[ ${kernel_status} == "noinstall" ]]; then
    echo -e " Current state: ${Green_font_prefix}not yet Install ${Font_color_suffix}  Speed Up Kernel ${Red_font_prefix}Please first Install Kernel${Font_color_suffix}"
  else
    echo -e " Current state: ${Green_font_prefix}Already Install ${Font_color_suffix} ${Red_font_prefix}${kernel_status}${Font_color_suffix}  Speed Up Kernel , ${Green_font_prefix}${run_status}${Font_color_suffix}"

  fi
  echo -e " Current The congestion control algorithm is: ${Green_font_prefix}${net_congestion_control}${Font_color_suffix} Current The queue algorithm is: ${Green_font_prefix}${net_qdisc}${Font_color_suffix} "

  read -p " Please enter the number :" num
  case "$num" in
  0)
    Update_Shell
    ;;
  1)
    check_sys_bbr
    ;;
  2)
    check_sys_bbrplus
    ;;
  3)
    check_sys_Lotsever
    ;;
  # 4)
  # check_sys_cloud
  # ;;
  5)
    check_sys_bbrplusnew
    ;;
  6)
    check_sys_xanmod
    ;;
  9)
    gototcpx
    ;;
  10)
    gotodd
    ;;
  11)
    startbbrfq
    ;;
  12)
    startbbrfqpie
    ;;
  13)
    startbbrcake
    ;;
  14)
    startbbr2fq
    ;;
  15)
    startbbr2fqpie
    ;;
  16)
    startbbr2cake
    ;;
  17)
    startecn
    ;;
  18)
    closeecn
    ;;
  19)
    startbbrplus
    ;;
  20)
    startlotserver
    ;;
  21)
    optimizing_system
    ;;
  22)
    optimizing_system_johnrosen1
    ;;
  23)
    closeipv6
    ;;
  24)
    openipv6
    ;;
  25)
    remove_all
    ;;
  99)
    exit 1
    ;;
  *)
    clear
    echo -e "${Error}:Please输入正确数字 [0-99]"
    sleep 5s
    start_menu
    ;;
  esac
}
#############Kernel管理组件#############

#删除多余Kernel
detele_kernel() {
  if [[ "${release}" == "centos" ]]; then
    rpm_total=$(rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | wc -l)
    if [ "${rpm_total}" ] >"1"; then
      echo -e " Check Measured ${rpm_total} Rest Kernel，Start Uninstall ..."
      for ((integer = 1; integer <= ${rpm_total}; integer++)); do
        rpm_del=$(rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer})
        echo -e "Start Uninstall  ${rpm_del} Kernel..."
        rpm --nodeps -e ${rpm_del}
        echo -e "Uninstall  ${rpm_del} Kernel Uninstall  over  become，Continue..."
      done
      echo --nodeps -e "KernelUninstall  over  complete，Continue..."
    else
      echo -e "  Check Measured Kernel Incorrect quantity，Please Check check !" && exit 1
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    deb_total=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l)
    if [ "${deb_total}" ] >"1"; then
      echo -e " Check Measured ${deb_total} Rest Kernel，Start Uninstall ..."
      for ((integer = 1; integer <= ${deb_total}; integer++)); do
        deb_del=$(dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer})
        echo -e "Start Uninstall  ${deb_del} Kernel..."
        apt-get purge -y ${deb_del}
        echo -e "Uninstall  ${deb_del} KernelUninstall  over  become，Continue..."
      done
      echo -e "KernelUninstall  over  complete，Continue..."
    else
      echo -e "  Check Measured Kernel Incorrect quantity，Please Check check !" && exit 1
    fi
  fi
}

detele_kernel_head() {
  if [[ "${release}" == "centos" ]]; then
    rpm_total=$(rpm -qa | grep kernel-headers | grep -v "${kernel_version}" | grep -v "noarch" | wc -l)
    if [ "${rpm_total}" ] >"1"; then
      echo -e " Check Measured ${rpm_total} Rest headKernel，Start Uninstall ..."
      for ((integer = 1; integer <= ${rpm_total}; integer++)); do
        rpm_del=$(rpm -qa | grep kernel-headers | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer})
        echo -e "Start Uninstall  ${rpm_del} headersKernel..."
        rpm --nodeps -e ${rpm_del}
        echo -e "Uninstall  ${rpm_del} KernelUninstall  over  become，Continue..."
      done
      echo --nodeps -e "KernelUninstall  over  complete，Continue..."
    else
      echo -e "  Check Measured Kernel Incorrect quantity，Please Check check !" && exit 1
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    deb_total=$(dpkg -l | grep linux-headers | awk '{print $2}' | grep -v "${kernel_version}" | wc -l)
    if [ "${deb_total}" ] >"1"; then
      echo -e " Check Measured ${deb_total} Rest headKernel，Start Uninstall ..."
      for ((integer = 1; integer <= ${deb_total}; integer++)); do
        deb_del=$(dpkg -l | grep linux-headers | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer})
        echo -e "Start Uninstall  ${deb_del} headersKernel..."
        apt-get purge -y ${deb_del}
        echo -e "Uninstall  ${deb_del} KernelUninstall  over  become，Continue..."
      done
      echo -e "KernelUninstall  over  complete，Continue..."
    else
      echo -e "  Check Measured Kernel Incorrect quantity，Please Check check !" && exit 1
    fi
  fi
}

#更 new 引导
BBR_grub() {
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "6" ]]; then
      if [ -f "/boot/grub/grub.conf" ]; then
        sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
      elif [ -f "/boot/grub/grub.cfg" ]; then
        grub-mkconfig -o /boot/grub/grub.cfg
        grub-set-default 0
      elif [ -f "/boot/efi/EFI/centos/grub.cfg" ]; then
        grub-mkconfig -o /boot/efi/EFI/centos/grub.cfg
        grub-set-default 0
      elif [ -f "/boot/efi/EFI/redhat/grub.cfg" ]; then
        grub-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
        grub-set-default 0
      else
        echo -e "${Error} grub.conf/grub.cfg Not found，Please Check check."
        exit
      fi
    elif [[ ${version} == "7" ]]; then
      if [ -f "/boot/grub2/grub.cfg" ]; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
        grub2-set-default 0
      elif [ -f "/boot/efi/EFI/centos/grub.cfg" ]; then
        grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
        grub2-set-default 0
      elif [ -f "/boot/efi/EFI/redhat/grub.cfg" ]; then
        grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
        grub2-set-default 0
      else
        echo -e "${Error} grub.cfg Not found，Please Check check."
        exit
      fi
    elif [[ ${version} == "8" ]]; then
      if [ -f "/boot/grub2/grub.cfg" ]; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
        grub2-set-default 0
      elif [ -f "/boot/efi/EFI/centos/grub.cfg" ]; then
        grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
        grub2-set-default 0
      elif [ -f "/boot/efi/EFI/redhat/grub.cfg" ]; then
        grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
        grub2-set-default 0
      else
        echo -e "${Error} grub.cfg Not found，Please Check check."
        exit
      fi
      grubby --info=ALL | awk -F= '$1=="kernel" {print i++ " : " $2}'
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    /usr/sbin/update-grub
    #exit 1
  fi
}

#############Kernel管理组件#############

#############System  Check 测组件#############

# Check checkSystem 
check_sys() {
  if [[ -f /etc/redhat-release ]]; then
    release="centos"
  elif cat /etc/issue | grep -q -E -i "debian"; then
    release="debian"
  elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="ubuntu"
  elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
  elif cat /proc/version | grep -q -E -i "debian"; then
    release="debian"
  elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="ubuntu"
  elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
  fi

  #from https://github.com/oooldking
  get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
  }
  get_system_info() {
    cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
    #cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
    #freq=$(awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
    #corescache=$(awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
    #tram=$(free -m | awk '/Mem/ {print $2}')
    #uram=$(free -m | awk '/Mem/ {print $3}')
    #bram=$(free -m | awk '/Mem/ {print $6}')
    #swap=$(free -m | awk '/Swap/ {print $2}')
    #uswap=$(free -m | awk '/Swap/ {print $3}')
    #up=$(awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime)
    #load=$(w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
    opsy=$(get_opsy)
    arch=$(uname -m)
    #lbit=$(getconf LONG_BIT)
    kern=$(uname -r)

    # disk_size1=$( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|overlay|shm|udev|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' )
    # disk_size2=$( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|overlay|shm|udev|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' )
    # disk_total_size=$( calc_disk ${disk_size1[@]} )
    # disk_used_size=$( calc_disk ${disk_size2[@]} )

    #tcpctrl=$(sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}')

    virt_check
  }
  virt_check() {
    # if hash ifconfig 2>/dev/null; then
    # eth=$(ifconfig)
    # fi

    virtualx=$(dmesg) 2>/dev/null

    if [[ $(which dmidecode) ]]; then
      sys_manu=$(dmidecode -s system-manufacturer) 2>/dev/null
      sys_product=$(dmidecode -s system-product-name) 2>/dev/null
      sys_ver=$(dmidecode -s system-version) 2>/dev/null
    else
      sys_manu=""
      sys_product=""
      sys_ver=""
    fi

    if grep docker /proc/1/cgroup -qa; then
      virtual="Docker"
    elif grep lxc /proc/1/cgroup -qa; then
      virtual="Lxc"
    elif grep -qa container=lxc /proc/1/environ; then
      virtual="Lxc"
    elif [[ -f /proc/user_beancounters ]]; then
      virtual="OpenVZ"
    elif [[ "$virtualx" == *kvm-clock* ]]; then
      virtual="KVM"
    elif [[ "$cname" == *KVM* ]]; then
      virtual="KVM"
    elif [[ "$cname" == *QEMU* ]]; then
      virtual="KVM"
    elif [[ "$virtualx" == *"VMware Virtual Platform"* ]]; then
      virtual="VMware"
    elif [[ "$virtualx" == *"Parallels Software International"* ]]; then
      virtual="Parallels"
    elif [[ "$virtualx" == *VirtualBox* ]]; then
      virtual="VirtualBox"
    elif [[ -e /proc/xen ]]; then
      virtual="Xen"
    elif [[ "$sys_manu" == *"Microsoft Corporation"* ]]; then
      if [[ "$sys_product" == *"Virtual Machine"* ]]; then
        if [[ "$sys_ver" == *"7.0"* || "$sys_ver" == *"Hyper-V" ]]; then
          virtual="Hyper-V"
        else
          virtual="Microsoft Virtual Machine"
        fi
      fi
    else
      virtual="Dedicated母鸡"
    fi
  }

  # Check check依赖
  if [[ "${release}" == "centos" ]]; then
    if (yum list installed ca-certificates | grep '202'); then
      echo 'CA证书 Check checkOK'
    else
      echo 'CA证书 Check check不通过，处理 middle '
      yum install ca-certificates -y
      update-ca-trust force-enable
    fi
    if ! type curl >/dev/null 2>&1; then
      echo 'curl not yet Install   Install  middle '
      yum install curl -y
    else
      echo 'curl Already Install ，Continue'
    fi

    if ! type wget >/dev/null 2>&1; then
      echo 'wget not yet Install   Install  middle '
      yum install curl -y
    else
      echo 'wget Already Install ，Continue'
    fi

    if ! type dmidecode >/dev/null 2>&1; then
      echo 'dmidecode not yet Install   Install  middle '
      yum install dmidecode -y
    else
      echo 'dmidecode Already Install ，Continue'
    fi

  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    if (apt list --installed | grep 'ca-certificates' | grep '202'); then
      echo 'CA证书 Check checkOK'
    else
      echo 'CA证书 Check check不通过，处理 middle '
      apt-get --allow-releaseinfo-change update && apt-get install ca-certificates -y
      update-ca-certificates
    fi
    if ! type curl >/dev/null 2>&1; then
      echo 'curl not yet Install   Install  middle '
      apt-get --allow-releaseinfo-change update && apt-get install curl -y
    else
      echo 'curl Already Install ，Continue'
    fi

    if ! type wget >/dev/null 2>&1; then
      echo 'wget not yet Install   Install  middle '
      apt-get --allow-releaseinfo-change update && apt-get install wget -y
    else
      echo 'wget Already Install ，Continue'
    fi

    if ! type dmidecode >/dev/null 2>&1; then
      echo 'dmidecode not yet Install   Install  middle '
      apt-get --allow-releaseinfo-change update && apt-get install dmidecode -y
    else
      echo 'dmidecode Already Install ，Continue'
    fi
  fi
}

# Check checkLinux Version 本
check_version() {
  if [[ -s /etc/redhat-release ]]; then
    version=$(grep -oE "[0-9.]+" /etc/redhat-release | cut -d . -f 1)
  else
    version=$(grep -oE "[0-9.]+" /etc/issue | cut -d . -f 1)
  fi
  bit=$(uname -m)
  # if [[ ${bit} = "x86_64" ]]; then
  # bit="x64"
  # else
  # bit="x32"
  # fi
}

# Check check Install bbr的System 要求
check_sys_bbr() {
  check_version
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" ]]; then
      installbbr
    else
      echo -e "${Error} BBR The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    apt-get --fix-broken install -y && apt-get autoremove -y
    installbbr
  else
    echo -e "${Error} BBR The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
  fi
}

check_sys_bbrplus() {
  check_version
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" ]]; then
      installbbrplus
    else
      echo -e "${Error} BBRplus The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    apt-get --fix-broken install -y && apt-get autoremove -y
    installbbrplus
  else
    echo -e "${Error} BBRplus The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
  fi
}

check_sys_bbrplusnew() {
  check_version
  if [[ "${release}" == "centos" ]]; then
    #if [[ ${version} == "7" ]]; then
    if [[ ${version} == "7" || ${version} == "8" ]]; then
      installbbrplusnew
    else
      echo -e "${Error} BBRplusNew The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    apt-get --fix-broken install -y && apt-get autoremove -y
    installbbrplusnew
  else
    echo -e "${Error} BBRplusNew The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
  fi
}

check_sys_xanmod() {
  check_version
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "7" || ${version} == "8" ]]; then
      installxanmod
    else
      echo -e "${Error} xanmod The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
    fi
  elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
    apt-get --fix-broken install -y && apt-get autoremove -y
    installxanmod
  else
    echo -e "${Error} xanmod The kernel does not support the current system ${release} ${version} ${bit} !" && exit 1
  fi
}

# Check check Install Lotsever的System 要求
check_sys_Lotsever() {
  check_version
  bit=$(uname -m)
  if [[ ${bit} != "x86_64" ]]; then
    echo -e "${Error} Not support x86_64 Outside system !" && exit 1
  fi
  if [[ "${release}" == "centos" ]]; then
    if [[ ${version} == "6" ]]; then
      kernel_version="2.6.32-504"
      installlot
    elif [[ ${version} == "7" ]]; then
      yum -y install net-tools
      kernel_version="4.11.2-1"
      installlot
    else
      echo -e "${Error} LotseverNot support Current System  ${release} ${version} ${bit} !" && exit 1
    fi
  elif [[ "${release}" == "debian" ]]; then
    if [[ ${version} == "7" || ${version} == "8" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        kernel_version="3.16.0-4"
        installlot
      elif [[ ${bit} == "i386" ]]; then
        kernel_version="3.2.0-4"
        installlot
      fi
    elif [[ ${version} == "9" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        kernel_version="4.9.0-4"
        installlot
      fi
    else
      echo -e "${Error} LotseverNot support Current System  ${release} ${version} ${bit} !" && exit 1
    fi
  elif [[ "${release}" == "ubuntu" ]]; then
    if [[ ${version} -ge "12" ]]; then
      if [[ ${bit} == "x86_64" ]]; then
        kernel_version="4.4.0-47"
        installlot
      elif [[ ${bit} == "i386" ]]; then
        kernel_version="3.13.0-29"
        installlot
      fi
    else
      echo -e "${Error} LotseverNot support Current System  ${release} ${version} ${bit} !" && exit 1
    fi
  else
    echo -e "${Error} LotseverNot support Current System  ${release} ${version} ${bit} !" && exit 1
  fi
}

# Check checkSystem Current state
check_status() {
  kernel_version=$(uname -r | awk -F "-" '{print $1}')
  kernel_version_full=$(uname -r)
  net_congestion_control=$(cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}')
  net_qdisc=$(cat /proc/sys/net/core/default_qdisc | awk '{print $1}')
  #kernel_version_r=$(uname -r | awk '{print $1}')
  # if [[ ${kernel_version_full} = "4.14.182-bbrplus" || ${kernel_version_full} = "4.14.168-bbrplus" || ${kernel_version_full} = "4.14.98-bbrplus" || ${kernel_version_full} = "4.14.129-bbrplus" || ${kernel_version_full} = "4.14.160-bbrplus" || ${kernel_version_full} = "4.14.166-bbrplus" || ${kernel_version_full} = "4.14.161-bbrplus" ]]; then
  if [[ ${kernel_version_full} == *bbrplus* ]]; then
    kernel_status="BBRplus"
    # elif [[ ${kernel_version} = "3.10.0" || ${kernel_version} = "3.16.0" || ${kernel_version} = "3.2.0" || ${kernel_version} = "4.4.0" || ${kernel_version} = "3.13.0"  || ${kernel_version} = "2.6.32" || ${kernel_version} = "4.9.0" || ${kernel_version} = "4.11.2" || ${kernel_version} = "4.15.0" ]]; then
    # kernel_status="Lotserver"
  elif [[ ${kernel_version_full} == *4.9.0-4* || ${kernel_version_full} == *4.15.0-30* || ${kernel_version_full} == *4.8.0-36* || ${kernel_version_full} == *3.16.0-77* || ${kernel_version_full} == *3.16.0-4* || ${kernel_version_full} == *3.2.0-4* || ${kernel_version_full} == *4.11.2-1* || ${kernel_version_full} == *2.6.32-504* || ${kernel_version_full} == *4.4.0-47* || ${kernel_version_full} == *3.13.0-29 || ${kernel_version_full} == *4.4.0-47* ]]; then
    kernel_status="Lotserver"
  elif [[ $(echo ${kernel_version} | awk -F'.' '{print $1}') == "4" ]] && [[ $(echo ${kernel_version} | awk -F'.' '{print $2}') -ge 9 ]] || [[ $(echo ${kernel_version} | awk -F'.' '{print $1}') == "5" ]]; then
    kernel_status="BBR"
  else
    kernel_status="noinstall"
  fi

  if [[ ${kernel_status} == "BBR" ]]; then
    run_status=$(cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}')
    if [[ ${run_status} == "bbr" ]]; then
      run_status=$(cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}')
      if [[ ${run_status} == "bbr" ]]; then
        run_status="BBR start up become achievement"
      else
        run_status="BBR start up fail"
      fi
    elif [[ ${run_status} == "bbr2" ]]; then
      run_status=$(cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}')
      if [[ ${run_status} == "bbr2" ]]; then
        run_status="BBR2 start up become achievement"
      else
        run_status="BBR2 start up fail"
      fi
    elif [[ ${run_status} == "tsunami" ]]; then
      run_status=$(lsmod | grep "tsunami" | awk '{print $1}')
      if [[ ${run_status} == "tcp_tsunami" ]]; then
        run_status="BBR魔改 Version  start up become achievement"
      else
        run_status="BBR魔改 Version  start up fail"
      fi
    elif [[ ${run_status} == "nanqinlang" ]]; then
      run_status=$(lsmod | grep "nanqinlang" | awk '{print $1}')
      if [[ ${run_status} == "tcp_nanqinlang" ]]; then
        run_status="暴力BBR魔改 Version  start up become achievement"
      else
        run_status="暴力BBR魔改 Version  start up fail"
      fi
    else
      run_status="not yet Install  Speed Up Module"
    fi

  elif [[ ${kernel_status} == "Lotserver" ]]; then
    if [[ -e /appex/bin/lotServer.sh ]]; then
      run_status=$(bash /appex/bin/lotServer.sh status | grep "LotServer" | awk '{print $3}')
      if [[ ${run_status} == "running!" ]]; then
        run_status=" start up become achievement"
      else
        run_status=" start up fail"
      fi
    else
      run_status="not yet Install  Speed Up Module"
    fi
  elif [[ ${kernel_status} == "BBRplus" ]]; then
    run_status=$(cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}')
    if [[ ${run_status} == "bbrplus" ]]; then
      run_status=$(cat /proc/sys/net/ipv4/tcp_congestion_control | awk '{print $1}')
      if [[ ${run_status} == "bbrplus" ]]; then
        run_status="BBRplus start up become achievement"
      else
        run_status="BBRplus start up fail"
      fi
    elif [[ ${run_status} == "bbr" ]]; then
      run_status="BBR start up become achievement"
    else
      run_status="not yet Install  Speed Up Module"
    fi
  fi
}

#############System  Check 测组件#############
check_sys
check_version
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本 script Not support Current System  ${release} !" && exit 1
start_menu
