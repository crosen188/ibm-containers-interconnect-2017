
# Lab 1: Introduction to IBM Containers and Docker

> **Difficulty**: Easy

> **Time**: 20 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Verify your environment](#task-1-verify-your-environment)
- [Task 2: Download your public images](#task-2-download-your-public-images)
- [Task 3: Log into IBM Containers using the CLI](#task-3-log-into-ibm-containers-using-the-cli)

## Prerequisites

Prior to running this lab, you must have a Bluemix account and access to a lab laptop (containers / containers).  Instructions are available in [prereqs](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/0-prereqs.md) to create your Bluemix account, log into the Bluemix UI, and create a unique namespace.

## Task 1: Verify your environment

Docker Engine should be installed and running in your machine. In this task we will verify that Docker is running and run our first container.

1. Open a Terminal window.  Verify that you are running a recent Docker version by running the **"docker version"** command in the terminal.  You should see something similar to the following:

        $ docker version
        Client:
         Version:      1.8.3
         API version:  1.20
         Go version:   go1.4.2
         Git commit:   f4bf5c7
         Built:        Mon Oct 12 18:01:15 UTC 2015
         OS/Arch:      darwin/amd64

        Server:
         Version:      1.8.3
         API version:  1.20
         Go version:   go1.4.2
         Git commit:   f4bf5c7
         Built:        Mon Oct 12 18:01:15 UTC 2015
         OS/Arch:      linux/amd64

2. To get started with Docker, run a simple container locally, using the `hello-world` image with the command """docker run hello-world".

        $ docker run hello-world

        Hello from Docker.
        This message shows that your installation appears to be working correctly.

        To generate this message, Docker took the following steps:

              1. The Docker client contacted the Docker daemon.
              2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
              3. The Docker daemon created a new container from that image which runs the
              executable that produces the output you are currently reading.
              4. The Docker daemon streamed that output to the Docker client, which sent it to your terminal.

        For more examples and ideas, visit [here](https://docs.docker.com/userguide/).

## Task 2: Download your public images

In this task, you will work with two public Docker images, [Let's Chat](https://github.com/sdelements/lets-chat) and [MongoDB](https://www.mongodb.org/).  The Let's Chat image is a web application that allows users to create message rooms for collaboration.  MongoDB is an open source, document-oriented database designed with both scalability and developer agility in mind.  

First, you will need to pull them down locally from the public [DockerHub](https://hub.docker.com/), which is a repository for Docker images.  By pulling (i.e., downloading) these images we will have them available on our workstation, which is required to run the images locally to learn how they function.

1. Pull the MongoDB image from DockerHub

        $ docker pull mongo
        Using default tag: latest
        latest: Pulling from library/mongo
        68e42ff590bd: Pull complete
        b4c4e8b590a7: Pull complete
        f037c6d892c5: Pull complete
        ...
        202e2c1fe066: Pull complete
        Digest: sha256:223d59692269be18696be5c4f48e3d4117c7f11e175fe760f6b575387abc1bba
        Status: Downloaded newer image for mongo:latest

2. Pull the Let's Chat image from DockerHub

        $ docker pull sdelements/lets-chat
        Using default tag: latest
        latest: Pulling from sdelements/lets-chat
        7a42f1433a16: Already exists
        3d88cbf54477: Already exists
        ...
        ca11de166bed: Already exists
        2409eb7b9e8c: Already exists
        Digest: sha256:98d1637b93a1fcc493bb00bb122602036b784e3cde25e8b3cae29abd15275206
        Status: Image is up to date for sdelements/lets-chat:latest

3. You can verify that containers can be deployed from these images and are compatible by running the applications locally.  Use the following "docker run" commands to start the two container instances.  The output is the unique container identifier and verifies completion of the executed command.

        Start a Mongo instance.  This will deploy a container that is running with the MongoDB inside.  
        ```
        $ docker run -d --name lc-mongo mongo  
        6ef19c325f6fda8f5c0277337dd797d4e31113daa7da92fbe85fe70557bfcb49
        ```


        Start a Let's Chat instance.  This will deploy a container with the Let's Chat application and link this container to the previously deployed MongoDB container.   
        ```
        $ docker run -d --name lets-chat --link lc-mongo:mongo -p 8080:8080 sdelements/lets-chat
        4180a983e329947196e317563037bfd0da093ab89add16911de90534c69a7822
        ```

4. Access the Let's Chat application through your browser using the loopback IP address (127.0.0.1).

           In your browser, access http://127.0.0.1:8080 or http://localhost:8080 or http://system_ip_here:8080.  

5. You can now stop and remove your local running containers.

        Stop the containers:  
        ```
        $ docker stop lets-chat lc-mongo
        lets-chat
        lc-mongo
        ```

        Delete the containers:  
        ```
        $ docker rm lets-chat lc-mongo
        lets-chat
        lc-mongo
        ```

## Task 3: Log into IBM Containers using the CLI

In this task, we will log into the IBM Containers command line to connect to Bluemix running on the IBM Cloud.

1. Back at your Terminal window, configure the Cloud Foundry CLI to work with the nearest IBM Bluemix region.  This ensures you will be working with the US South region of Bluemix.  To use the London datacenter, the API endpoint is "cf api https://api.eu-gb.bluemix.net".

        $ cf api https://api.ng.bluemix.net
        Setting api endpoint to https://api.ng.bluemix.net...
        OK

2. Log in to Bluemix through the Cloud Foundry CLI

        $ cf login
        API endpoint: https://api.ng.bluemix.net

        Email> <ENTER_EMAIL_USED_WHEN_CREATING_BLUEMIX_ACCOUNT> i.e., osowski@us.ibm.com

        Password>
        Authenticating...
        OK

        Select an org (or press enter to skip):
        1. osowski@us.ibm.com
        2. IBM_Containers_Demo_Org

        Org> 2
        Targeted org IBM_Containers_Demo_Org

        Targeted space IBM_Containers_Demo_Org



        API endpoint:   https://api.ng.bluemix.net (API version: 2.40.0)   
        User:           osowski@us.ibm.com   
        Org:            IBM_Containers_Demo_Org   
        Space:          IBM_Containers_Demo_Org

3. Log in to the IBM Container service on Bluemix

        $ cf ic login
        Client certificates are being retrieved from IBM Containers...
        Client certificates are being stored in /Users/osowski/.ice/certs/containers-api.ng.bluemix.net...
        OK
        Client certificates were retrieved.

        Checking local Docker configuration...
        OK

        Authenticating with registry at host name registry.ng.bluemix.net
        OK
        Your container was authenticated with the IBM Containers registry.
        Your private Bluemix repository is URL: registry.ng.bluemix.net/ibm_containers_demo

        You can choose from two ways to use the Docker CLI with IBM Containers:

        Option 1: This option allows you to use "cf ic" for managing containers on IBM Containers while still using the Docker CLI directly to manage your local Docker host.
        	Use this Cloud Foundry IBM Containers plug-in without affecting the local Docker environment:

        	Example Usage:
        	cf ic ps
        	cf ic images

        Option 2: Use the Docker CLI directly. In this shell, override the local Docker environment to connect to IBM Containers by setting these variables. Copy and paste the following commands:
        	Note: Only Docker commands followed by (Docker) are supported with this option.

 	        export DOCKER_HOST=tcp://containers-api.ng.bluemix.net:8443
         	export DOCKER_CERT_PATH=/Users/osowski/.ice/certs/containers-api.ng.bluemix.net
         	export DOCKER_TLS_VERIFY=1

        	Example Usage:
        	docker ps
        	docker images

## Congratulations!!!  You have successfully accomplished Lab 1.

#### Let's recap what you've accomplished thus far:

- Verified your Docker version
- Downloaded and ran your first Docker container
- Downloaded two new Docker images to run locally on your development VM
- Logged into the IBM Containers command line

### Time to continue with [Lab 2 - Docker Web Apps, running on IBM Containers](2-Running-Docker-Images-in-IBM-Containers.md)
