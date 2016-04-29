FROM alpine:3.3
MAINTAINER Jeremy Chang <jeremychang@qnap.com>

RUN apk update && \
    apk add --no-cache bash unzip curl wget git fakeroot ca-certificates tzdata \
            php-fpm php-json php-zlib php-xml php-xmlreader php-pdo php-phar php-openssl \
            php-pdo_mysql php-mysqli php-gd php-iconv php-mcrypt php-curl \
            openjdk7-jre nodejs

RUN apk add -u musl

RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo "Asia/Taipei" >  /etc/timezone

RUN sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /etc/php/php.ini

RUN mkdir -p /bin
WORKDIR /bin

RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar composer

RUN wget https://phar.phpunit.de/phpunit.phar -O phpunit && \
    chmod +x phpunit

RUN composer global require "squizlabs/php_codesniffer"

RUN npm i -g npm
RUN npm i -g eslint babel-eslint gulp eslint-config-airbnb eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y

# Clear cache
RUN rm -rf ~/.npm && npm cache clear && \
    composer global clear-cache && \
    rm -rf /var/cache/apk/*

WORKDIR /

RUN ln -s $(which awk) /bin/awk

ADD files/entry.sh /
ENTRYPOINT ["/entry.sh"]
