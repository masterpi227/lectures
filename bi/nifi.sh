cd
mkdir addons
apt install -y unzip
cd addons
wget https://jdbc.postgresql.org/download/postgresql-42.7.4.jar
cd /lectures/bi
EXTERNAL_IP=$(curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
docker run -d --name nifi \
    -p 8443:8443 \
    -e NIFI_WEB_HTTP_HOST=0.0.0.0 \
    -e NIFI_WEB_PROXY_HOST=$EXTERNAL_IP:8443 \
    -e SINGLE_USER_CREDENTIALS_USERNAME=admin \
    -e SINGLE_USER_CREDENTIALS_PASSWORD=ctsBtRBKHRAx69EqUghvvgEvjnaLjFEB \
    -v $(pwd)/addons:/opt/nifi/nifi-current/addons \
    apache/nifi:latest