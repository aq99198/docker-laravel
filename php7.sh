#!/bin/sh

DIR_NAME=$1
REPOSITORY_ADDR=$2
DOCKER_IMAGE=$3
DOCKER_CONTAINER=$4
LOG_PATH=$5
APP_CONTAINER=$6
DB_CONTAINER=$7
CACHE_CONTAINER=$8

./updateRepository.sh ${DIR_NAME} ${REPOSITORY_ADDR}

if [ ! -d ${LOG_PATH} ]; then
  sudo mkdir -p ${LOG_PATH}
fi

cd ${DIR_NAME}
sudo docker build -t ${DOCKER_IMAGE} .
sudo docker stop ${DOCKER_CONTAINER}
sudo docker rm ${DOCKER_CONTAINER}
sudo docker run -d --name ${DOCKER_CONTAINER} \
	--link ${DB_CONTAINER}:db \
	--link ${CACHE_CONTAINER}:redis \
	--volumes-from ${APP_CONTAINER} \
	-v ${LOG_PATH}:/var/log/php \
	${DOCKER_IMAGE}
