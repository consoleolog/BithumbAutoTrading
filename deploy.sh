#!/bin/bash

IMAGE_NAME=autotrader
UPBIT_CONTAINER_NAME=upbit
BITHUMB_CONTAINER_NAME=bithumb

EXIST_UPBIT_BLUE=$(sudo docker-compose -p "$UPBIT_CONTAINER_NAME-blue" -f docker-compose.blue.yaml | grep Up)
if [ -z "$EXIST_UPBIT_BLUE" ]; then 
    echo "---------------"
    echo " upbit blue up "
    echo "---------------"
    sudo docker-compose -p "$UPBIT_CONTAINER_NAME-blue" -f docker-compose.blue.yaml up -d --build 
    UPBIT_BEFORE_COMPOSE_COLOR="green"
    UPBIT_AFTER_COMPOSE_COLOR="blue"
else
    echo "----------------"
    echo " upbit green up "
    echo "----------------"
    sudo docker-compose -p "$UPBIT_CONTAINER_NAME-green" -f docker-compose.green.yaml up -d --build 
    UPBIT_BEFORE_COMPOSE_COLOR="blue"
    UPBIT_AFTER_COMPOSE_COLOR="green"
EXIST_BITHUMB_BLUE=$(sudo docker-compose -p "$BITHUMB_CONTAINER_NAME-blue" -f docker-compose.blue.yaml up -d --build)
if [ -z "$EXIST_BITHUMB_BLUE" ]; then 
    echo "-----------------"
    echo " bithumb blue up "
    echo "-----------------"
    sudo docker-compose -p "$BITHUMB_CONTAINER_NAME-blue" -f docker-compose.blue.yaml up -d --build 
    BITHUMB_BEFORE_COMPOSE_COLOR="green"
    BITHUMB_AFTER_COMPOSE_COLOR="blue"
else
    echo "------------------"
    echo " bithumb green up "
    echo "------------------"
    sudo docker-compose -p "$BITHUMB_CONTAINER_NAME-green" -f docker-compose.green.yaml up -d --build 
    BITHUMB_BEFORE_COMPOSE_COLOR="blue"
    BITHUMB_AFTER_COMPOSE_COLOR="green"

IMAGE_ID=$(sudo docker images -q $IMAGE_NAME)

sleep 10

UPBIT_EXIST_AFTER=$(sudo docker-compose -p "$UPBIT_CONTAINER_NAME-$UPBIT_AFTER_COMPOSE_COLOR" -f docker-compose.$UPBIT_AFTER_COMPOSE_COLOR.yaml ps | grep up)
if [ -n "$UPBIT_EXIST_AFTER" ]; then
  sudo docker-compose -p "$CONTAINER_NAME-$UPBIT_BEFORE_COMPOSE_COLOR" -f docker-compose.$UPBIT_BEFORE_COMPOSE_COLOR.yaml down
  echo "------------------"
  echo " upbit $UPBIT_BEFORE_COMPOSE_COLOR down"
  echo "------------------"
  sudo docker rmi "$IMAGE_ID"
fi

BITHUMB_EXIST_AFTER=$(sudo docker-compose -p "$BITHUMB_CONTAINER_NAME-$UPBIT_AFTER_COMPOSE_COLOR" -f docker-compose.$BITHUMB_AFTER_COMPOSE_COLOR.yaml ps | grep up)
if [ -n "$BITHUMB_EXIST_AFTER" ]; then
  sudo docker-compose -p "$CONTAINER_NAME-$BITHUMB_BEFORE_COMPOSE_COLOR" -f docker-compose.$BITHUMB_BEFORE_COMPOSE_COLOR.yaml down
  echo "------------------"
  echo " bithumb $BITHUMB_BEFORE_COMPOSE_COLOR down"
  echo "------------------"
  sudo docker rmi "$IMAGE_ID"
fi