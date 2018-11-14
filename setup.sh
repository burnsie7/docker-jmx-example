#!/bin/bash
chmod u+w ~

echo "Provisioning!"
echo "Installing Docker"
sudo apt-get -y update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get -y update

sudo apt-get -y install docker-ce

# verify docker installation completed successfully
sudo docker run hello-world

#Directory from which auto_conf yamls will be mounted to the agent container
sudo mkdir /opt/dd-agent-auto_conf

sudo cp <PATH_TO_THIS_REPO>/data/jmx.yaml /opt/dd-agent-auto_conf/jmx.yaml

# Uncomment for Amazon Linux
docker run -d --name dd-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /cgroup/:/host/sys/fs/cgroup:ro \
  -v /opt/datadog-agent-conf.d:/conf.d:ro \
  -e DD_API_KEY="<PASTE_YOUR_API_KEY_HERE>" \
  -e DD_HOSTNAME="$HOSTNAME.jmx-service-discovery" \
  -e DD_DOGSTATSD_ORIGIN_DETECTION=true \
  -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true \
  -e SD_JMX_ENABLE=true \
  -e SD_BACKEND=docker \
  -e TAGS="tester:jmx-sd" \
  -p 8125:8125/tcp \
  datadog/agent:latest-jmx

# troubleshooting commands
# docker exec -it dd-agent cat /opt/datadog-agent/run/jmx_status.yaml
# docker exec -it dd-agent agent configcheck


# Uncomment for non-Amazon flavor
#sudo docker run -d --name dd-agent \
#  -v /var/run/docker.sock:/var/run/docker.sock:ro \
#  -v /proc/:/host/proc/:ro \
#  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
#  -v /opt/dd-agent-auto_conf:/etc/dd-agent/conf.d/auto_conf:ro \
#  -e DD_API_KEY=<PASTE API KEY HERE> \
#  -e DD_HOSTNAME="$HOSTNAME.jmx-service-discovery" \
#  -e SD_JMX_ENABLE=true \
#  -e SD_BACKEND=docker \
#  -e TAGS="tester:jmx-sd" \
#  datadog/docker-dd-agent:latest-jmx

sudo docker restart dd-agent

#Build and run sample java app
cd <PATH_TO_THIS_REPO>/data
sudo docker build -t my-java-app .
sudo docker run -d --name some-java my-java-app
