curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -sL https://ctl.flyte.org/install | bash
mv bin/flytectl /usr/local/bin/flytectl
flytectl demo start
