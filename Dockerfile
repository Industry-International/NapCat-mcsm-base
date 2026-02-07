FROM xkmxz2503/napcat-mcsm-linux:1

RUN useradd --no-log-init -d /app napcat

WORKDIR /app
COPY /bot/entrypoint.sh /opt/app/
RUN chmod +x /opt/app/*
# 安装Linux QQ
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    curl -o linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/8015ff90/linuxqq_3.2.21-44343_${arch}.deb && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js && \
    sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json



ENTRYPOINT ["/bin/bash", "-c", "cd /opt/app && exec bash entrypoint.sh"]
