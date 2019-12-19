#!/usr/bin/env bash

#Install 

set -e

# Installing kubernetes.
if [ ! -f "kubectl" ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo cp ./kubectl /usr/local/bin/kubectl
fi

# Installing helm
if [ ! -f "get_helm.sh" ]; then
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
    chmod 700 get_helm.sh
    sudo ./get_helm.sh
fi

# Installing skaffold.
if [ ! -f "skaffold" ]; then
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    chmod +x skaffold
    sudo cp skaffold /usr/local/bin
fi

# Installing code cov.
echo "installing code coverage"
curl -s https://codecov.io/bash > codecov
chmod +x codecov

# Restoring dot net tools
dotnet tool restore

# Restoring dot net paket
dotnet paket install

# making the solution

echo "building the solution"
make build

echo "running the coverage"
make coverage

echo "deploying documentation"
make deploy
