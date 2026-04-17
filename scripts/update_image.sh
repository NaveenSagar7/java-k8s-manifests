#!/bin/bash

VERSION=$1

sed -i "s|image:.*|image: naveen352/java-demo-argocd:$VERSION|g" ../deploy.yaml

git config --local user.email "mandhadisagar3023@gmail.com"
git config --local user.name "NaveenSagar7"

git add ../deploy.yaml

git commit -m "update image version $VERSION [skip ci]"

