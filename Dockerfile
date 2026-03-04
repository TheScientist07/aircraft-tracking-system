FROM tomcat:9-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["sh", "-c", "sed -i 's/8080/${PORT}/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]