## Install
cd redis
mkdir  helm

### redis/helm
cd redis/helm/
wget https://get.helm.sh/helm-v4.1.0-linux-arm64.tar.gz
tar -zxvf helm-v4.1.0-linux-arm64.tar.gz
chmod +x  helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

### install completed
ls -l /usr/local/bin/helm
helm version
which helm

vi ~/.config/helm/repositories.yaml
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm repo list

helm install redis bitnami/redis -n push --create-namespace --set architecture=replication --set sentinel.enabled=true

###  add config (yaml) 
cd redis/heml/
vi redis-values.yaml
helm upgrade redis bitnami/redis -n push -f redis-values.yaml
helm upgrade redis bitnami/redis -n push -f redis/helm/redis-values.yaml --force

### uninstall 
helm uninstall redis -n push

### show info 
helm show values bitnami/redis

### Helm values 확인
helm get values redis -n <namespace>
helm get values redis -n push

