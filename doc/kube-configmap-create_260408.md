
#### provider config


	kubectl create configmap provider-config \
	--from-file=config.properties=/kimhr/work/prd-root/daemon/provider/conf_app/conf/config.properties
	--from-file=logback.xml=/kimhr/work/prd-root/daemon/provider/conf_app/conf/logback.xml



