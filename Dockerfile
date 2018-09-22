FROM tomcat:9.0

# To update, check https://bintray.com/jfrog/artifactory/jfrog-artifactory-oss-zip/view
ARG ARTIFACTORY_VERSION=6.3.3
ARG ARTIFACTORY_SHA256=ee242486476a94869fdeaf0cfc3233bed9a4566d603ce8078bcb02386e9463cb
ARG ARTIFACTORY_URL=https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip
ENV ARTIFACTORY_HOME=/artifactory \
    ARTIFACTORY_UID=997

# Disable Tomcat's manager application.
RUN rm -rf $CATALINA_HOME/webapps/*

RUN set -x && \
    curl -sSLo /tmp/artifactory.zip ${ARTIFACTORY_URL} && \
    echo "${ARTIFACTORY_SHA256}  /tmp/artifactory.zip" | sha256sum -c - && \
    unzip -j /tmp/artifactory.zip "artifactory-oss-${ARTIFACTORY_VERSION}/webapps/artifactory.war" -d ${CATALINA_HOME}/webapps && \
    mv ${CATALINA_HOME}/webapps/artifactory.war ${CATALINA_HOME}/webapps/ROOT.war && \
    rm /tmp/artifactory.zip && \
    mkdir ${ARTIFACTORY_HOME} && \
    chown -R ${ARTIFACTORY_UID}:0 ${CATALINA_HOME} ${ARTIFACTORY_HOME} && \
    chmod -R 0775 ${CATALINA_HOME} ${ARTIFACTORY_HOME}

VOLUME ${ARTIFACTORY_HOME}

USER 997
