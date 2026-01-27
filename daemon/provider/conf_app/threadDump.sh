#!/bin/sh

while read line
do
if echo $line | grep -q -w "JAVA_HOME"
then
echo "line value ==>" $line
javaHomeStr=$line
break
fi
done < start.sh

setJavaHome=`echo $javaHomeStr | cut -d'=' -f2`
echo "javaHomeInfo:"$setJavaHome

##javaHomeStr="JAVA_HOME=/home/mium2/jdk1.7.0_80"
JAVA_HOME=$setJavaHome

rm -rf ThreadDump.txt
PS_PRINT=`ps -ef | grep "provider-5.1.26-R6.jar" | grep -v grep`
echo "PS INFO :" $PS_PRINT
set -- $PS_PRINT
echo "PROVIDEER_PID:"$2
PROVIDER_PID=$2
echo "PID:"$PROVIDER_PID
${JAVA_HOME}/bin/jcmd ${PROVIDER_PID} Thread.print >> ThreadDump.txt
echo "SUCCESS"
