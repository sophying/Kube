## YAML 파일을 직접 수정하지 않고, 원본 파일을 사용하여 Secret을 즉시 만듦


----------------------------------
### 1. kubectl 명령으로 secret 생성

- 이 방식은 내부적으로 알아서 Base64 인코딩을 수행하므로 사용자가 직접 cat | base64를 할 필요가 없음
- yaml 파일 자체가 필요 없음 
 
	kubectl create secret generic push-license \
	--from-file=license.key=/kimhr/work/prd-root/daemon/provider/conf_app/conf/license.key \
	--from-file=license.cer=/kimhr/work/prd-root/daemon/provider/conf_app/conf/license.cer
----------------------------------

### 2. 확인 
 
	kubectl get secret
----------------------------------

### 3. 수정방법  
  
	1) edit  
	
	kubectl edit secret push-license  


	2) 명령어로 덮어쓰기 (--dry-run & replacei)  
	
	kubectl create secret generic push-license \
        --from-file=license.key=[새로운_경로]/license.key \
        --from-file=license.cer=[새로운_경로]/license.cer \
        --dry-run=client -o yaml | kubectl apply -f - 
	
	3) YAML 파일로 추출하여 영구 관리 (권장)
	
	kubectl get secret push-license -o yaml > push-license.yaml
	  
	- 적용
	kubectl apply -f push-license.yaml 
------------------------------------

### 4. 주의사항: 수정 후 Pod 반영  

- Secret의 내용(라이선스 파일 내용 등)을 수정하더라도, 이를 사용하는 StatefulSet의 Pod들이 자동으로 새로운 내용을 인식하지 못할 수 있음  

	kubectl rollout restart statefulset provider
  
------------------------------------

## YAML  파일을 직접 수정할 경우
- base64 incoding 

	cat license.key | base64
	cat license.cer | base64

- decoding 
	
	echo "incondig string" | base64 -d
	
	- 파일로 저장된 내용 디코딩하기
	base64 -d 파일명 > 원본파일명

- Kubernetes(kubectl) 활용

	kubectl get secret push-license -o jsonpath='{.data.license\.key}' | base64 -d
