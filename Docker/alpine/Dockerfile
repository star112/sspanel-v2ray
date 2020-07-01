FROM ubuntu:latest as builder

RUN apt-get update
RUN apt-get install curl -y
COPY install-release.sh /tmp/go.sh
RUN chmod +x /tmp/go.sh
COPY v2ray-linux-64.zip /tmp/v2ray-linux-64.zip
RUN /tmp/go.sh --panelurl https://google.com --panelkey 55fUxDGFzH3n --nodeid 123456 \
    --downwithpanel 1 --mysqlhost https://bing.com --mysqldbname demo_dbname --mysqluser demo_user \
    --mysqlpasswd demo_dbpassword --mysqlport 3306 --speedtestrate 6 --paneltype 0 --usemysql 0 \
    --ldns 1.1.1.1 --local /tmp/v2ray-linux-64.zip

FROM alpine:latest

COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/
COPY config.json  /etc/v2ray/config.json
COPY runV2ray.sh  /usr/bin/v2ray/runV2ray.sh
RUN set -ex && \
    apk --no-cache add dcron ca-certificates openssl coreutils bind-tools curl socat && \
    update-ca-certificates && \
    apk add --update tzdata && \
    mkdir /var/log/v2ray/ && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray && \
    chmod +x /usr/bin/v2ray/runV2ray.sh && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && touch /var/log/cron/cron.log && mkdir -m 0644 -p /etc/cron.d


#Install

RUN  curl https://get.acme.sh | sh


RUN ln -s  /root/.acme.sh/acme.sh  /usr/local/bin/acme.sh && crontab -l | grep acme.sh | sed 's#> /dev/null##' | crontab -

ENV TZ=Asia/Shanghai
ENV PATH /usr/bin/v2ray:$PATH
VOLUME  /var/log/v2ray/ /root/.acme.sh/
WORKDIR /var/log/v2ray/

CMD sh /usr/bin/v2ray/runV2ray.sh
