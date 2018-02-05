FROM alpine:3.7
MAINTAINER Jeremy Chang <jeremychang@qnap.com>

RUN apk update && \
    apk add --no-cache bash unzip curl wget git fakeroot ca-certificates tzdata \
            php5-fpm php5-json php5-zlib php5-xml php5-xmlreader php5-pdo php5-phar php5-openssl \
            php5-pdo_mysql php5-mysqli php5-sqlite3 php5-pdo_sqlite php5-gd php5-iconv php5-mcrypt php5-curl php5-ctype \
            openjdk7-jre nodejs python2 \
            make g++

RUN apk add -u musl

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
     ALPINE_GLIBC_PACKAGE_VERSION="2.26-r0" && \
     ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
     ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
     ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
   apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
   wget \
   "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
   -O "/etc/apk/keys/sgerrand.rsa.pub" && \
   wget \
   "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
   "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
   "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
   apk add --no-cache \
   "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
   "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
   "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
   \
   rm "/etc/apk/keys/sgerrand.rsa.pub" && \
   /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
   echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
   \
   apk del glibc-i18n && \
   \
   rm "/root/.wget-hsts" && \
   apk del .build-dependencies && \
   rm \
   "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
   "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
   "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

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
