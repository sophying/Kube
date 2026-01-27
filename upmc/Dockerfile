FROM rockylinux/rockylinux:9.6-minimal

# 1) 필수 유틸
RUN set -eux; \
  microdnf -y update; \
  microdnf -y install findutils shadow-utils tar gzip unzip bash vim-minimal iproute net-tools; \
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
ADD ./docker/jdk/jdk-8u202.tar.gz /usr/lib/jvm/
ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_202

WORKDIR /home/kimhr

COPY ./docker/tomcat/tomcat-9.0.94.tar.gz /tmp/

RUN set -eux; \
  tar -xzf /tmp/tomcat-9.0.94.tar.gz -C /home/kimhr && ls -l /home/kimhr; \
  mv /home/kimhr/apache-tomcat-9.0.94 /home/kimhr/tomcat && ls -l /home/kimhr; \
  chown -R 1000:1000 /home/kimhr/tomcat; \
  rm -rf /tmp/tomcat-9.0.94.tar.gz

# 4) Tomcat을 한 경로로 고정
ENV CATALINA_HOME=/home/kimhr/tomcat
ENV PATH="${JAVA_HOME}/bin:${CATALINA_HOME}/bin:$PATH"

#WORKDIR /home/kimhr

# 5) Tomcat "내용물"을 CATALINA_HOME으로 복사 (경로 혼동 방지: 소스 끝에 /, 대상 끝에 /)
#COPY --chown=1000:1000 ./tomcat/tomcat-9.0.94/ ${CATALINA_HOME}/

# conf 덮어쓰기
COPY ./docker/tomcat/conf/*.xml ${CATALINA_HOME}/conf/
#COPY ./docker/tomcat/bin/*.sh ${CATALINA_HOME}/bin/

# 소유권 + 권한 정리
RUN set -eux; \ 
  chown -R 1000:1000 $CATALINA_HOME/conf \
  && chmod 640 $CATALINA_HOME/conf/*.xml

# 앱 WAR
COPY --chown=1000:1000 ./app/upmc-5.1.45-R6.war /home/kimhr/app/

# 6) 권한/해제
RUN set -eux; \
  find "${CATALINA_HOME}/bin" -type f -name '*.sh' -exec chmod 755 '{}' + ; \
  cd /home/kimhr/app ; \
  ls -l /usr/lib/jvm; \
  ${JAVA_HOME}/bin/jar -xf upmc-5.1.45-R6.war; \  
  #jar -xf madm-JDK18-4.5.23.war ; \
  rm -f upmc-5.1.45-R6.war 
#  find /home/kimhr -type d -exec chmod 755 {} + ; \
#  find /home/kimhr -type f ! -name '*.sh' -exec chmod 644 '{}' + ; \
#  find /home/kimhr -type f -name '*.sh' -exec chmod 755 '{}' + 


COPY --chown=1000:1000 ./conf_app/WEB-INF/classes/logback.xml /home/kimhr/app/WEB-INF/classes/
COPY --chown=1000:1000 ./conf_app/WEB-INF/classes/config/*.properties /home/kimhr/app/WEB-INF/classes/config/
COPY --chown=1000:1000 ./conf_app/WEB-INF/classes/config/license.* /home/kimhr/app/WEB-INF/classes/config/
COPY --chown=1000:1000 ./conf_app/WEB-INF/spring/application-context.xml /home/kimhr/app/WEB-INF/spring/

RUN set -eux; \
  find /home/kimhr -type d -exec chmod 755 {} + ; \
  find /home/kimhr -type f ! -name '*.sh' -exec chmod 644 '{}' + ; \
  find /home/kimhr -type f -name '*.sh' -exec chmod 755 '{}' +


# 소유권 + 권한 정리
RUN set -eux; \
  chown -R 1000:1000 /home/kimhr/app 


USER 1000:1000
EXPOSE 8080
CMD ["sh","-lc","${CATALINA_HOME}/bin/catalina.sh run"]
