# Upstream's MySQL image (app/docker/mysql/Dockerfile) with these changes. coreSchema.sql and
# moduleSchemas.sql are unchanged copies of app/src/main/resources/database/ (each build folder is
# its own Docker context); the DELIMITER edits upstream's Maven `docker` profile makes when it
# copies them are made here. The challenge database users are created for any host ('%')
# instead of the Tomcat container's reverse-DNS name, which upstream derives from its fixed
# container and network names. mysql:5.5 is pinned to 5.5.62 and the root password of app/.env
# is baked in.
FROM mysql:5.5.62

ENV MYSQL_ROOT_PASSWORD=CowSaysMoo

COPY coreSchema.sql /docker-entrypoint-initdb.d/coreSchema.sql
COPY moduleSchemas.sql /docker-entrypoint-initdb.d/moduleSchemas.sql

RUN cd /docker-entrypoint-initdb.d && \
    sed -i 's/-- DELIMITER \$\$/DELIMITER $$/g; s/-- \$\$/$$/g; s/-- DELIMITER ;/DELIMITER ;/g' coreSchema.sql moduleSchemas.sql && \
    sed -i "s/@'localhost'/@'%'/g" moduleSchemas.sql
# For 3.1 Closing NoSQL level
RUN sed -i '/d7eaeaa1cc4f218abd86d14eefa183a0f8eb6298/d' /docker-entrypoint-initdb.d/coreSchema.sql

RUN mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'datadir = /var/lib/mysql'; \
		echo '!includedir /etc/mysql/conf.d/'; \
	} > /etc/mysql/my.cnf

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
