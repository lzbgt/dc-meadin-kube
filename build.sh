#!/bin/sh
set -e

ver=v1
proj_base=/home/hadoop/work/dc-parent
docker_registry=node1:30400
kube_dir=/home/hadoop/work/k8s/dc-meadin

#kubectl delete -f $kube_dir

declare -a dir_modules=("dc-common-module" "dc-common-druid" "dc-common-business" "dc-mongodb-api" "dc-external-api-api" "dc-redis-api" "dc-solr-api" "dc-sso-api" "dc-statistics-api" "dc-reptile-api")

for m in "${dir_modules[@]}"
do
  cd $proj_base/$m
  mvn clean install
done

declare -a dir_services=("dc-redis" "dc-mongodb" "dc-sso" "dc-solr" "dc-customer-main" "dc-customer-portrayal" "dc-eureka-server" "dc-customer-sentiment")
for i in "${dir_services[@]}"
do
  cd $proj_base/$i
  sudo chown -R hadoop ../; mvn clean package; sudo mvn docker:build
  sudo docker tag $i $docker_registry/$i:$ver
  sudo docker push $docker_registry/$i:$ver
done

#kubectl apply -f $kube_dir
