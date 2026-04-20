## affinity issue  
  
----------------------------------

	#      affinity: # pod 배치 전략
	#        nodeAffinity: # 특정 노드(prv-node-1,prv-node-2)에서만 파드가 기동/고정 IP&경로가 필요할 때 사용
	#          requiredDuringSchedulingIgnoredDuringExecution:  # 반드시 지켜야 하는 "Hard" 규칙
	#            nodeSelectorTerms:
	#            - matchExpressions:
	#              - key: kubernetes.io/hostname
	#                operator: In
	#                values:
	#                  - prv-node-1
	#                  - prv-node-2
	#        podAntiAffinity: # 동일한 app: provider 레이블을 가진 파드끼리 같은 노드에 있지 않게/ 고가용성(HA)을 위해 파드를 여러 >노드로 분산
	#          requiredDuringSchedulingIgnoredDuringExecution:
	#          - labelSelector:
	#              matchExpressions:
	#              - key: app
	#                operator: In
	#                values:
	#                - provider
	#            topologyKey: kubernetes.io/hostname # 분산의 기준을 노드(hostname) 단위로 설정
-----------------------------------

#### Error 

----------------------------------
Events:
  Type     Reason            Age                 From               Message
  ----     ------            ----                ----               -------
  Warning  FailedScheduling  109s (x4 over 17m)  default-scheduler  0/1 nodes are available: 1 node(s) didn't match Pemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling..
----------------------------------

####  
  
---------------------------------
1. 왜 실행이 안 됐던 걸까요? (환경의 차이)
회사에서 준 예시의 의도와 현재 환경의 충돌 원인은 다음과 같습니다.

의도 (운영 환경): "푸시 서버는 중요하니까 반드시 node-1, node-2라는 고성능 서버에만 띄우고(nodeAffinity), 두 대가 한 서버에 몰리면 위험하니 서로 다른 서버에 찢어서 배치해(podAntiAffinity)!"

현실 (질문자님 환경): 현재 클러스터에는 노드가 단 1개뿐입니다. 심지어 그 노드의 이름도 node-1이 아닐 확률이 높습니다.

*결과적으로:*

NodeAffinity 에러: "나는 node-1 아니면 안 가!"라고 Pod이 버티는데, 정작 클러스터에는 그 이름의 노드가 없으니 Pending에 빠진 것입니다.

PodAntiAffinity 에러: 설령 노드 이름을 맞췄더라도, "우리는 같은 노드에 절대 같이 못 있어!"라는 강제 규칙(required...) 때문에 provider-0이 자리를 잡고 나면 provider-1은 갈 곳이 없어서 영원히 Pending 상태가 됩니다.  
----------------------------------

