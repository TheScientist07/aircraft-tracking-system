FROM tomcat:9-jdk17

COPY aircraft-tracking-system-1.0.war /usr/local/tomcat/webapps/

EXPOSE 8080