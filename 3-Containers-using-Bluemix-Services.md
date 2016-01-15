
# Lab 3: Containers using Bluemix Services

> **Difficulty**: Intermediate

> **Time**: 35 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Create a bridge application](#task-1-create-a-bridge-application)
- [Task 2: Deploy a container bound to Bluemix services](#task-2-deploy-a-container-bound-to-bluemix-services)
- [Task 3: Run your web app](#task-3-run-your-web-app)
- [Task 4: Optional - Review deployment automation steps](#task-4-optional-review-deployment-automation-steps)

## Prerequisites

Prior to running this lab, you must have completed the pre-reqs, lab 1, lab 2, and cleaned up your previous deployments.

## Task 1: Create a bridge application

IBM Containers have the advantage of running on IBM Bluemix and because of that, you can leverage any of the 150+ Bluemix services inside your running containers.  To do this, you will need to create a Bluemix application to expose your desired services to your containers.

 1. Go to the [Bluemix Dashboard](https://console.ng.bluemix.net/?direct=classic/#/resources) and click on **CREATE APP**.

![create](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/17-create-app.jpg) 

 2. Click on **WEB** app.  Select **SDK for Node.js** and **CONTINUE**.

![web](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/18-web.jpg)
![node](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/19-sdk-node.jpg)

 3. Enter a unique name for your application and click **FINISH**.  This must be unique across all the entire Bluemix region your are working in.  For instance, "testapp" is a less than desirable name.  Something like "[YOUR_NAME]-bridge-app" is much better.  This will become the hostname for your app once deployed on Bluemix.
 
**NOTE:** You will not have a drop down box for domain name unless you have multiple domains defined inside Bluemix.
 
![name](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/20-app-name.jpg)

 4. Once you're application has been deployed and you are taken to the **Getting Started** page, click on the **Overview** tab on the left.
 
![overview](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/21-app-created.jpg)

 5. Now you will need to bind a MongoDB service instance to your application.  This will then expose the credentials to your container at runtime.  Click on **ADD A SERVICE OR API**.
 
![servuce](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/22-add-service.jpg)

 6. Search for or scroll to **MongoDB by Compose** and click on it.

![mongodb](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/23-mongo.jpg)

 7. The credentials that you will need to enter on this page will be shared with you during the lab.  These credentials are Host, Port, Username, and Password.  Enter the provided credentials and click **CREATE**.  All other defaults on the page are acceptable.

![mongoinfo](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/24-mongo-connection.jpg)

- **Host:** c795.candidate.53.mongolayer.com
- **Port:** 10795
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

Previous labs walked you through manually deploying containers on Bluemix from scratch.  Some of the great reasons for using containers is speed and that doesn't come with doing everything by hand.  This task will walk you through using the IBM Bluemix Delivery Pipeline and the one-click *Deploy to Bluemix* button to speed that process up quite a bit!

1. Go to GitHub and this [demo repository](https://github.com/osowski/lets-chat-bluemix-simple) for the labs.

2. There is a lot more detail on containers, Let's Chat, and deploying on Bluemix.  But you've already done the pre-requisites so just click on the **Deploy to Bluemix** button for an even easier deployment.

![LetsChat1](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/lets-chat-deploy1.jpg)

3. You are taken to a new page which will require you to login using your Bluemix credentials.  You may need to setup your Jazz account if this is your first time.  If so, simply click **Log in** and you will be taken through the appropriate steps to create your shortname.

![LetsChat2](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/lets-chat-deploy2.jpg)

4. Once you are provided with the option to deploy, select an appropriate and unique app name, along with the following from the dropdowns:
  - Region: IBM Bluemix US South
  - Organization: [YOUR_EMAIL_ADDRESS]
  - Space: dev *(unless you created another space and have been working in there so far)*

5. Click **DEPLOY** and you will be taken to another page where you can watch the live deployment of your container-based application, all from a pre-built repository without ever needing to touch the code.

![LetsChat3](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/lets-chat-deploy3.jpg)

As the automation goes through forking the project into your own account, setting up a pipeline for your account, and building & deploying those images on Bluemix, you will be updated in the UI.  Once the status page returns complete after a few minutes, you can move on to the next Task.

## Task 3: Run your web app

1. Go to the [Bluemix Dashboard](https://console.ng.bluemix.net/?direct=classic/#/resources) and view your deployed containers.  Click on the container called 'lets-chat-a_1'.

![LetsChat1](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/lets-chat1.jpg)

 * Alternatively, you can see this from the Bluemix UI or the IBM Containers CLI via the `cf ic ps` command.  Go to http://[YOUR_PUBLIC_IP]:8080 in your browser and you've got your web app up & running!

2. Right click on port 8080 and select 'Open in new tab'.

![LetsChat2](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/lets-chat2.jpg)

3. You can now create a new account that will remain persistent in the MongoDB Service.

![LetsChat3](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/lets-chat3.jpg)

4. Now every change that would come into your repository can kick off a new Docker image build and push that image into deployment through the dev/test/production cycle.  The delivery pipelines can be configured to automatically or manually build, deploy, and move images throughout multiple stages.  It's all up to you!

## Task 4: Optional - Review deployment automation steps

Now that your project has been deployed to IBM Containers on Bluemix, let's review what really just happened.  Bluemix forked the GitHub project into a Jazz Hub project, IBM's hosted source code management platform.  Inside this project a build pipeline was imported from the `.bluemix/pipeline.yaml` file in the original repository.  This pipeline will automatically build the Docker image for Let's Chat, push it to your private registry in Bluemix, and then deploy a running container instance on IBM Containers.

1. To view the project, right-click on **Created project successfully** and open the link in a new tab.  This will show you the standard project view with the forked code from GitHub.

2. Right now, you are interested in the Build Pipeline that was automatically created, so click on **BUILD & DEPLOY** in the upper right.  This will take you to the Build Pipeline view of your project and show you the two stages that were created for build and deploy of your container image.

3. Click on the gear icon in the top-right of the **Build Docker Images** box and select **Configure Stage**.  This will take you to the configuration view of your *Build* step.  

4. At the top of the page, click on the **INPUT** tab.  Here you can see the pipeline will pull from the forked project automatically.  When creating projects from scratch, you can connect directly with public GitHub projects, however for ease of use, the *Deploy to Bluemix* button uses the forked repository for quicker deployments.

5. Click on the **JOBS** button at the top of the page and you can see all the necessary information for building your image dynamically whenever a code change is pushed to your repository.  You can select which region, which organization, which space, and what to name your container image.  There is a default script that is included in this step which is more than sufficient, but you can modify it as needed.

6. Scroll to the bottom and click **CANCEL**.

7. Click on the gear icon in the top-right of the **Deploy Let's Chat Docker Image** box and select **Configure Stage**.  This will take you to the configuration view of your *Deploy* step.

8. At the top of the page, click on the **INPUT** tab again.  Here you will see the inputs for your *Deploy* step.  This step can be run manually or automatically, taking the input from the previous step's output (that being your *Build* step in this case).

9. Click on the **JOBS** button at the top of the page and you can see all the necessary information for deploying your image to IBM Containers on Bluemix.  This again allows you to select your specific region, organization, space, and image to deploy.

  Multiple deployment strategies are available, but by default *red_black* is selected to allow for maximum up-time of your container-based application.  Additional deployment strategies will be available soon.

  The *Ports* of your image are available to be exposed here and you can expose all, some, or none, depending on your pipeline needs.  Due to *IBM Containers* being a managed-Docker environment, you need to expose ports if you want your container to be accessible from other containers.  Otherwise, it will run fine but not be able to receive inbound communication from any other containers.  You only need to expose ports via the *image only format* (`-p 8080`), as the service will manage the host port mapping for all containers.

  The default deployment script is more than sufficient but can be modified to suit your needs, for something like dynamic linking, external lookups, integration with CMDBs or Software Config tools, etc.  You can also pass in `docker run` command-line arguments via the *Optional deploy arguments* field for things like `--link`, `--volume`, or `--env`.

10. Once you have reviewed the **Deploy** step, click **CANCEL** at the bottom of the page.

  You have now reviewed the automated deployment of a Docker-container project on IBM Containers, running on Bluemix.  For additional homework, you can create your own [IBM Bluemix DevOps Services](https://hub.jazz.net/) project pulling from a public GitHub repository and build your own pipeline to deploy Docker containers on Bluemix.


## Cleanup

To continue with another lab, you need to clean up your container instances.  This can be done through the UI and the **DELETE** button on each container, or you can do this through the CLI with the `cf ic rm -f [CONTAINER_NAME]` command.

##Congratulations!!!  You have successfully accomplished lab 3.

####Let's recap what you've accomplished thus far:

- Created a Bluemix application with the MongoDB service by Compose
- Deployed the Let's Chat container bound to that Bluemix app for persistent storage

###Time to continue with lab 4 - Zero Downtime with the Active Deployment Service
