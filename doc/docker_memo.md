### 모든 이미지의 레이어들을 하나의 파일로 통합 tatal 3.1GB
  
docker save kimhr/madm:1.0 kimhr/upmc:1.0 kimhr/madp:1.0 kimhr/provider:5.1.26 > all_images.tar

### docker images load 

- 도커 엔진에 넣을 때  
  
docker load < all_images.tar

-----------------------------
	태그(Tag) 유지: docker load를 하면 이미지 이름뿐만 아니라 1.0, 5.1.26 같은 태그까지 완벽하게 복구됩니다.  
	기존 이미지 덮어쓰기: 만약 서버에 이미 같은 이름과 태그의 이미지가 있다면, load 과정에서 최신 내용으로 덮어씌워집니다.  
	용량 확인: docker load를 실행하면 3.1GB짜리 파일이 풀리면서 서버의 /var/lib/docker 디렉토리 용량을 그만큼(혹은 그 이상) 차지하게 됩니다. 실행 전 디스크 여유 공간을 꼭 확인하세요!
-----------------------------


