FROM openjdk:7
EXPOSE 7199
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN chmod 400 /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/management/jmxremote.password
RUN javac Main.java
CMD ["java", "-Dcom.sun.management.jmxremote", "-Dcom.sun.management.jmxremote.port=7199", "-Dcom.sun.management.jmxremote.local.only=false", "-Dcom.sun.management.jmxremote.ssl=false", "-Dcom.sun.management.jmxremote.authenticate=false", "Main"]
