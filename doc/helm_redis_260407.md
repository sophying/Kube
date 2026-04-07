### Creat  redis cluster 

-----------------------------------------

helm install redis bitnami/redis -n push --create-namespace --set architecture=replication --set sentinel.enabled=true

-----------------------------------------  
helm install 			# 새로운 Helm 차트를 Kubernetes 클러스터에 설치  
redis 				# Release 이름(K8s 리소스 접두사로 사용됨)  
bitnami/redis 			# 차트 경로 (Bitnami 저장소에 등록된 공식 Redis 차트를 사용)  
-n push 			# Namespace (모든 리소스를 격리하여 배치)  
--create-namespace  		# 만약 push 네임스페이스가 존재하지 않으면 자동으로 생성  
--set architecture=replication 	# Redis를 단순 'Standalone(단일 노드)'이 아닌 'Master-Replica(복제)' 구조로 구성  
--set sentinel.enabled=true	# Redis Sentinel 프로세스를 활성화

	\role1: 감시(Monitoring): Master 노드가 정상인지 실시간체크
	\role2: 자동 장애 조치(Failover): 만약 Master가 죽으면, Sentinel들이 투표를 통해 Replica 중 하나를 새로운 Master로 승격
	\role3: 알림(Notification): 클라이언트에게 현재 누가 Master인지 정보를 제공


### Creat redis yaml file 
mkdir ~/redis/heml  
cd ~/redis/heml  
vi redis-values.yaml

-----------------------------------------
	architecture: replication

	auth:
	  enabled: true #Redis 접속 시 반드시 비밀번호(AUTH)가 필요함을 의미
	  password: morpheus+redis
	  sentinel: false #Redis 노드 간 인증은 활성화되어 있으나, Sentinel 자체에 대한 인증(Sentinel 간 통신)은 비활성화
	
	replica:
	  replicaCount: 3   # Master 1 + Slave 2 = Sentinel 3
	
	sentinel:
	  enabled: true
	  quorum: 2
	
	master:
	  resources:
	    requests:
	      memory: 512Mi
	      cpu: 300m
	    limits:
	      memory: 1Gi
	      cpu: 1
-----------------------------------------

### 지정한 파일의 설정값으로 기존 Redis 배포본을 업데이트  
helm upgrade redis bitnami/redis -n push -f redis-values.yaml  
helm upgrade redis bitnami/redis -n push -f redis/helm/redis-values.yaml --force

