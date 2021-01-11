#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cat <<"EOF"

                           _
 ___  ___  _ __   __ _ ___| |__  _   _  __      _____
/ __|/ _ \| '_ \ / _` / __| '_ \| | | | \ \ /\ / / _ \
\__ \ (_) | | | | (_| \__ \ | | | |_| |  \ V  V / (_) |
|___/\___/|_| |_|\__, |___/_| |_|\__,_|   \_/\_/ \___/
                 |___/


Author: songshu wo
EOF

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
}

welcome() {
    echo ""
    echo "欢迎使用 ddns gandi。"
    echo "安装即将开始"
    echo "如果您想取消安装，"
    echo "请在 3 秒钟内按 Ctrl+C 终止此脚本。"
    echo ""
    sleep 3
}

yum_update() {
    echo "正在优化 yum . . ."
    echo "此过程稍慢 因为需要升级系统依赖"
    yum update -y >>/dev/null 2>&1
}

yum_git_check() {
    echo "正在检查 Git 安装情况 . . ."
    if command -v git >>/dev/null 2>&1; then
        echo "Git 似乎存在，安装过程继续 . . ."
    else
        echo "Git 未安装在此系统上，正在进行安装"
        yum install git -y >>/dev/null 2>&1
    fi
}

yum_python_check() {
    echo "正在检查 python 安装情况 . . ."
    if command -v python3 >>/dev/null 2>&1; then
        U_V1=$(python3 -V 2>&1 | awk '{print $2}' | awk -F '.' '{print $1}')
        U_V2=$(python3 -V 2>&1 | awk '{print $2}' | awk -F '.' '{print $2}')
        if [ $U_V1 -gt 3 ]; then
            echo 'Python 3.6+ 存在 . . .'
        elif [ $U_V2 -ge 6 ]; then
            echo 'Python 3.6+ 存在 . . .'
            PYV=$U_V1.$U_V2
            PYV=$(which python$PYV)
        else
            if command -v python3.6 >>/dev/null 2>&1; then
                echo 'Python 3.6+ 存在 . . .'
                PYV=$(which python3.6)
            else
                echo "Python3.6 未安装在此系统上，正在进行安装"
                yum install python3 -y >>/dev/null 2>&1
                update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 >>/dev/null 2>&1
                PYV=$(which python3.6)
            fi
        fi
    else
        echo "Python3.6 未安装在此系统上，正在进行安装"
        yum install python3 -y >>/dev/null 2>&1
        update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 >>/dev/null 2>&1
    fi
    if command -v pip3 >>/dev/null 2>&1; then
        echo 'pip 存在 . . .'
    else
        echo "pip3 未安装在此系统上，正在进行安装"
        yum install -y python3-pip >>/dev/null 2>&1
    fi
}

apt_update() {
    echo "正在优化 apt-get . . ."
    apt-get install sudo cron -y >>/dev/null 2>&1
    apt-get update >>/dev/null 2>&1
}

apt_git_check() {
    echo "正在检查 Git 安装情况 . . ."
    if command -v git >>/dev/null 2>&1; then
        echo "Git 似乎存在, 安装过程继续 . . ."
    else
        echo "Git 未安装在此系统上，正在进行安装"
        apt-get install git -y >>/dev/null 2>&1
    fi
}

apt_python_check() {
    echo "正在检查 python 安装情况 . . ."
    if command -v python3 >>/dev/null 2>&1; then
        U_V1=$(python3 -V 2>&1 | awk '{print $2}' | awk -F '.' '{print $1}')
        U_V2=$(python3 -V 2>&1 | awk '{print $2}' | awk -F '.' '{print $2}')
        if [ $U_V1 -gt 3 ]; then
            echo 'Python 3.6+ 存在 . . .'
        elif [ $U_V2 -ge 6 ]; then
            echo 'Python 3.6+ 存在 . . .'
            PYV=$U_V1.$U_V2
            PYV=$(which python$PYV)
        else
            if command -v python3.6 >>/dev/null 2>&1; then
                echo 'Python 3.6+ 存在 . . .'
                PYV=$(which python3.6)
            else
                echo "Python3 未安装在此系统上，正在进行安装"
                add-apt-repository ppa:deadsnakes/ppa -y
                apt-get update >>/dev/null 2>&1
                apt-get install python3 -y >>/dev/null 2>&1
                update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3 1 >>/dev/null 2>&1
                PYV=$(which python3.6)
            fi
        fi
    else
        echo "Python3.6 未安装在此系统上，正在进行安装"
        add-apt-repository ppa:deadsnakes/ppa -y
        apt-get update >>/dev/null 2>&1
        apt-get install python3 -y >>/dev/null 2>&1
        update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3 1 >>/dev/null 2>&1
    fi
    if command -v pip3 >>/dev/null 2>&1; then
        echo 'pip 存在 . . .'
    else
        echo "pip3 未安装在此系统上，正在进行安装"
        apt-get install -y python3-pip >>/dev/null 2>&1
    fi
}

