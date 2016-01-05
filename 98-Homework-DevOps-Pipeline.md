
# Homework Lab: Using the DevOps Pipeline to Deploy Let's Chat

> **Difficulty**: Intermediate

> **Time**: 35 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Deploy a container bound to Bluemix services](#task-1-deploy-a-container-bound-to-bluemix-services)
- [Task 2: Review deployment automation steps](#task-2-review-deployment-automation-steps)
- [Task 3: Run your web app](#task-3-run-your-web-app)

## Prerequisites

Prior to running this lab, you must have completed the pre-reqs, lab 1, lab 2, and cleaned up your previous deployments.

## Task 1: Deploy application from existing repository

Previous labs walked you through manually deploying containers on Bluemix from scratch.  Some of the great reasons for using containers is speed and that doesn't come with doing everything by hand.  This task will walk you through using the IBM Bluemix Delivery Pipeline and the one-click *Deploy to Bluemix* button to speed that process up quite a bit!

1. Go to GitHub and this [demo repository](https://github.com/osowski/lets-chat-bluemix-simple) for the labs.

2. There is a lot more detail on containers, Let's Chat, and deploying on Bluemix.  But you've already done the pre-requisites so just click on the **Deploy to Bluemix** button for an even easier deployment.

3. You are taken to a new page which will require you to login.  You may need to setup your Jazz account if this is your first time.  If so, simply click **Log in** and you will be taken through the appropriate steps to create your shortname.

4. Once you are provided with the option to deploy, select an appropriate and unique app name, along with the following from the dropdowns:
  - Region: IBM Bluemix United Kingdom
  - Organization: [YOUR_EMAIL_ADDRESS]
  - Space: dev *(unless you created another space and have been working in there so far)*

5. Click **DEPLOY** and you will be taken to another page where you can watch the live deployment of your container-based application, all from a pre-built repository without ever needing to touch the code.

  As the automation goes through forking the project into your own account, setting up a pipeline for your account, and building & deploying those images on Bluemix, you will be updated in the UI.  Once the status page returns complete after a few minutes, you can move on to the next Task.

## Task 2: Review deployment automation steps

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


## Task 3: Run your web app

1. Get Public IP of your deployed container.  This can be found through the Bluemix Delivery Pipeline output of the **Deploy** stage via the **View logs and history** link.  

  The specific line will look something like `Public IP address of lets-chat-a_1 is 134.XXX.YYY.ZZZ and the TEST_URL is http://134.XXX.YYY.ZZZ:8080`.

  Alternatively, you can see this from the Bluemix UI or the IBM Containers CLI via the `cf ic ps` command.

2. Go to http://[YOUR_PUBLIC_IP]:8080 in your browser and you've got your web app up & running!  No coding or command line needed!

3. Now every change that would come into your repository can kick off a new Docker image build and push that image into deployment through the dev/test/production cycle.  The delivery pipelines can be configured to automatically or manually build, deploy, and move images throughout multiple stages.  It's all up to you!

## Conclusion

Congratulations, you have successfully completed this IBM Containers lab!.  You've just automatically deployed your Docker-based web app on a hosted container service, through an automated pipeline!  In this lab, you learned how to automate Docker image build and deployment, as well as bind Bluemix services to your running IBM Containers.

Now you can take the no-code approach to all your future application deployments!