FROM alpine:3.3
MAINTAINER Jeremy Chang <jeremychang@qnap.com>

RUN apk update && \
    apk add --no-cache bash unzip curl wget git fakeroot ca-certificates tzdata \
            php-fpm php-json php-zlib php-xml php-xmlreader php-pdo php-phar php-openssl \
            php-pdo_mysql php-mysqli php-sqlite3 php-pdo_sqlite php-gd php-iconv php-mcrypt php-curl php-ctype \
            openjdk7-jre nodejs

RUN apk add -u musl

RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo "Asia/Taipei" >  /etc/timezone

RUN sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /etc/php/php.ini

RUN mkdir -p /bin
WORKDIR /bin

ADD files/composer /bin
RUN composer self-update

RUN wget https://phar.phpunit.de/phpunit.phar -O phpunit && \
    chmod +x phpunit

RUN composer global require "hirak/prestissimo"
RUN composer global require "squizlabs/php_codesniffer"

RUN npm i -g npm
RUN npm i -g yarn eslint babel-eslint gulp eslint-config-airbnb eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y

# Clear cache
RUN rm -rf ~/.npm && npm cache clear && \
    composer global clear-cache && \
    rm -rf /var/cache/apk/*

WORKDIR /

RUN ln -s $(which awk) /bin/awk

ADD files/entry.sh /
ENTRYPOINT ["/entry.sh"]
