FROM debian:buster

MAINTAINER ATNOS <bruno@atnos.com>

LABEL Description="Chouette IEV" \
      Usage="docker run -it --name chouette-iev --link docker-chouette_chouette-postgres_1:chouette-postgres -p 9991:9990 -p 8081:8080 -d chouette-iev" \
      BuildUsage="docker build -t chouette-iev ." \
      License="CECILL/B" \
      Version="3.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update ; apt-get -y install wget vim net-tools nmap curl git maven apt-utils


#--- Java
#RUN echo "deb http://http.debian.net/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list
RUN echo "deb http://deb.debian.org/debian/ sid main" > /etc/apt/sources.list.d/debian-sid.list
RUN apt-get update
RUN apt-get install -y -t "sid" openjdk-8-jre-headless openjdk-8-jdk
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 1112

#--- Wildfly

ENV WILDFLY_HOME=/opt/wildfly
ENV WILDFLY_VERSION=9.0.2.Final

RUN mkdir /install

RUN cd /install && wget -q http://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.tar.gz
RUN	cd /opt ; tar xzf /install/wildfly-${WILDFLY_VERSION}.tar.gz ; ln -s wildfly-${WILDFLY_VERSION} wildfly
RUN cd /install && wget -q https://repo1.maven.org/maven2/org/postgresql/postgresql/9.4-1206-jdbc41/postgresql-9.4-1206-jdbc41.jar && \
	wget -q https://repo1.maven.org/maven2/net/postgis/postgis-jdbc/2.2.1/postgis-jdbc-2.2.1.jar && \
	wget -q http://www.hibernatespatial.org/repository/org/hibernate/hibernate-spatial/4.3/hibernate-spatial-4.3.jar && \
	wget -q https://repo1.maven.org/maven2/com/vividsolutions/jts/1.13/jts-1.13.jar && \
	wget -q https://repo1.maven.org/maven2/org/hibernate/hibernate-core/4.3.11.Final/hibernate-core-4.3.11.Final.jar && \
	wget -q https://repo1.maven.org/maven2/org/hibernate/hibernate-envers/4.3.11.Final/hibernate-envers-4.3.11.Final.jar && \
	wget -q https://repo1.maven.org/maven2/org/hibernate/javax/persistence/hibernate-jpa-2.1-api/1.0.0.Final/hibernate-jpa-2.1-api-1.0.0.Final.jar && \
	wget -q https://repo1.maven.org/maven2/org/hibernate/hibernate-entitymanager/4.3.11.Final/hibernate-entitymanager-4.3.11.Final.jar && \
	wget -q https://repo1.maven.org/maven2/org/hibernate/hibernate-infinispan/4.3.11.Final/hibernate-infinispan-4.3.11.Final.jar


RUN mkdir -p $WILDFLY_HOME/modules/org/postgres/main

COPY config2/*.xml /install/
RUN cd /install && cp post*.jar $WILDFLY_HOME/modules/org/postgres/main && \
 cp module_postgres.xml $WILDFLY_HOME/modules/org/postgres/main/module.xml && \
 rm $WILDFLY_HOME/modules/system/layers/base/org/hibernate/main/hibernate*4.3.10.Final.jar && \
 cp hibernate-core*.jar hibernate-envers*.jar hibernate-entitymanager*.jar hibernate-jpa-2.1-api-1.0.0.Final.jar $WILDFLY_HOME/modules/system/layers/base/org/hibernate/main && \
 cp hibernate-spatial-4.3.jar jts-1.13.jar $WILDFLY_HOME/modules/system/layers/base/org/hibernate/main && \
 cp -f module_hibernate.xml $WILDFLY_HOME/modules/system/layers/base/org/hibernate/main/module.xml && \
 rm $WILDFLY_HOME/modules/system/layers/base/org/hibernate/infinispan/main/hibernate*4.3.10.Final.jar && \
 cp hibernate-infinispan-4.3.11.Final.jar $WILDFLY_HOME/modules/system/layers/base/org/hibernate/infinispan/main/ && \
 cp -f module_infinispan.xml $WILDFLY_HOME/modules/system/layers/base/org/hibernate/infinispan/main/module.xml

RUN /opt/wildfly/bin/add-user.sh admin admin --silent

RUN mkdir /update
VOLUME /update

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
ENV LANG fr_FR.UTF-8

# RUN cd /tmp && git clone https://github.com/atnos/chouette.git
# RUN cd /tmp/chouette && git checkout V3_4

EXPOSE 8080 9990

COPY config/chouette.ear /tmp/
COPY config/standalone-full.xml /tmp/
COPY config/wildfly-datasources.cli /tmp/
COPY config/docker-entrypoint.sh /
VOLUME ["/opt/jboss/referentials"]
ENTRYPOINT ["/docker-entrypoint.sh"]
# CMD ["/bin/bash"]
CMD [ "/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
