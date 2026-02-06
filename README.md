## minikube 
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
---------------------------------------
## Windows hosts 파일 수정 필수 
- \<kube host Server IP> dev.madm.sophy
- \<kube host Server IP> dev.madp.sophy
- \<kube host Server IP> dev.upmc.sophy

### WEB Browser -> kube host Server (linux VM) -> kube cluster Container
---------------------------------------
## | kubectl get pod -n push
<img width="620" height="208" alt="image" src="https://github.com/user-attachments/assets/906045d1-20c2-4e60-b5f5-2aa899e2315c" />

## | kubectl get svc
<img width="833" height="144" alt="image" src="https://github.com/user-attachments/assets/71548147-ac2f-493f-8f0f-59d9503cf60b" />

## | kubectl get deploy
<img width="549" height="117" alt="image" src="https://github.com/user-attachments/assets/3ab5309d-e29a-409a-8e2b-a2cb83ee9ea8" />

## | kubectl get ingress
<img width="549" height="86" alt="image" src="https://github.com/user-attachments/assets/e4fd33b4-54b0-49cd-81e2-d83674487c70" />

--------------------------------------

## | 접속 확인
<img width="1613" height="535" alt="image" src="https://github.com/user-attachments/assets/3a107adb-9620-4939-b6ec-44753256e98c" />
<img width="1310" height="631" alt="image" src="https://github.com/user-attachments/assets/9f074185-787f-4d1d-beab-ab05fc4307f1" />
<img width="1455" height="340" alt="image" src="https://github.com/user-attachments/assets/7b776cc5-d50b-4769-9388-fbcad80a12e8" />


