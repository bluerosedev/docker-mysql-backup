FROM alpine:3.7

ENV AWS_CLI_VERSION=1.14.5
ENV S3_CMD_VERSION=2.0.1
ENV SUPERVISOR_VERSION=3.3.1
ENV DOCKERIZE_VERSION v0.6.1

RUN apk add --no-cache \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        dcron \
        supervisor \
        mysql-client \
    && pip install --upgrade awscli==${AWS_CLI_VERSION} s3cmd==${S3_CMD_VERSION} python-magic \
    && apk -v --purge del py-pip \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm /var/cache/apk/* \
    && mkdir -p /var/log/supervisor

ADD ./usr/sbin/* /usr/sbin/
ADD ./etc/cron.d/* /etc/cron.d/
ADD ./etc/supervisor.d/ /etc/supervisor.d/
ADD ./root/.s3cfg.tmpl /root/.s3cfg.tmpl

CMD dockerize --template /root/.s3cfg.tmpl:/root/.s3cfg supervisord -n --configuration /etc/supervisord.conf