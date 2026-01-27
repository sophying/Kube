FROM rockylinux/rockylinux:9.6-minimal

# 1) 필수 유틸
RUN set -eux; \
  microdnf -y update; \
  microdnf -y install findutils shadow-utils tar gzip unzip bash vim-minimal iproute net-tools gettext procps-ng iproute; \
  microdnf clean all

# 2) 사용자/기본 디렉터리
RUN set -eux; \
  groupadd -g 1000 kimhr || true; \
  useradd -u 1000 -g 1000 -m -d /home/kimhr -s /bin/bash kimhr || true; \
  install -d -m 0755 /usr/lib/jvm /home/kimhr/app; \
  chown -R 1000:1000 /home/kimhr; \
  mkdir -p /data/share; \
  chown -R 1000:1000 /data/share

# 3) JDK
#COPY ./infra/jdk1.8.0_202 /usr/lib/jvm/jdk1.8.0_202
ADD --chown=1000:1000 ./docker/jdk/jdk-8u202.tar.gz /usr/lib/jvm/
ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_202

ENV PATH="${JAVA_HOME}/bin:$PATH"
ENV CLASSPATH=".:./conf"
#ENV JAVA_OPTS="-server -Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m -Dreactor.netty.tcp.sshHandshakeTimeout=120000 -Djava.net.preferIPv4Stack=true"
ENV JAVA_OPTS="-server -Xms512m -Xmx512m -XX:MaxMetaspaceSize=256m \
-Djava.net.preferIPv4Stack=true \
-Dreactor.netty.tcp.sshHandshakeTimeout=120000 -Djava.net.preferIPv4Stack=true \
-Dfile.encoding=UTF-8"

WORKDIR /home/kimhr

# 앱TAR 
COPY --chown=1000:1000 ./app/provider-5.1.26.tar.gz /home/kimhr/app/

# 6) 권한/해제
RUN set -eux; \
  cd /home/kimhr/app ; \
  tar zxvf provider-5.1.26.tar.gz; \  
  rm -f provider-5.1.26.tar.gz; \
  mv 5.1.26-R6/* .
#  find /home/kimhr/app -type d -exec chmod 755 {} + ; \
#  find /home/kimhr/app -type f ! -name '*.sh' -exec chmod 644 '{}' + ; \
#  find /home/kimhr/app -type f -name '*.sh' -exec chmod 755 '{}' + 


COPY --chown=1000:1000 ./conf_app/conf/*.properties /home/kimhr/app/conf/
COPY --chown=1000:1000 ./conf_app/conf/license.* /home/kimhr/app/conf/
COPY --chown=1000:1000 ./conf_app/conf/*.xml /home/kimhr/app/conf/
COPY --chown=1000:1000 ./conf_app/conf/*.json /home/kimhr/app/conf/
COPY --chown=1000:1000 ./conf_app/conf/*.p8 /home/kimhr/app/conf/
COPY --chown=1000:1000 ./conf_app/start.sh /home/kimhr/app/

# 소유권 + 권한 정리
RUN set -eux; \
  chown -R 1000:1000 /home/kimhr; \
  find /home/kimhr/app -type d -exec chmod 755 {} + ; \
  find /home/kimhr/app -type f ! -name '*.sh' -exec chmod 644 '{}' + ; \
  find /home/kimhr/app -type f -name '*.sh' -exec chmod 755 '{}' + 

RUN sed -i 's/\r$//' /home/kimhr/app/start.sh

WORKDIR /home/kimhr/app
  

EXPOSE 10420 10421

USER 1000:1000
#CMD ["sh","-lc","${JAVA_HOME}/bin/java -jar /home/kimhr/app/target/provider-5.1.26-R6.jar"]

#CMD ["sh", "-c", "java $JAVA_OPTS -classpath \"$CLASSPATH\" -jar /home/kimhr/app/target/provider-5.1.26-R6.jar &"]
#CMD ["sh", "-c", "exec ${JAVA_HOME}/bin/java ${JAVA_OPTS} -classpath ${CLASSPATH} -jar /home/kimhr/app/target/provider-5.1.26-R6.jar"]
CMD ["sh", "-c", "exec ${JAVA_HOME}/bin/java ${JAVA_OPTS} -jar /home/kimhr/app/target/provider-5.1.26-R6.jar"]



