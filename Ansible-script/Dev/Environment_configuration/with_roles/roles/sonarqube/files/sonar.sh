#!/bin/bash

#downloading sonarqube file
#sudo su
#sudo su duser
whoami
pwd
cd /opt/
pwd
rm -rf /opt/sonarqube || true
rm -rf /opt/sonarqube.zip || true
#touch test.txt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip -O /opt/sonarqube.zip
sudo unzip sonarqube.zip 
sudo mv sonarqube-9.9.0.65466  sonarqube
sed -i 's/#sonar.web.port=9000/sonar.web.port=9001/g' /opt/sonarqube/conf/sonar.properties
sed -i 's/#sonar.search.port=9001/sonar.search.port=9002/g' /opt/sonarqube/conf/sonar.properties
chown -R sonar:sonar /opt/sonarqube


