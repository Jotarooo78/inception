FROM debian:bookworm

RUN apt update -y && apt-get install mariadb-server -y

RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    chmod 777 /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf

COPY tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh

RUN chmod +x /usr/local/bin/mariadb_setup.sh

EXPOSE 3306

CMD ["/usr/local/bin/mariadb_setup.sh"]