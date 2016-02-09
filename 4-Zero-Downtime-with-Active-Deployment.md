
# Lab 4: Zero-Downtime with the Active Deploy Service (Preview Status)

> **Difficulty**: Intermediate

> **Time**: 25 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Prepare to deploy your updated application](#task-1-prepare-to-deploy-your-updated-application)
- [Task 2: Modify your app and push a new version](#task-2-modify-your-app-and-push-a-new-version)
- [Task 3: Deploy your application](#task-3-deploy-your-application)
- [Task 4: Watch and validate the deployment](#task-4-watch-and-validate-the-deployment)

<br>
**Important Note**: Active Deploy support for Containers on Bluemix is not yet released. This is a preview of the functionality. There is no promised commitment of release of function or of availability date.

## Overview

This lab helps show you the capability of using the Active Deploy service with IBM Containers.

The Active Deploy service provides fully controlled and customized application update deployments, with zero downtime, with your own Bluemix cloud delivery applications. This allows users to update container or cloud foundry applications on IBM Bluemix with zero downtime, by using intelligent update deployment capabilities. It allows full control over the deployment configuration and allows mid-stream acceptance testing.

This lab will show you how to create a sample app, modify it, upload it, and then run the Active Deploy with various options. At the end of this lab, you will know how to use Active Deploy with your container applications.

## Prerequisites
 1. Prior to running this lab, you must have completed the Pre-reqs, Lab 1, Lab 2, Lab 3, and cleaned up your previous deployments.
 2. Optional: For more information, reference the [Active Deploy documentation](https://www.ng.bluemix.net/docs/services/ActiveDeploy/index.html).
 
## Task 1: Prepare to deploy your updated application

This task walks you through setting up a sample application. If you already have an application *that is in a container group*, you can use that application instead of using this sample application.

 1. Get the application code to use for this lab.

	* `git clone https://github.com/crosen188/ibm-containers-interconnect-2016.git`
	* `cd ibm-containers-interconnect-2016/lab_assets/lab4`
	
 2. Set some variables to make the lab easier and to make sure that you are logged in.
	
	The `. prep-lab4.sh` helper script sets some variables that are used later in the lab. These variables include your application name (APPNAME), your Bluemix namespace (NAMESPACE), and a unique user name so that you do not conflict with any other Bluemix user (UNIQNAME).
	You can use the default values, override the defaults and set your own values, or use different lab commands with direct values as you see fit.
	
	a. Run this script to set the default values.

			. prep-lab4.sh
	b. Run the command to log into Bluemix.

			cf login -u EMAIL_ADDRESS -a api.ng.bluemix.net
	c. Run the command to log into the IBM Containers CLI. No arguments are needed. Your Bluemix login environment is detected from the `cf login` command and the IBM Containers CLI is initialized.

			cf ic login

 3. Build and upload the sample application. Build your application, upload it to the server, create a container group with your container image that includes 4 instances of your application, and map a route.
	After you complete this step, you can look at your running application.

	a. Build the code on your computer.

			docker build -t registry.ng.bluemix.net/$NAMESPACE/$APPNAME:1 .

	b. Upload the code to Bluemix.

			docker build -t registry.ng.bluemix.net/$NAMESPACE/$APPNAME:1 .

	c. Create a container group for the initial version that has 4 instances.

			cf ic group create --name $APPNAME-GRP -p 80 --desired 4 registry.ng.bluemix.net/$NAMESPACE/$APPNAME:1
	d. Create a route to see your application.

			cf ic route map --hostname $UNIQNAME-$APPNAME --domain mybluemix.net $APPNAME-GRP

 4. Verify that the container group wwas created and that your application is running.
	
	* Look for your $APPNAME:1 in the list of images in your private Bluemix repository.

			cf ic images
	* Look for your container group $APPNAME-GRP in the list of containers in your Bluemix space.

			cf ic group list
	* Check the site that was mapped, like `$UNIQNAME-$APPNAME.mybluemix.net`. If you need to double check the route, use this command and look for the "Routes" at the end of the output
	
			cf ic group inspect $APPNAME-GRP


You have now deployed your initial sample application.


	
## Task 2: Modify your app and push a new version

 1. Modify index.html. Run this command to rename the file. As an alternative, you could open the file with a text editor and change something in the file rather than revise the file name. 

			cp index.v2 to index.html
 1. Make any other changes you like
 
 1. Run the following commands to build and upload the changed application.	
  This process builds, uploads, and creates a group for your new app version. This time, only 1 instance is created, and the route is not mapped. The Active Deploy step will do that for you.

	a. Build the new version2 file in an image.

		docker build -t registry.ng.bluemix.net/$NAMESPACE/$APPNAME:2 .
    b. Push the new version2 image to your private Bluemix repository.

		docker push registry.ng.bluemix.net/$NAMESPACE/$APPNAME:2
    c. Create another container group for your version2 image.

		cf ic group create --name $APPNAME-GRP2 -p 80 --desired 1 registry.ng.bluemix.net/$NAMESPACE/$APPNAME:2


## Task 3: Deploy your application

Now that the updated application is compiled and uploaded to Bluemix, you are ready to deploy it by using Active Deploy. We will show you the Active Deploy **CLI** commands, but you can also do this with the Active Deploy **Dashboard GUI**.

During the deploy, Active Deploy will:
 * Route traffic to `APPNAME2` and start instances of `APPNAME2` (the Ramp-up Phase)
 * Turn off the route to `APPNAME` after the number of instances of `APPNAME2` is the same as for `APPNAME` (the Test Phase)
 * Finally, reduce the number of instances of `APPNAME` to 1 (the Ramp-down Phase)

   Launch the Active Deploy with phase times that allow you to see progress fairly quickly. You can also see the status of the deployment.

 1. Create the deployment and you can modify the 3 phase times as you like.
 
		cf active-deploy-create $APPNAME-GRP $APPNAME-GRP2 --label "$UNIQNAME Update" --rampup 5m --test 5m --rampdown 2m
 
1. View a list of the current deployments. 

		cf active-deploy-list

1. View the information about your deployment.

		cf active-deploy-show "$UNIQNAME Update"


## Task 4: Watch and validate the deployment

The execution of the deployment takes the total time of your specificed phase times. The interesting part is the first part, where you get traffic from both versions of your application as the service adjusts traffic on the same URL route. Users never lose the functionality of the application as it is updated. You will see the following process:

When the phase is _rampup_:  
  * `cf apps` shows that both `APPNAME` and `APPNAME2` are assigned the same route.
  * Reloading your browser repeatedly should show both versions of your application.

When the phase is _test_ or _rampdown_  
  * `cf apps` shows that only `APPNAME2` has a route assigned to it.
  * Reloading your browser shows only the new version of your application.

When the Active Deploy is complete:  
  * `cf apps` shows that `APPNAME` has only a single instance and is ready to be deleted.

 1. Verify that Bluemix starts routing traffic to both versions.

	a. In your browser, open the URL for your application to see the change that you made.
	
	b. Refresh the browser by pressing F5 every few seconds. You see the change that you made appear and disappear as you reload the browser (the _Ramp-up_ phase).
	
	c. When the test phase begins you only see the APPNAME2 version.

 1. Look for the new deployments by using the list command.

		cf active-deploy-list 
     
1. View information about that deployment. Execute this command repeatedly every 20 seconds or so over time to watch the change in values.

		cf active-deploy-show "$UNIQNAME Update" 
	

When the deployment is displayed, the ramp down phase your deployment is completed.
	
##Congratulations!!!  You have successfully accomplished Lab 4.

####Let's recap what you've accomplished thus far:

- Made a change to your Bluemix container application
- Deployed the new version without taking the original version offline
- Verified that the deployment was running and how it was running

## Optional: Cleanup

To clean up your environment or to try this again, you can delete the deployment. You can also delete your applications and start again if you like.

This cleanup can be done through the user interface by clicking the `DELETE` button for each container, or you can use the CLI by running the `cf ic rm -f [CONTAINER_NAME]` command.

###Next: [Lab 5 Container Group Scaling and Recoverability](5-Container-Group-Scaling-and-Recoverability.md)
