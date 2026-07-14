FROM debian:bookworm

RUN apt update && apt install -y \
    wget \
    php \
    php-fpm \
    php-mysql \
    curl \
    default-mysql-client \
    netcat-openbsd \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/php-fpm && \
    chown -R www-data:www-data /var/log/php-fpm

RUN wget https://fr.wordpress.org/wordpress-6.8.2-fr_FR.tar.gz -P /var/www && \
    cd /var/www && \
    tar -xzf wordpress-6.8.2-fr_FR.tar.gz && \
    rm wordpress-6.8.2-fr_FR.tar.gz

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/wp_setup.sh /usr/local/bin/wp_setup.sh

RUN chmod +x /usr/local/bin/wp_setup.sh

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /run/php

RUN chown -R www-data:www-data /var/www/wordpress && \
    chmod -R 755 /var/www/wordpress

EXPOSE 9000

CMD ["/usr/local/bin/wp_setup.sh"]