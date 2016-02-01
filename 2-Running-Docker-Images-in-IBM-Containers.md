
# Lab 2: Running Docker Images in IBM Containers

> **Difficulty**: Intermediate

> **Time**: 30 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Tag the images and upload to IBM Containers Bluemix](#task-tag-the-images-and-upload-to-ibm-containers-bluemix)
- [Task 2: Verify security vulnerabilities](#task-2-verify-security-vulnerabilities)
- [Task 3: Run your web app on Bluemix](#task-3-run-your-web-app-on-bluemix)

## Prerequisites

Prior to running this lab, you must have a Bluemix account and setup the IBM Containers command line locally.  Instructions are available in [prereqs](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/0-prereqs.md).  You must have also completed [lab 1](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/1-Intro-to-IBM-Containers-and-Docker.md).

If you are on a trial account, you will want to ensure that you have removed all non-essential containers, as these will impact your quota whether they are running or not.  These can be removed through the Bluemix UI or IBM Containers CLI.

## Task 1: Tag the images and upload to IBM Containers Bluemix

You will tag the previously downloaded images with your unique namespace so you can upload those images to your public registry hosted on Bluemix.

1.   Make note of your namespace:  

  $ cf ic namespace get

  ibm_containers_demo_eu


2. First tag your MongoDB image.  Remember to use your namespace from the first step to replace `[NAMESPACE]` in the tag and push commands below.  The namespace tag ensures that the image is uploaded to your private registry in the Bluemix cloud.

  List your images:  
  ```
  $ docker images
  REPOSITORY                                                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
  mongo                                                         latest              202e2c1fe066        7 days ago          261.6 MB
  sdelements/lets-chat                                          latest              2409eb7b9e8c        4 weeks ago         241.5 MB
  ```

  Tag your Mongo image in a Bluemix-compatible format:  
  ```
  $ docker tag -f mongo registry.ng.bluemix.net/[NAMESPACE]/mongo
  ```

  List your images again, now showing the newly tagged image:  
  ```
  $ docker images
  REPOSITORY                                                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
  mongo                                                         latest              202e2c1fe066        7 days ago          261.6 MB
  registry.ng.bluemix.net/ibm_containers_demo_eu/mongo       latest              202e2c1fe066        7 days ago          261.6 MB
  sdelements/lets-chat                                          latest              2409eb7b9e8c        4 weeks ago         241.5 MB
  ```

  Note that the `IMAGE ID` column did not change for the Mongo image.  Since we are not modifying the image, but rather simply giving it another name, the `IMAGE ID` stays the same and allows us to reuse the existing container image as-is.

2. We'll skip tagging the Let's Chat image because we are going to create a new image via Dockerfile.

3. To ensure the networking has enough time for configuration in this Let's Chat image, you will need to wrap your base Let's Chat image with a simple Dockerfile to ensure network connectivity.  You can use a Dockerfile to run any commands or installation scripts while creating a new Docker image.

To do so, create a new directory called `wrapper` at your Terminal window.  
  ```
  mkdir wrapper
  ```

  Switch to that directory and run the following command to create a Dockerfile  
  ```
  cd wrapper
  echo "FROM sdelements/lets-chat:latest" > Dockerfile
  echo "CMD (sleep 60; npm start)" >> Dockerfile
  ```

  This will create a new Dockerfile that we can build a temporary image from.  

  **NOTE:** There is a period "." at the end of this docker build command that is required for the command to run.

  ```
  docker build -t registry.ng.bluemix.net/[NAMESPACE]/lets-chat .
  ```

   Understanding this command's components:
      The "docker build -t" is standard from the Docker CLI.
      The "registry.ng.bluemix.net" is the fully qualified domain name path to the Registry server running for the IBM Bluemix US South region.
      The "NAMESPACE" is each user's unique namespace and identifies your private registry.
      The "lets-chat" is the name given to this newly created image.
      The "." specifies that the build command is running using the Dockerfile in this directory.

  You will now use this image below to push to Bluemix instead of the base `lets-chat` image.  

4. Now that your images are tagged in the correct format, you can push them to your private registry on Bluemix.  This allows the IBM Container service to run your container images on the cloud.

  Push your Mongo image to your Bluemix registry:  
  ```
  $ docker push registry.ng.bluemix.net/[NAMESPACE]/mongo
  The push refers to a repository [registry.ng.bluemix.net/[NAMESPACE]/mongo] (len: 1)
  Sending image list
  Pushing repository registry.ng.bluemix.net/[NAMESPACE]/mongo (1 tags)
  Image 68e42ff590bd already pushed, skipping
  Image b4c4e8b590a7 already pushed, skipping
  f037c6d892c5: Image successfully pushed
  1a64ad3ccff1: Image successfully pushed
  ...
  a08422dd6a11: Image successfully pushed
  202e2c1fe066: Image successfully pushed
  Pushing tag for rev [202e2c1fe066] on {https://registry.ng.bluemix.net/v1/repositories/[NAMESPACE]/mongo/tags/latest}
  ```

  Push your Let's Chat image to your Bluemix registry:  
  ```
  $ docker push registry.ng.bluemix.net/[NAMESPACE]/lets-chat
  The push refers to a repository [registry.ng.bluemix.net/[NAMESPACE]/lets-chat] (len: 1)
  Sending image list
  Pushing repository registry.ng.bluemix.net/[NAMESPACE]/lets-chat (1 tags)
  Image adb3157c92fa already pushed, skipping
  Image ed1f86248ba8 already pushed, skipping
  ...
  Image 48b1e23d7a1a already pushed, skipping
  Image 2409eb7b9e8c already pushed, skipping
  Pushing tag for rev [2409eb7b9e8c] on {https://registry.ng.bluemix.net/v1/repositories/ibm_containers_demo_eu/lets-chat/tags/latest}
  ```

   Now your images are up in the cloud, in your hosted registry, and ready to run on Bluemix!  But first, take a moment to understand what is inside the images you just pushed!

## Task 2: Verify security vulnerabilities

One of the fundamental aspects of Docker containers is reuse and the ability to base your images on top of other images.  Think of it as inheritance for infrastructure!  But with that comes some heavy responsibility to understand what code you are running on top of and what code you are bringing into your infrastructure through a `docker pull`.  

To solve this issue, IBM Containers provides **Vulnerability Advisor** (VA), a pre-integrated security scanning tool that will alert you of vulnerable images and can even be configured to prevent deployment of those images.  VA can scan any image, regardless of the source, before you deploy a live container from that image  For now, you will look over the vulnerability assessment of the images you just pushed.

1. Go to the [Bluemix Dashboard](https://console.ng.bluemix.net/?direct=classic/#/resources) and click on **CATALOG**.

![catalog](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/7-catalog.jpg)

2. You can filter the list by clicking on the "Containers" check box on the left hand navigation.  Click on the purple icon for **Let's Chat**.  This is the Let's Chat image that you pulled from the public DockerHub registry, tagged with your namespace, and pushed into your private registry.

  You will see a pop-up with the vulnerability assessment shown inline.  This is a red/yellow/green scale.  Your Let's Chat image has a red status of **Deployment Blocked**.  

![letschat](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/8-va-lets-chat.jpg)

3. Click on the **View the vulnerability report for this image** to see the vulnerability assessment in full detail. The details page has two tabs: **Vulnerable Packages** and **Policy Violations**.  

  The *Vulnerable Packages* tab shows you the number of packages scanned, the number of vulnerable packages present in your image, and the number of relevant security notices attached to any of those vulnerable packages.  Your image should now around 107 packages scanned with 0 vulnerable packages and 0 security notices.

  The *Policy Violations* tab shows you how the image compares against your organization's security policies.  This will show the number of rules the image was validated against and any possible policy violations.  Your Mongo image should show around 27 policy rules with 2 associated policy violations (being Password Age and Password Length).  

![imagedetail](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/9-va-lets-chat-details.jpg)

![imagedetail2](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/10-va-lets-chat-details.jpg)

4. From the vulnerability report page, click the **Back to image creation** link. As a Bluemix Organization Manager, you can click on **Manage your org's policies**.  Here you are presented with two boxes - **Deployment Settings for Containers** and **Image Deployment Impact**.  

  The *Deployment Settings for Containers* allows users with the appropriate level of authority to control which images can be deployed based on the vulnerability status.  You can see the multiple options that allows users to *Warn* or *Block* image deployment.

  The *Image Deployment Impact* shows a summary view of the state of all images in your registry.  Images can have statuses of *Deployment Blocked*, *Deploy with Caution*, and *Safe to Deploy*.  This gives you a quick look into which images are troublesome and which images are secure across your entire registry.

![vapolicymgr](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/11-va-policy-mgr-defaults.jpg)

  You will note that the default action is to **Block** deployments that have vulnerabilities.  For our demonstration, select **Warn" for all three situations and click the **SAVE** button.  You will see the **Image Deployment Impact** window recalculate in real time the security posture of the images in your private registry based on the changes to the policy manager in Vulnerability Advisor.  Click the **Back to image creation** link.

![recalcva](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/12-va-policy-mgr-recalc.jpg)

5. You will now see that you can **Deploy with Caution**.

![caution](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/13-deploy-caution.jpg)

You have reviewed your pushed images, which were sourced from a public repository, and can now deploy them on your hosted Bluemix account.  This is a key step in making sure you are running the code which you expect to be running and you are not opening your organization up to security issues, at the expense of agility.  You still want to stay secure, even when moving at light-speed!

## Task 3: Run your web app on Bluemix

Now that you've pushed your images to Bluemix and reviewed the contents of those images through the IBM Containers Vulnerability Advisor, you can run your images the same way you did locally but without any worry of keeping your laptop on all day, every day!  The commands here you'll run aren't that much different than what you did locally.

1. Back at the terminal command line, look and see what images are in your Bluemix hosted registry

         $ cf ic images
         REPOSITORY                                                            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
         registry.ng.bluemix.net/[NAMESPACE]/lets-chat           latest              3aeb3c224c6b        5 minutes ago       241.5 MB
         registry.ng.bluemix.net/[NAMESPACE]/mongo               latest              ae293c6896a1        6 minutes ago       0 B
         registry.ng.bluemix.net/ibm-node-strong-pm                         latest              ef21e9d1656c        13 days ago         528.7 MB
         registry.ng.bluemix.net/ibmliberty                                 latest              2209a9732f35        13 days ago         492.8 MB
         registry.ng.bluemix.net/ibmnode                                    latest              8f962f6afc9a        13 days ago         429 MB
         registry.ng.bluemix.net/ibm-mobilefirst-starter                    latest              5996bb6e51a1        13 days ago         770.4 MB

2. Now run your Mongo container just like you did locally, except this time use `cf ic` instead of `docker` to point to Bluemix.      

  Run your Mongo instance:  
  ```
  $ cf ic run --name lc-mongo -p 27017 -m 128 registry.ng.bluemix.net/[NAMESPACE]/mongo
  71eb28dc-4d95-4a6d-bcaa-93f2382e48b5
  ```

  Show the running container instances.  Wait for a state of `RUNNING` before you proceed:  
  ```
  $ cf ic ps
  CONTAINER ID        IMAGE                                                            COMMAND             CREATED             STATUS                   PORTS               NAMES
  7ebf51a3-35a        registry.ng.bluemix.net/[NAMESPACE]/mongo:latest   ""                  45 seconds ago      Running 27 seconds ago   27017/tcp           lc-mongo
  ```

3. Next run your Let's Chat container just like you did locally, again using `cf ic` instead of `docker` to point to Bluemix.

  Run your Let's Chat instance:  
  ```
  $ cf ic run --name lets-chat --link lc-mongo:mongo -p 8080 -m 128 registry.ng.bluemix.net/[NAMESPACE]/lets-chat
  a5dc5e0d-8eae-44a2-9f8d-548112bec250
  ```

  Show the running container instances.  Wait for a state of `RUNNING` before you proceed:  
  ```
  $ cf ic ps
  CONTAINER ID        IMAGE                                                                COMMAND             CREATED             STATUS                   PORTS               NAMES
  d368a598-69d        registry.ng.bluemix.net/[NAMESPACE]/lets-chat:latest   ""                  10 seconds ago      Building 7 seconds ago   8080/tcp            lets-chat
  7ebf51a3-35a        registry.ng.bluemix.net/[NAMESPACE]/mongo:latest       ""                  2 minutes ago       Running a minute ago     27017/tcp           lc-mongo
  ```

4. Finally, you may need to expose your Let's Chat container to the public internet, so you and your team can start chatting!  The IBM Containers command line tool will attempt to expose your container for you if you have room left in your Public IP Address quota.

  If not, you'll run the `ip list` command to see which IPs are available and then bind one to your running container.

  List available IP addresses for your account:  
  ```
  $ cf ic ip list
  Number of allocated public IP addresses:  2

  IpAddress        ContainerId   
  134.XXX.YYY.ZZ0       
  134.XXX.YYY.ZZ1
  ```      

  If you have no available IP addresses in the response, you can request one:  
  ```
  $ cf ic ip request
  Successfully requested ip 134.XXX.YYY.ZZZ
  ```

  If you have an available IP address, you can bind that IP to your container:  
  ```
  $ cf ic ip bind 134.XXX.YYY.ZZ0 lets-chat
  OK
  The IP address was bound successfully
  ```

  Show running containers with bound IP information now visible:  
  ```
  $ cf ic ps
  CONTAINER ID        IMAGE                                                                COMMAND             CREATED              STATUS                  PORTS                          NAMES
  d368a598-69d        registry.ng.bluemix.net/[NAMESPACE]/lets-chat:latest   ""                  About a minute ago   Running a minute ago    134.XXX.YYY.ZZ0:8080->8080/tcp   lets-chat
  7ebf51a3-35a        registry.ng.bluemix.net/[NAMESPACE]/mongo:latest       ""                  3 minutes ago        Running 3 minutes ago   27017/tcp                      lc-mongo
  ```

5. Check out your running app in your browser, at the IP you just bound.  Remember to use port `8080`!

![letschat1](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/14-lets-chat.jpg)
![letschat2](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/15-lets-chat.jpg)
![letschat3](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/16-lets-chat.jpg)

## Task 4: Cleanup

To ensure you have enough free quota to continue with the lab, let's clean up your container instances.  This can be done through the UI and the **DELETE** button on each container, or you can do this through the CLI with the following commands.

1. To use the command line:

  ```
  $ cf ic stop mongodb
  $ cf ic stop lets-chat
  $ cf if rm -f mongodb
  $ cf if rm -f lets-chat
  ```

## Congratulations!!!  You have successfully accomplished Lab 2.

#### Let's recap what you've accomplished thus far:

- Tagged our images with our Bluemix namespace
- Pushed (uploaded) our images to our private registry in Bluemix on the public IBM Cloud
- Learned about the security posture of our image using Vulnerability Advisor
- Ran our first containers in the cloud

### Time to continue with [Lab 3 - Containers using Bluemix Services](3-Containers-using-Bluemix-Services.md)
