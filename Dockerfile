ARG     IMAGE=felixkazuyadev/openjava-base
ARG     TAG=latest
FROM $IMAGE:$TAG
MAINTAINER Christian Walonka <christian@walonka.de>
MAINTAINER Christian Walonka <cwalonka@it-economics.de>

ARG INSTALLDIR=/opt/atlassian/jira
ENV INSTALLDIR=${INSTALLDIR}
ARG JIRAVERSION=atlassian-jira-software-7.13.1-x64.bin
ARG DOWNLOADPATH=http://www.atlassian.com/software/jira/downloads/binary
ARG SERVERPORT=8080
ENV SERVERPORT=${SERVERPORT}
ARG HTTPSSERVERPORT=8443
ENV HTTPSSERVERPORT=${HTTPSSERVERPORT}
ARG AJPSERVERPORT=9080
ENV AJPSERVERPORT=${AJPSERVERPORT}

ENV REFRESHED_AT 2019-03-04
RUN wget $DOWNLOADPATH/$JIRAVERSION && \
chmod +x $JIRAVERSION && \
touch response.varfile && \
echo "rmiPort\$Long=8005">>response.varfile && \
echo "app.install.service$Boolean=true">>response.varfile && \
echo "existingInstallationDir=$INSTALLDIR">>response.varfile && \
echo "sys.confirmedUpdateInstallationString=false">>response.varfile && \
echo "sys.languageId=en">>response.varfile && \
echo "sys.installationDir=$INSTALLDIR">>response.varfile && \
echo "app.jiraHome=/var/atlassian/application-data/jira">>response.varfile && \
echo "executeLauncherAction$Boolean=true">>response.varfile && \
echo "httpPort\$Long=$SERVERPORT">>response.varfile && \
echo "portChoice=default">>response.varfile && \
./$JIRAVERSION -q -varfile response.varfile && \
ln -n /usr/share/java/mysql-connector-java.jar $INSTALLDIR/lib/mysql-connector-java.jar && \
rm $JIRAVERSION

COPY files/server.xml $INSTALLDIR/conf/server.xml
RUN mkdir -p  $INSTALLDIR/ext
COPY files/rewrite.config $INSTALLDIR/ext/rewrite.config

EXPOSE $SERVERPORT $HTTPSSERVERPORT $AJPSERVERPORT

COPY entrypoint /entrypoint
RUN chmod +x /entrypoint
CMD [ "/entrypoint" ]
