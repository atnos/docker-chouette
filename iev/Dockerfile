FROM jboss/wildfly:9.0.2.Final
MAINTAINER Cityway

LABEL Description="Chouette IEV" \
      Usage="docker run -it --name chouette-iev --link chouette-postgres:chouette-postgres -p 9991:9990 -p 8081:8080 -d chouette-iev" \
      BuildUsage="docker build -t chouette-iev ." \
      License="CECILL/B" \
      Version="3.0"

USER root

RUN yum -y install wget nmap

USER jboss

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

###-- Update hibernate module
# wget -q http://www.hibernatespatial.org/repository/org/hibernate/hibernate-spatial/4.3/hibernate-spatial-4.3.jar -P /tmp && \
RUN wget -q http://maven.chouette.mobi/org/hibernate/hibernate-spatial/4.3/hibernate-spatial-4.3.jar -O /tmp/hibernate-spatial.jar && \
    wget -q http://central.maven.org/maven2/com/vividsolutions/jts/1.13/jts-1.13.jar -P /tmp && \
    cp /tmp/hibernate-spatial.jar /tmp/jts-*.jar /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/ && \
    cp /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml.sav && \
    sed -i '/<resources>/a\\t<resource-root path="hibernate-spatial.jar"/>'  /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    sed -i '/<resources>/a\\t<resource-root path="jts-1.13.jar"/>'  /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    sed -i '/<dependencies>/a\\t<module name="org.postgres"/>'  /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml

RUN wget -q http://central.maven.org/maven2/org/postgresql/postgresql/9.4-1206-jdbc42/postgresql-9.4-1206-jdbc42.jar -O /tmp/postgresql.jar && \
    wget -q http://central.maven.org/maven2/net/postgis/postgis-jdbc/2.1.7.2/postgis-jdbc-2.1.7.2.jar -O /tmp/postgis.jar && \
    wget -q http://maven.chouette.mobi/mobi/chouette/chouette_iev/maven-metadata.xml && \
    CHOUETTE_LATEST_VERSION=`sed -n 's:.*<release>\(.*\)</release>.*:\1:p' maven-metadata.xml` && \
    wget -q http://maven.chouette.mobi/mobi/chouette/chouette_iev/${CHOUETTE_LATEST_VERSION}/chouette_iev-${CHOUETTE_LATEST_VERSION}.ear && \
    cp chouette_iev-${CHOUETTE_LATEST_VERSION}.ear /tmp/chouette.ear

EXPOSE 8080 9990

COPY config/wildfly-datasources.cli /tmp/
COPY config/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
