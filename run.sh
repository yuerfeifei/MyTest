#!/bin/bash
source ~/.bash_profile
source /etc/profile

echo "==========definition param=========="
APP_NAME=mytest0.0.1-SNAPSHOT
APP_JAR=$APP_NAME.jar

echo "==========join jenkins $APP_NAME workspace=========="
cd /root/.jenkins/workspace/$APP_NAME/

echo "==========create $APP_NAME project workspace=========="
mkdir -vp /app/project/$APP_NAME

echo "==========copy $APP_NAME project to projectWork=========="
\cp -R ../$APP_NAME/* /app/project/$APP_NAME

echo "==========go $APP_NAME projectWork=========="
cd /app/project/$APP_NAME

echo "==========maven clean package=========="
mvn clean package

echo "==========create jarRun $APP_NAME workspace=========="
mkdir -vp /app/software/jarRun/$APP_NAME/

echo "==========copy jar file to jarRun work=========="
\cp -R /app/project/$APP_NAME/target/$APP_NAME-1.1.0.jar /app/software/jarRun/$APP_NAME/

echo "==========delete target file=========="
rm -rf target*

echo "==========go jar workspace =========="
cd /app/software/jarRun/$APP_NAME/


echo "==========update jar project name=========="
mv -f $APP_NAME-1.1.0.jar $APP_NAME.jar

echo "==========chmod file auth =========="
chmod 777 $APP_NAME.jar

echo "==========kill already exists jar start =========="
tpid=`ps -ef|grep $APP_JAR|grep -v grep|grep -v kill|awk "{print $2}"`
if [ ${tpid} ]; then
echo "**********************Stop jar**********************"
kill -9 $tpid
fi
echo "==========kill jar end =========="


#ps -ef | grep "$APP_NAME" | grep -v grep |awk "{print $2}" |xargs kill -9
echo "==========run java project=========="
# nohup java -jar /app/software/jarRun/$APP_NAME.jar &
echo "********************************************************************"
echo "****如果脚本使用nohup启动,则必须在他之前指定BUILD_ID(名字可以随便定义)**"
echo "********************************************************************"
BUILD_ID=jenkins-demo
nohup java -jar $APP_NAME.jar > ../$APP_NAME/nohup.out 2>&1 &

echo "==========SUCCESS=========="
