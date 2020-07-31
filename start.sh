#!/bin/bash
export BUILD_ID=dontKillMe
ACTION=$1
APP_HOME=/home/project  #jar包存放目录
JAR_NAME=test-pipeline-0.0.1-SNAPSHOT.jar #jar包名称
PID_FILE=/home/project/pidfile.txt  #pid文件
BAK_HOME=/home/project/bak  #jar包备份目录
BAK_FILE=$BAK_HOME/bakfile.txt  #备份版本
MAX_BAK=3 #最高备份数

start(){
  #kill pid and remove pidfile
  if [ -e $PID_FILE ]; then
    echo "pid file exist"
    kill -9 `cat $PID_FILE`
    rm $PID_FILE
  else
    echo "pid file no exist"
  fi
  nohup java -jar $APP_HOME/$JAR_NAME > logfile.log 2>&1 &
  echo $! > $PID_FILE

  bak
}

bak(){
  #bak jar
  if [ ! -f $BAK_HOME ]; then
    mkdir $BAK_HOME
  fi
  cd $BAK_HOME
  bak_num=$(ls -l *.jar|wc -l)
  if [ $bak_num -ge $MAX_BAK ]; then
    echo "============ remove oldest bak ============"
    rm $(ls -t | tac | grep jar | head -n 1)
  fi
  current_bak_version=0
  if [ -f $BAK_FILE ]; then
    echo "============ bakfile exist ============"
    current_bak_version=`cat $BAK_FILE`
  else
    echo "============ bakfile no exist ============"
  fi
  current_bak_version=$[$current_bak_version+1]
  echo $current_bak_version > $BAK_FILE
  cp $APP_HOME/$JAR_NAME $BAK_HOME/${JAR_NAME%.jar*}"-version-$current_bak_version.jar"
  echo "============ move bak to $BAK_HOME ============"
  echo "============ bak finish ============"
}

stop(){
  #kill pid and remove pidfile
  if [ -e $PID_FILE ]; then
    echo "pid file exist"
    kill -9 `cat $PID_FILE`
    rm $PID_FILE
  else
    echo "pid file no exist"
  fi
  echo "stop finish"
}

case $ACTION in
  start)
    start
    ;;
  stop)
    stop
    ;;
esac
sleep 10s