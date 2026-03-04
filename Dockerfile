FROM tomcat:9-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]