FROM xkmxz2503/napcat-mcsm-linux:1

RUN useradd --no-log-init -d /app napcat

WORKDIR /app
COPY /bot/entrypoint.sh /opt/app/
RUN chmod +x /opt/app/*
# 安装Linux QQ
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    QQ_URL="https://qqdl.gtimg.cn/qqfile/QQNTV2/9.9.36/release/9ee04bef/QQ_3.2.34_260924_${arch}_01.deb" && \
    curl -L --retry 3 -o linuxqq.deb \
         -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
         -H "Referer: https://im.qq.com/linuxqq/index.shtml" \
         -H "Accept: */*" \
         "$QQ_URL" && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js && \
    sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json



ENTRYPOINT ["/bin/bash", "-c", "cd /opt/app && exec bash entrypoint.sh"]
