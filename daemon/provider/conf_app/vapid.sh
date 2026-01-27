#!/bin/bash
echo "Generate VAPID."
JAVA_HOME=/usr
CLASSPATH=.:./conf:./target/provider-5.1.26-R6.jar
${JAVA_HOME}/bin/java -Djava.security.egd=file:/dev/./urandom -classpath $CLASSPATH com.mium.server.wpns.VAPID
