FROM alpine:3.7
MAINTAINER Jeremy Chang <jeremychang@qnap.com>

RUN apk update && \
    apk add --no-cache bash unzip curl wget git fakeroot ca-certificates tzdata \
            php5-fpm php5-json php5-zlib php5-xml php5-xmlreader php5-pdo php5-phar php5-openssl \
            php5-pdo_mysql php5-mysqli php5-sqlite3 php5-pdo_sqlite php5-gd php5-iconv php5-mcrypt php5-curl php5-ctype \
            openjdk7-jre nodejs python2

RUN apk add -u musl

RUN ln -s $(which awk) /bin/awk && \
    ln -s $(which php5) /usr/bin/php

RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo "Asia/Taipei" >  /etc/timezone

RUN sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /etc/php5/php.ini

RUN mkdir -p /bin
WORKDIR /bin

ADD files/composer /bin
RUN composer self-update

RUN wget https://phar.phpunit.de/phpunit.phar -O phpunit && \
    chmod +x phpunit

RUN composer global require "hirak/prestissimo"
RUN composer global require "squizlabs/php_codesniffer"

RUN npm i -g yarn eslint babel-eslint gulp eslint-config-airbnb eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y

# Clear cache
RUN rm -rf ~/.npm && npm cache clear --force && \
    composer global clear-cache && \
    rm -rf /var/cache/apk/*

WORKDIR /

ADD files/entry.sh /
ENTRYPOINT ["/entry.sh"]
