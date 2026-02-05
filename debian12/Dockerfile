# 基础镜像：指定更明确的标签（避免latest漂移）
FROM ubuntu:22.04

# 构建参数：便于后续定制（如时区、依赖版本）
ARG TZ=Asia/Shanghai
ARG DEBIAN_FRONTEND=noninteractive

# 环境变量：精简且仅保留运行时必要的（构建参数转环境变量）
ENV TZ=${TZ} \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 安装依赖：
# 1. 拆分包列表为换行格式，便于阅读/维护
# 2. 添加 --no-install-recommends 减少无用依赖，减小镜像体积
# 3. 合并所有APT操作到单个RUN，减少镜像层
# 4. 更彻底的清理，包括apt缓存和临时文件
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libnss3 \
    libnotify4 \
    libsecret-1-0 \
    libgbm1 \
    xvfb \
    libasound2 \
    fonts-wqy-zenhei \
    gnutls-bin \
    libglib2.0-dev \
    libdbus-1-3 \
    libgtk-3-0 \
    libxss1 \
    libxtst6 \
    libatspi2.0-0 \
    libx11-xcb1 \
    ffmpeg \
    unzip \
    dbus-user-session \
    curl \
    jq \
    gosu \
    tzdata && \
    ; \
    # 时区配置（tzdata已通过ARG设置TZ，无需额外ln/echo）
    dpkg-reconfigure --frontend noninteractive tzdata; \
    # 彻底清理APT缓存和临时文件
    apt-get autoremove -y --purge; \
    apt-get clean; \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/doc/* \
        /usr/share/man/* \
        /usr/share/info/*;

WORKDIR /app

# 安装Linux QQ
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    curl -o linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/8015ff90/linuxqq_3.2.21-42086_${arch}.deb && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js && \
    sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json



ENTRYPOINT ["bash", "entrypoint.sh"]
