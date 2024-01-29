FROM tomcat:9-jdk11-openjdk

ARG SOLR_URL
ARG VIVO_DIR=/usr/local/vivo/home
ARG TDB_FILE_MODE=direct

ENV SOLR_URL=${SOLR_URL}
ENV JAVA_OPTS="${JAVA_OPTS} -Dtdb:fileMode=$TDB_FILE_MODE"

RUN mkdir /usr/local/vivo
RUN mkdir /usr/local/vivo/home

# User modifications per CU Boulder OIT to run as vivoweb user
RUN addgroup --gid 935045 vivoweb && \
adduser --uid 935045 --gid 935045 --gecos 'vivoweb app user' \
--disabled-password --disabled-login vivoweb 
RUN chown -R 935045:935045 /usr/local/tomcat && chown -R 935045:935045 /usr/local/vivo && chown -R 935045:935045 /usr/local/vivo/home

USER vivoweb
# End VIVO user modification

COPY ./installer/home/target/vivo /vivo-home
COPY ./installer/webapp/target/vivo.war /usr/local/tomcat/webapps/ROOT.war

COPY start.sh /start.sh

EXPOSE 8080

CMD ["/bin/bash", "/start.sh"]
