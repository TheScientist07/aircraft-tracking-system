FROM tomcat:9-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT 8080
EXPOSE 8080

CMD ["sh", "-c", "catalina.sh run"]