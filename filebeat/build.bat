@echo off

cd ./
docker image rm -f filebeat-image
docker build --no-cache -t filebeat-image -f Dockerfile .

SET hub_url=20.189.72.69:8888
SET user=admin
SET password=P@sswordnull123

docker login -u %user% -p %password% http://%hub_url%

docker tag filebeat-image %hub_url%/wishcloud/filebeat-image:latest
docker push %hub_url%/wishcloud/filebeat-image:latest
docker rmi %hub_url%wishcloud/filebeat-image:latest

docker logout http://%hub_url%