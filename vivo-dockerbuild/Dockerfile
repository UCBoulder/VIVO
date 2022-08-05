FROM tomcat:9-jdk11-openjdk

ARG SOLR_URL=http://localhost:8983/solr/vivocore
ARG VIVO_DIR=/usr/local/vivo/home
ARG TDB_FILE_MODE=direct

ENV SOLR_URL=${SOLR_URL}
ENV JAVA_OPTS="${JAVA_OPTS} -Dtdb:fileMode=$TDB_FILE_MODE"

RUN mkdir /usr/local/vivo
RUN mkdir /usr/local/vivo/home

# User modifications per CU Boulder OIT to run as vivo user
RUN addgroup --gid 299879 vivo && \
adduser --uid 299879 --gid 299879 --gecos 'vivo app user' \
--disabled-password --disabled-login vivo 
RUN chown -R 299879:299879 /usr/local/tomcat && chown -R 299879:299879 /usr/local/vivo && chown -R 299879:299879 /usr/local/vivo/home

USER vivo
# End VIVO user modification

COPY ./installer/home/target/vivo /vivo-home
COPY ./installer/webapp/target/vivo.war /usr/local/tomcat/webapps/ROOT.war

COPY start.sh /start.sh

EXPOSE 8080

CMD ["/bin/bash", "/start.sh"]
