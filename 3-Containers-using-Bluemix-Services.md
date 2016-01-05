
# Lab 3: Containers using Bluemix Services

> **Difficulty**: Intermediate

> **Time**: 35 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Create a bridge application](#task-1-create-a-bridge-application)
- [Task 2: Deploy a container bound to Bluemix services](#task-2-deploy-a-container-bound-to-bluemix-services)

## Prerequisites

Prior to running this lab, you must have completed the pre-reqs, lab 1, lab 2, and cleaned up your previous deployments.

## Task 1: Create a bridge application

IBM Containers have the advantage of running on IBM Bluemix and because of that, you can leverage any of the 150+ Bluemix services inside your running containers.  To do this, you will need to create a Bluemix application to expose your desired services to your containers.

1. Go to the [Bluemix Dashboard](https://console.ng.bluemix.net/?direct=classic/#/resources) and click on **CREATE APP**.

![create](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/17-create-app.jpg) 

2. Click on **WEB** app.  Select **SDK for Node.js** and **CONTINUE**.

![web](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/18-web.jpg)
![node](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/19-sdk-node.jpg)

3. Enter a unique name for your application and click **DEPLOY**.  This must be unique across all the entire Bluemix region your are working in.  For instance, "testapp" is a less than desirable name.  Something like "[YOUR_NAME]-bridge-app" is much better.  This will become the hostname for your app once deployed on Bluemix.
 
![name](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/20-app-name.jpg)

4. Once you're application has been deployed and you are taken to the **Getting Started** page, click on the **Overview** tab on the left.
 
![overview](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/21-app-created.jpg)

5. Now you will need to bind a MongoDB service instance to your application.  This will then expose the credentials to your container at runtime.  Click on **ADD A SERVICE OR API**.
 
![servuce](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/22-add-service.jpg)

6. Search for or scroll to **MongoDB by Compose** and click on it.

![mongodb](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/23-mongo.jpg)

7. The credentials that you will need to enter on this page will be shared with you during the lab.  These credentials are Host, Port, Username, and Password.  Enter the provided credentials and click **CREATE**.  All other defaults on the page are acceptable.

![mongoinfo](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/24-mongo-connection.jpg)

- **Host:** ds041053.mongolab.com
- **Port:** 41053
- **Username:** ibmcontainers
- **Password:** containers

- Alternatively, you can sign up for a *Free 30-Day Trial* at [Compose](https://compose.io) and use all of the features beyond just today.  If you are interested in cloud application development, I'd highly recommend signing up for your own Compose account, as they provide a number of offerings that are critical for efficient application development - MongoDB, PostgreSQL, Redis, etcd, and many more!
  
8. Once you are prompted to restage your application, click **RESTAGE** and wait a few moments for your application to be running again.

![restage](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/25-restage.jpg) 

9. Since you will be using some pre-built automation to deploy your application, you will need to rename your bridge application to a more standard name.  This will only change the application name inside your space and not the hostname (which is the property that must be unique across all of the Bluemix region).

  From the **Overview** tab of your application, click on the cog icon in the upper-right corner and select **RENAME APPLICATION**.  Enter a new name of **lets-chat-bridge** and click **OK**.  

  Your application data in the UI should reflect this naming change.  Note that your bound hostname did not change at all.

![rename](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/26-app-rename.jpg)
![name](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/27-app-rename.jpg)

Now you've created the necessary services for your container to leverage Mongo as a Service!

## Task 2: Deploy a container bound to Bluemix services

By leveraging the MongoDB by Compose service in Bluemix, you can now have persistent storage to your Let's Chat application.  In the previous deployment using the Mongo container, all of the content was lost when the container was deleted.

1. Click the **Back to Dashboard** link from the upper left.

![dashboard](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/28-back-to-dashboard.jpg)

2. Click **Start Containers**.

![dashboard](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/29-start-containers.jpg)

3. We will deploy a single container with the name "lets-chat", size "pico", assign a publicly routed IP address, and bind the Bluemix application to the container.  Click **CREATE**.

![create](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/30-create-container.jpg)

4. After the deployment, the public IP address will be reachable on port 8080.

![letschat](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/14-lets-chat.jpg)

## Cleanup

To continue with another lab, you need to clean up your container instances.  This can be done through the UI and the **DELETE** button on each container, or you can do this through the CLI with the `cf ic rm -f [CONTAINER_NAME]` command.

##Congratulations!!!  You have successfully accomplished lab 3.

####Let's recap what you've accomplished thus far:

- Created a Bluemix application with the MongoDB service by Compose
- Deployed the Let's Chat container bound to that Bluemix app for persistent storage

###Time to continue with lab 4 - Zero Downtime with the Active Deployment Service
