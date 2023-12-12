
# Artemis
![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

---
### Usage
---

## Artemis E-commerse Web-Application
Pre Build process before you deploy the application please open port 5000 on Security Group and then follow the bellow commands.
```
yum install python-pip -y
pip install Flask
```


## To check if helm is installed in the system please run below commands:

```
helm version
```

## If above command responds with an error output, please follow the instructions listed below


### 1. Read helm compatibility 
```
https://helm.sh/docs/topics/version_skew/
```

### 2. Install helm to your repository
```
wget https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar xzvf helm-v3.7.2-linux-amd64.tar.gz
rm -rf helm-v3.7.2-linux-amd64.tar.gz
mv linux-amd64/helm charts/
cd chart
```

### 3. Create helm chart for application
```
./helm create application
```

### 4. Install test helm chart
```
./helm install test application
```
### 5. Verify
```
 * helm list
 * kubectl get all
```
### 6. Uninstall helm chart
```
./helm uninstall test
```

# This repository contains all the requirements of artemis application. And the application is versioned in branches
```
https://github.com/farrukh90/artemis/tree/master
```

Pushing a docker image

Clone this repo
git clone https://github.com/farrukh90/artemis.git

Change the branch to specific version  e.g  2.0.0
git checkout 2.0.0

Get repo location from Google 
Google Console >> Search for Artifact registry >> Artemis >> Repo link copy

Build a docker image
docker image build  -t  us-central1-docker.pkg.dev/terraform-project-382315/artemis/artemis:2.0.0   . 

Authenticate to Registry
gcloud auth configure-docker us-central1-docker.pkg.dev

Push an image
docker push us-central1-docker.pkg.dev/terraform-project-382315/artemis/artemis:2.0.0


 ```
 ## Output should be like this
 <img width="689" alt="Screenshot 2023-04-01 at 3 17 22 PM" src="https://user-images.githubusercontent.com/80778542/229955711-2ea1ec12-ebcf-4f58-bb1e-edbc0774ea28.png">
 
 <img width="1792" alt="main" src="https://github.com/farrukh90/artemis/assets/80778542/8de57be7-b1b2-4d45-8eb0-031c2a9eba3f">
 
