
# Artemis
![alt text](https://github.com/farrukh90/artemis/blob/master/images/artemis.png?raw=true)


## Artemis E-commerse Web-Application
Artemis, a cutting-edge e-commerce application, is poised to redefine the way you shop online. Crafted with Python, Artemis stands out as a sophisticated, user-friendly platform that seamlessly integrates advanced technology with an intuitive interface to offer an unparalleled shopping experience.

#### Sleek Design & Intuitive Interface:
Artemis boasts an aesthetically pleasing and user-centric design, ensuring effortless navigation for users of all technical backgrounds. The interface is thoughtfully crafted to enhance user engagement, allowing seamless browsing, searching, and purchasing of products.

#### Personalized User Experience:
Artemis prioritizes personalization. Through advanced algorithms and machine learning capabilities, the platform tailors product recommendations and suggestions based on individual preferences, browsing history, and purchase patterns. This ensures that users discover items that align perfectly with their tastes and needs.

#### Comprehensive Product Catalog:
With an extensive range of categories and products, Artemis caters to diverse consumer needs. From electronics, fashion, beauty, home decor to lifestyle essentials, the platform offers a vast array of high-quality products from trusted brands and independent sellers.

#### Secure Transactions & Payment Options:
Security is paramount at Artemis. The platform employs robust encryption methods to safeguard user data and ensure secure transactions. Multiple payment gateways are integrated, offering users flexibility and convenience in choosing their preferred payment method.

#### Vendor-Friendly Platform:
Artemis supports sellers by providing an intuitive dashboard for easy product management, order tracking, and analytics. Sellers can efficiently showcase their products, manage inventory, and gain insights to optimize their sales strategies.

#### Seamless Order Fulfillment & Delivery:
Efficiency is key in Artemis. The platform streamlines the order fulfillment process, ensuring swift processing, accurate tracking, and timely delivery to enhance customer satisfaction.

#### Community Engagement & Reviews:
Artemis fosters a thriving community of users who can share their experiences through reviews, ratings, and discussions. This interactive feature enables customers to make informed decisions while building a sense of trust and credibility within the Artemis community.

#### Responsive Customer Support:
Artemis prioritizes customer satisfaction with a dedicated support system. Users can access a responsive customer service team available to address queries, provide assistance, and ensure a smooth shopping journey.

#### Mobile-Friendly Experience:
Artemis is designed to be responsive across devices. The mobile application provides the same seamless experience as the web version, allowing users to shop conveniently on the go.

#### Continuous Innovation & Updates:
The Artemis team is committed to continual improvement. Regular updates and innovative features ensure that the platform remains at the forefront of e-commerce, incorporating the latest trends and technologies to enhance user experience.

Artemis aims to transform the way individuals shop online, offering a secure, convenient, and personalized platform that adapts to the evolving needs of modern consumers. Dive into Artemis today and discover a world of unparalleled convenience and endless possibilities.



# Build Process
### Specs: 
```
Port: 5000
```

### Release an application

1. Clone a repo
```
git clone https://github.com/farrukh90/artemis.git
```

2. change version
```
git checkout  YOUR_VERSION   (e.g 2.0.0)
```
3. Build Image locally 
```
docker  build -t us-central1-docker.pkg.dev/YOUR_PROJECT/YOUR_REPO/YOUR_APPNAME:YOUR_VERSION      .   
```            
4. Authenticate to Registry
```
gcloud auth configure-docker us-central1-docker.pkg.dev                                                                           
```
5. Push image 
```
docker push us-central1-docker.pkg.dev/YOUR_PROJECT/YOUR_REPO/YOUR_APPNAME:YOUR_VERSION                           
```






# Deploy Process
##### To check if helm is installed in the system please run below commands:
```
helm version
```

### 3. Create helm chart for application
```
helm create application
```
### 4. Update values.yaml file
```
image:
  repository: us-central1-docker.pkg.dev/YOUR_PROJECT/YOUR_REPO/YOUR_APPNAME:YOUR_VERSION
  tag: "YOUR_VERSION"
```

### 4. Install test helm chart
```
helm install artemis application
```
### 5. Verify
```
helm list
kubectl get all
```
### 6. Uninstall helm chart
```
helm uninstall test
```

 ## Output should be like this
 <img width="689" alt="Screenshot 2023-04-01 at 3 17 22 PM" src="https://user-images.githubusercontent.com/80778542/229955711-2ea1ec12-ebcf-4f58-bb1e-edbc0774ea28.png">
 
 <img width="1792" alt="1 0 0" src="https://github.com/farrukh90/artemis/assets/80778542/b72d27d1-0106-4756-a0bc-6a497b64f937">
