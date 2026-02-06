### minikube 
- 리버스 proxy 설정 필수
  apache/conf/extra/httpd-vhosts.conf
-----------------------------------------
  
    <VirtualHost *:80>
    
      ServerName dev.madm.sophy

      ProxyPreserveHost On
      ProxyRequests Off

      # Ingress로 전달
      ProxyPass / http://192.168.76.2:30080/
      ProxyPassReverse / http://192.168.76.2:30080/

      ErrorLog logs/madm_error.log
      CustomLog logs/madm_access.log combined

    </VirtualHost>

    <VirtualHost *:80>
    
      ServerName dev.madp.sophy

      ProxyPreserveHost On

      ProxyPass / http://192.168.76.2:31080/
      ProxyPassReverse / http://192.168.76.2:31080/

      ErrorLog logs/madp_error.log
      CustomLog logs/madp_access.log combined
    </VirtualHost>


    <VirtualHost *:80>
   
      ServerName dev.upmc.sophy

      ProxyPreserveHost On

      ProxyPass / http://192.168.76.2:32080/
      ProxyPassReverse / http://192.168.76.2:32080/

      ErrorLog logs/upmc_error.log
      CustomLog logs/upmc_access.log combined
    </VirtualHost>

