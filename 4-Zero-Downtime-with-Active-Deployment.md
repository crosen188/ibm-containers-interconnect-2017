
# Lab 4: Zero-Downtime with the Active Deploy Service

> **Difficulty**: Intermediate

> **Time**: 25 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Prepare to deploy your updated application](#task-1-prepare-to-deploy-your-updated-application)
- [Task 2: Deploy your application](#task-2-deploy-your-Application)
- [Task 3: Watch and validate the deployment](#task-3-watch-and-validate-the-deployment)

## Overview

This lab will walk you through the full Active Deploy getting started function. It will create a sample app if you need to, show you how to modify it and upload it, and then how to run the Active Deploy with various options.
At the end, you will be able to use Active Deploy with your container applications.


## Prerequisites

 1. Prior to running this lab, you must have completed the pre-reqs, lab 1, lab 2, lab 3, and cleaned up your previous deployments
 2. Optional: Reference the full Active Deploy documentation [here](https://www.ng.bluemix.net/docs/services/ActiveDeploy/index.html) for some good additional information
 
## Task 1: Prepare to deploy your updated application

This will walk you through setting up a sample application. If you already have a Container application *that is in a container group*, you can use that intead.

 1. Get application code to use for this lab

	* `git clone https://github.com/crosen188/ibm-containers-interconnect-2016.git`
	* `cd ibm-containers-interconnect-2016/lab_assets/lab4`
	
 2. Set some convenience variables to make the lab easier & make sure you are logged in
	
	The helper script will set some variables that the lab commands will later use. Your application name (APPNAME), your Bluemix namespace (NAMEPSACE), and a unique value so that you don't conflict with any other Bluemix user (UNIQNAME).
	You may use the default values, over-ride them and set them yourself, or use different lab commands with direct values as you see fit.
	
	* `. prep-lab4.sh` - this will set those default values
	* `cf login -u EMAIL_ADDRESS -a api.ng.bluemix.net`
	* `cf ic login` - no arguements needed, it reads your Bluemix login env

 3. Build and upload the sample application	

	* `docker build -t registry.ng.bluemix.net/$NAMESPACE/$APPNAME:1 .` - build the code on this machine
	* `docker push registry.ng.bluemix.net/$NAMESPACE/$APPNAME:1` - upload the code to Bluemix
	* `cf ic group create --name $APPNAME-GRP -p 80 --desired 4 registry.ng.bluemix.net/$NAMESPACE/$APPNAME:1` - create a group for the initial version with 4 initial instances
	* `cf ic route map --hostname $UNIQNAME-$APPNAME --domain mybluemix.net $APPNAME-GRP` - create a route to see your application

 4. Verify what was created and that your application is running
	
	* `cf ic images` - look for your $APPNAME:1
	* `cf ic group list` - look for your groups $APPNAME-GRP
	* Go check the web site it tells you it just mapped - like $UNIQNAME-$APPNAME.mybluemix.net
	
	You have now deployed your initial application

	
## Task 2: Modify your app and push a new version

 1. Modify index.html 
   * `cp index.v2 to index.html` - this is "making a change" for you
   * Make any other changes you like
 
 2. Build and upload the changed application	

   * `docker build -t registry.ng.bluemix.net/$NAMESPACE/$APPNAME:2 .` - build the new version2
   * `docker push registry.ng.bluemix.net/$NAMESPACE/$APPNAME:2` - push the new version 2
   * `cf ic group create --name $APPNAME-GRP2 -p 80 --desired 1 registry.ng.bluemix.net/$NAMESPACE/$APPNAME:2` - create a new group for your version2


## Task 3: Deploy your Application

Now that the updated application is compiled and uploaded to Bluemix, you are ready to deploy it using Active Deploy. We will show you the Active Deploy **CLI** commands, but you can also do this with the Active Deploy **Dashboard GUI**.

During the deploy, Active Deploy will:
 * Route traffic to `APPNAME2` and start ramping up instances of `APPNAME2` (the Ramp-up Phase).
 * Turn off the route to `APPNAME` once the number of instances of `APPNAME2` is the same as for `APPNAME` (the Test Phase).
 * Finally, reduce the number of instances of `APPNAME` to 1 (the Ramp-down Phase).

 1. Use the create command to create a new deployment

   * `cf active-deploy-create $APPNAME-GRP $APPNAME-GRP2 --label "$UNIQNAME Update" --rampup 5m --test 5m --rampdown 2m` - will do the deploy - you can modify the 3 phase times as you like
   * `cf active-deploy-list` - will list the curretn deployments
   * `cf active-deploy-show "$UNIQNAME Update"` - will show you information about your deployment


## Task 4: Watch and validate the deployment

Now that the deployment is created, it will take the total time of your specificed phase times to execute. The really interesting part is the first part, where you get traffic from both versions of your application as the service adjusts traffic on the same URL route - this allows users to never lose functionality of the application as it is updated. Here is what you will see:

When the phase is _rampup_:  
  * `cf apps` should show both that `APPNAME` and `APPNAME2` are assigned the same route.
  * Reloading your browser should show both versions if your application

When the phase is _test_ or _rampdown_  
  * `cf apps` should show that only `APPNAME2` has a route assigned to it.
  * Reloading your browser should show only the new version of your application

When the Active Deploy is complete:  
  * `cf apps` should show that `APPNAME` has only a single instance and is ready to be deleted
 
 1. Verify that Bluemix starts routing traffic to both versions:

	* In your browser, you can go to URL of your application to see the change that you made
	* Continue to hit F5 every few seconds, and you should see the change appear and disappear as you reload the browser (During the _Ramp-up_ phase).
	* When the test phase begins you will only see the APPNAME2 version

 2. List the deployments using the list command

    * `cf active-deploy-list` - You will see your new deployment. Now view information about that deployment
	* `cf active-deploy-show "$UNIQNAME Update"` - will show you information about your deployment
	
	Execute the last command repeatedly every 20 seconds or so over time to watch the change in values.

When the deployment exists the ramp down phase your deployment is completed.
	
##Congratulations!!!  You have successfully accomplished Lab 4.

####Let's recap what you've accomplished thus far:

- Made a change to your Bluemix container application
- Deployed the new version without taking the original version offline
- Verified that the deployment was running and how it was running

## Cleanup

To clean up your environment or to try his again, you can delete the deployment (or leave it, it will just sit there in history). You can also delete your applications and start again if you like.

This can be done through the UI and the `DELETE` button on each container, or you can do this through the CLI with the `cf ic rm -f [CONTAINER_NAME]` command.

###Time to continue with [Lab 5-Container-Group-Scaling-and-Recoverability.md](5-Container-Group-Scaling-and-Recoverability.md)