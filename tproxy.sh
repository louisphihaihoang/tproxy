#!/bin/bash

option="${1}"

current_folder=$(pwd)

function install() {
    echo "install tproxy"
    rm -rf "$current_folder"/tproxy
    echo "clone tproxy from github"
    git clone https://github.com/louisphihaihoang/tproxy.git
    echo "clone tproxy from github success"
    echo "install package"
    cp "$current_folder"/tproxy/bin/proxy /usr/bin/proxy
    chmod +x /usr/bin/proxy
    cp "$current_folder"/tproxy/bin/socks /usr/bin/socks
    chmod +x /usr/bin/socks
    cp "$current_folder"/tproxy/bin/tproxy /usr/bin/tproxy
    chmod +x /usr/bin/tproxy
    echo "install package success"
    echo "install config"
    mkdir -p /etc/tproxy
    mkdir -p /etc/tproxy/logs
    cp "$current_folder"/tproxy/tproxy.cfg /etc/tproxy/tproxy.cfg
    touch /etc/tproxy/restart
    chmod 644 /etc/tproxy/restart
    touch /etc/tproxy/proxy.cfg
    chmod 644 /etc/tproxy/proxy.cfg
    echo "install config success"
    echo "install service"
    cp "$current_folder"/tproxy/tproxy.service /usr/lib/systemd/system/tproxy.service
    chmod 644 /usr/lib/systemd/system/tproxy.service
    echo "install service success"
    echo "reload daemon"
    systemctl daemon-reload
    echo "reload daemon success"
    echo "enable tproxy"
    systemctl enable tproxy
    echo "enable tproxy success"
    echo "start tproxy"
    systemctl start tproxy
    echo "start tproxy success"
    rm -rf "$current_folder"/tproxy
    echo "install tproxy success"
}

function uninstall() {
    echo "uninstall tproxy"
    echo "check tproxy installed"
    installed=$(systemctl list-unit-files | awk '{print $1}' | grep -w "tproxy.service")
    if [[ "$installed" == "tproxy.service" ]]
        then
            echo "tproxy installed"
            echo "check tproxy active"
            active=$(systemctl is-active tproxy)
            if [[ "$active" == "active" ]]
                then
                    echo "tproxy active"
                    
                    echo "stop tproxy"
                    systemctl stop tproxy
                    echo "stop tproxy success"
                fi
            echo "check tproxy enabled"
            enabled=$(systemctl is-enabled tproxy)
            if [[ "$enabled" == "enabled" ]]
                then
                    echo "tproxy enabled"

                    echo "disable tproxy"
                    systemctl disable tproxy
                    echo "disable tproxy success"
                fi
            echo "reload daemon"
            systemctl daemon-reload
            echo "reload daemon success"
            echo "uninstall service"
            rm -rf /usr/lib/systemd/system/tproxy.service
            echo "uninstall service success"
            echo "uninstall config"
            rm -rf /etc/tproxy
            echo "uninstall config success"
            echo "uninstall package"
            rm -rf /usr/bin/proxy
            rm -rf /usr/bin/socks
            rm -rf /usr/bin/tproxy
            echo "uninstall package success"
        fi
    echo "uninstall tproxy success"
}

case "$option" in
    "--install")
        uninstall
        install
    ;;
    "--uninstall")
        uninstall
    ;;
    *)
        echo "Usage: $0 --install|--uninstall"
        exit 1
    ;;
esac

# bash <(curl -s -L -H "Cache-Control: no-cache" -X "GET" "https://github.com/louisphihaihoang/tproxy/raw/main/tproxy.sh") "--install"
# bash <(curl -s -L -H "Cache-Control: no-cache" -X "GET" "https://github.com/louisphihaihoang/tproxy/raw/main/tproxy.sh") "--uninstall"
