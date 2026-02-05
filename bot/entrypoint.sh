#!/bin/bash

trap "" SIGPIPE

# 安装 napcat（所有路径改为绝对路径）
if [ ! -f "/app/napcat/napcat.mjs" ]; then
    unzip -q /app/NapCat.Shell.zip -d /app/NapCat.Shell
    cp -rf /app/NapCat.Shell/* /app/napcat/
    rm -rf /app/NapCat.Shell
fi
if [ ! -f "/app/napcat/config/napcat.json" ]; then
    unzip -q /app/NapCat.Shell.zip -d /app/NapCat.Shell
    cp -rf /app/NapCat.Shell/config/* /app/napcat/config/
    rm -rf /app/NapCat.Shell
fi

# 配置 WebUI Token（原路径已是绝对，保留）
CONFIG_PATH=/app/napcat/config/webui.json

if [ ! -f "${CONFIG_PATH}" ] && [ -n "${WEBUI_TOKEN}" ]; then
    echo "正在配置 WebUI Token..."
    cat > "${CONFIG_PATH}" << EOF
{
    "host": "0.0.0.0",
    "prefix": "${WEBUI_PREFIX}",
    "port": 6099,
    "token": "${WEBUI_TOKEN}",
    "loginRate": 3
}
EOF
fi

# 删除字符串两端的引号（无路径，无需修改）
remove_quotes() {
    local str="$1"
    local first_char="${str:0:1}"
    local last_char="${str: -1}"

    if [[ ($first_char == '"' && $last_char == '"') || ($first_char == "'" && $last_char == "'") ]]; then
        # 两端都是双引号
        if [[ $first_char == '"' ]]; then
            str="${str:1:-1}"
        # 两端都是单引号
        else
            str="${str:1:-1}"
        fi
    fi
    echo "$str"
}

# 复制模式配置文件（原路径已是绝对，保留）
if [ -n "${MODE}" ]; then
    cp /app/templates/$MODE.json /app/napcat/config/onebot11.json
fi

# 删除X1锁文件（原路径已是绝对，保留）
rm -rf "/tmp/.X1-lock"

# 设置用户/组ID并修改权限（原路径已是绝对，保留）
: ${NAPCAT_GID:=0}
: ${NAPCAT_UID:=0}
usermod -o -u ${NAPCAT_UID} napcat
groupmod -o -g ${NAPCAT_GID} napcat
usermod -g ${NAPCAT_GID} napcat
chown -R ${NAPCAT_UID}:${NAPCAT_GID} /app

# 启动Xvfb虚拟显示（无相对路径，无需修改）
gosu napcat Xvfb :1 -screen 0 1080x760x16 +extension GLX +render > /dev/null 2>&1 &
sleep 2

# 设置环境变量并启动QQ（cd改为绝对路径，执行命令路径均为绝对）
export FFMPEG_PATH=/usr/bin/ffmpeg
export DISPLAY=:1
cd /app/napcat
if [ -n "${ACCOUNT}" ]; then
    gosu napcat /opt/QQ/qq --no-sandbox -q $ACCOUNT
else
    gosu napcat /opt/QQ/qq --no-sandbox
fi
