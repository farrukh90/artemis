## This repo is used to deploy helm artemis application

---
### Usage
---

## Artemis E-commerse Web-Application
Pre Build process be fore you deploy the application please open port 5000 on Security Group and then follow the bellow commands.
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
## Following this commands 
 ## 1. Clone repo
 ```
 git clone https://github.com/farrukh90/artemis.git
 ```

 ## 2. Build image following commands
 ```
 * docker image build -t "artemis repo from GCP"/artemis:2.0.0 .

 * docker push "artemis repo from GCP"/artemis:2.0.0 

 * git chekout 2.0.0
 ```
 ## Output should be like this
 <img width="689" alt="Screenshot 2023-04-01 at 3 17 22 PM" src="https://user-images.githubusercontent.com/80778542/229955711-2ea1ec12-ebcf-4f58-bb1e-edbc0774ea28.png">
 
 <img width="472" alt="Screenshot 2023-04-04 at 8 08 18 PM" src="https://user-images.githubusercontent.com/80778542/229955726-b10d0635-e9c8-4c60-b94b-b76e22e8097b.png">

 