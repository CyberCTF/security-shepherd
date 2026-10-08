# Upstream's Dockerfile (app/Dockerfile) with these changes. Upstream builds the WAR and the TLS
# keystore on the host first (`mvn -Pdocker clean install -DskipTests`, see app/README.md); here
# a first stage runs that same Maven build, and the second stage copies the WAR and keystore from
# it. tomcat:alpine is pinned to the release it pointed to (8.5.41-jre8-alpine). The build
# arguments upstream's docker-compose.yml passes from app/.env are defaults here, with the database
# host set to the `db` machine and the HTTPS redirect port set to 8443 (the port the container
# serves, published as is, instead of 443 on the host).
FROM maven:3.6.3-jdk-8 AS war
COPY app/ /shepherd
WORKDIR /shepherd
RUN mvn -B -q -Pdocker clean install -DskipTests

FROM tomcat:8.5.41-jre8-alpine

ARG DB_DRIVER=org.gjt.mm.mysql.Driver
ARG DB_SCHEMA=core
ARG PROPS_DIR=/usr/local/tomcat/conf/database.properties

ARG MYSQL_USER=root
ARG MYSQL_PASS=CowSaysMoo
ARG MYSQL_URI=jdbc:mysql://db:3306

ARG TLS_KEYSTORE_FILE=shepherdKeystore.p12
ARG TLS_KEYSTORE_PASS=CowSaysMoo
ARG ALIAS=tomcat
ARG HTTPS_PORT=8443

RUN printf "databaseConnectionURL=$MYSQL_URI/\nDriverType=$DB_DRIVER\ndatabaseSchema=$DB_SCHEMA\ndatabaseUsername=$MYSQL_USER\ndatabasePassword=$MYSQL_PASS\n" >> $PROPS_DIR

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=war /shepherd/target/owaspSecurityShepherd.war /usr/local/tomcat/webapps/ROOT.war
COPY --from=war /shepherd/target/$TLS_KEYSTORE_FILE /usr/local/tomcat/conf/$TLS_KEYSTORE_FILE

COPY app/docker/tomcat/serverxml.patch /usr/local/tomcat/conf/serverxml.patch
RUN sed -i 's/keystoreFile="conf\/TLS_KEYSTORE_FILE" keystorePass="TLS_KEYSTORE_PASS" keyAlias="ALIAS"\/>/keystoreFile="conf\/'"$TLS_KEYSTORE_FILE"'" keystorePass="'"$TLS_KEYSTORE_PASS"'" keyAlias="'"$ALIAS"'"\/>/g' /usr/local/tomcat/conf/serverxml.patch &&\
    sed -i 's/redirectPort="HTTPS_PORT" \/>/redirectPort="'"$HTTPS_PORT"'" \/>/g' /usr/local/tomcat/conf/serverxml.patch &&\
    patch /usr/local/tomcat/conf/server.xml /usr/local/tomcat/conf/serverxml.patch

COPY app/docker/tomcat/webxml.patch /usr/local/tomcat/conf/webxml.patch
RUN patch /usr/local/tomcat/conf/web.xml /usr/local/tomcat/conf/webxml.patch

EXPOSE 8080 8443
CMD ["catalina.sh", "run"]
