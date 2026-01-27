#!/bin/sh

set -e
set -x 

PROVIDER_HOME=$(cd "$(dirname "$0")" && pwd)
JAVA_HOME=/usr/lib/jvm/jdk1.8.0_202
TARGET_JAR=provider-5.1.26-R6.jar
CLASSPATH=.:./conf
JAVA_OPTS="$JAVA_OPTS -Dreactor.netty.tcp.sshHandshakeTimeout=120000 -Djava.net.preferIPv4Stack=true"
#JAVA_OPTS="$JAVA_OPTS -Dhttps.proxyHost=100.100.100.101 -Dhttps.proxyPort=3121"
#JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyUser=uracle -Dhttp.proxyPassword=uracle1234"

if [ ! -x "$JAVA_HOME/bin/java" ]; then
    echo "[ERROR] \$JAVA_HOME=$JAVA_HOME is not available!"
    exit 1
fi

if [ ! -r "$PROVIDER_HOME/target/$TARGET_JAR" ]; then
    echo "[ERROR] \$PROVIDER_HOME=$PROVIDER_HOME is not available!"
    exit 1
fi

cd $PROVIDER_HOME
echo "Starting $TARGET_JAR"
#nohup ${JAVA_HOME}/bin/java $JAVA_OPTS -classpath $CLASSPATH  -jar target/$TARGET_JAR &
nohup ${JAVA_HOME}/bin/java $JAVA_OPTS -classpath $CLASSPATH  -jar target/$TARGET_JAR 1>/dev/null 2>&1 &