debian_python_check() {
    echo "正在检查 python 安装情况 . . ."
    if command -v python3 >>/dev/null 2>&1; then
        U_V1=$(python3 -V 2>&1 | awk '{print $2}' | awk -F '.' '{print $1}')
        U_V2=$(python3 -V 2>&1 | awk '{print $2}' | awk -F '.' '{print $2}')
        if [ $U_V1 -gt 3 ]; then
            echo 'Python 3.6+ 存在 . . .'
        elif [ $U_V2 -ge 6 ]; then
            echo 'Python 3.6+ 存在 . . .'
            PYV=$U_V1.$U_V2
            PYV=$(which python$PYV)
        else
            if command -v python3.6 >>/dev/null 2>&1; then
                echo 'Python 3.6+ 存在 . . .'
                PYV=$(which python3.6)
            else
                echo "Python3.6 未安装在此系统上，正在进行安装"
                apt-get update >>/dev/null 2>&1
                apt-get install python3 -y >>/dev/null 2>&1
                update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3 1 >>/dev/null 2>&1
                PYV=$(which python3.6)
            fi
        fi
    else
        echo "Python3.6 未安装在此系统上，正在进行安装"
        apt-get update >>/dev/null 2>&1
        apt-get install python3 cron -y >>/dev/null 2>&1
        update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3 1 >>/dev/null 2>&1
    fi
    echo "正在检查 pip3 安装情况 . . ."
    if command -v pip3 >>/dev/null 2>&1; then
        echo 'pip 存在 . . .'
    else
        echo "pip3 未安装在此系统上，正在进行安装"
        apt-get install -y python3-pip >>/dev/null 2>&1
    fi
}

download_repo() {
    echo "下载 repository 中 . . ."
    cd /root >>/dev/null 2>&1
    git clone https://github.com/shzxm/gandi-ddns.git
    cd /root/gandi-ddns
    echo "Hello World!" >/root/gandi-ddns/.lock
}

pypi_install() {
    echo "下载安装 pypi 依赖中 . . ."
    $PYV -m pip install --upgrade pip >>/dev/null 2>&1
    $PYV -m pip install -r requirements.txt >>/dev/null 2>&1
}

configure() {
    cp config-template.txt config.txt
    echo -n "Please enter apikey:"
    read apikey
    echo "Writting apikey..."
    sed -i -e "s/apikey = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/apikey = ${apikey}/g" config.txt
    echo "Please enter domain:"
    read domain
    echo "Writting domain..."
    sed -i -e "s/domain = example.com/domain = ${domain}/g" config.txt
    echo "Please enter a_name:"
    read a_name
    echo "Writting a_name..."
    sed -i -e "s/a_name = raspbian/a_name = ${a_name}/g" config.txt
    cat /root/gandi-ddns/config.txt
    echo "Writting system config..."
    echo "@reboot python3 /root/gandi-ddns/gandi_ddns.py &" >>/var/spool/cron/root
    echo "*/5 * * * * python3 /root/gandi-ddns/gandi_ddns.py" >>/var/spool/cron/root
    chmod +x /root/gandi-ddns/gandi_ddns.py
    service crond restart
    python3 /root/gandi-ddns/gandi_ddns.py
}

install_require() {
  if [ "$release" = "centos" ]; then
    echo "系统检测通过。"
    yum_update
    yum_git_check
    yum_python_check
    pypi_install
  elif [ "$release" = "ubuntu" ]; then
    echo "系统检测通过。"
    apt_update
    apt_git_check
    apt_python_check
    pypi_install
  elif [ "$release" = "debian" ]; then
    echo "系统检测通过。"
    welcome
    apt_update
    apt_git_check
    debian_python_check
    pypi_install
  else
    echo "目前暂时不支持此系统。"
  fi
  exit 1
}

start_installation() {
  if [ "$release" = "centos" ]; then
    echo "系统检测通过。"
    welcome
    yum_update
    yum_git_check
    yum_python_check
    download_repo
    pypi_install
    configure
    echo "ddns 已经安装完毕"
  elif [ "$release" = "ubuntu" ]; then
    echo "系统检测通过。"
    welcome
    apt_update
    apt_git_check
    apt_python_check
    download_repo
    pypi_install
    configure
    echo "ddns 已经安装完毕"
  elif [ "$release" = "debian" ]; then
    echo "系统检测通过。"
    welcome
    apt_update
    apt_git_check
    debian_python_check
    download_repo
    pypi_install
    configure
    echo "ddns 已经安装完毕"
  else
    echo "目前暂时不支持此系统。"
  fi
  exit 1
}

shon_online() {
  echo "请选择您需要进行的操作:"
  echo "  1) 安装 ddns"
  echo "  2) 重新安装 ddns 依赖"
  echo "  3) 退出脚本"
  echo ""
  echo "     Version：0.1"
  echo ""
  echo -n "请输入编号: "
  read N
  case $N in
  1) start_installation ;;
  2) install_require ;;
  3) exit ;;
  *) echo "Wrong input!" ;;
  esac
}

check_sys
shon_online
