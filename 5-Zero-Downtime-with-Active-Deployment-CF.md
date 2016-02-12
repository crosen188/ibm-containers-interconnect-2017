
# Lab 5: Zero-Downtime with the Active Deploy Service

> **Difficulty**: Intermediate

> **Time**: 15 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Prepare to deploy your updated application](#task-1-prepare-to-deploy-your-updated-application)
- [Task 2: Modify your app and push a new version](#task-2-modify-your-app-and-push-a-new-version)
- [Task 3: Deploy your application](#task-3-deploy-your-application)
- [Task 4: Watch and validate the deployment](#task-4-watch-and-validate-the-deployment)


## Overview

This lab helps show you the capability of using the Active Deploy service with Bluemix Cloud Foundry Apps.

The Active Deploy service provides fully controlled and customized application update deployments, with zero downtime, with your own Bluemix cloud delivery applications. This allows users to update container or cloud foundry applications on IBM Bluemix with zero downtime, by using intelligent update deployment capabilities. It allows full control over the deployment configuration and allows mid-stream acceptance testing.

This lab will show you how to create a sample app, modify it, upload it, and then run the Active Deploy with various options. At the end of this lab, you will know how to use Active Deploy with your cloud applications.

## Prerequisites
 1. Optional: For more information, reference the [Active Deploy documentation](https://www.ng.bluemix.net/docs/services/ActiveDeploy/index.html).
 
## Task 1: Prepare to deploy your updated application

This task walks you through setting up a sample application. If you already have an application, you can use that application instead of using this sample application.

 1. Get the application code to use for this lab and log in to Bluemix

	* `git clone https://github.com/crosen188/ibm-containers-interconnect-2016.git`
	* `cd ibm-containers-interconnect-2016/lab_assets/activedeploy/cfapps`
	* `cf login -u [EMAIL_ADDRESS] -a api.ng.bluemix.net`
	
 2. Build and upload the sample application and see it running live.
 
	a. Use the CloudFoundry command line to publish the sample application to Bluemix

    `cf push hello_app_1 -i 4`

	This pushes 4 instances of the application to your Bluemix space and assigns it the name `hello_app_1`.

	b. Note the route **URL** that is assigned to the application.
	
	Look for a line near the end such as: `urls: hello-app-1-[silly unique name].mybluemix.net`

	c. Verify the application is started and working and routing traffic
	
    `cf app hello_app_1`
		
	Go to the **URL** `hello-app-1-[silly unique name].mybluemix.net` you noted above. You should see a "broken" application.
		
	d. (Optional) You can open a new terminal and `curl` the application repeatedly, to watch it change as you deploy. You should see curl return the text ""Hello, here is your application - BROKEN".
		
    `curl URL/index.txt`
		
You have now deployed your initial sample application.

	
## Task 2: Modify your app and push a new version

 1. Make a visual change to the application that we can see change

	`cp index.html-v2 index.html`
	
	`cp index.txt-v2 index.txt`
	
	You can also make manual changes as you see fit in an editor.
  
 
 2. Publish the updated version of your application to Bluemix. Use this command:

    `cf push hello_app_2 --no-route`

    Notice the new name `hello_app_2`, and the option `--no-route`, which tells Bluemix not to assign a route to the application

	
## Task 3: Deploy your application

Now that the updated application is compiled and uploaded to Bluemix, you are ready to deploy it by using Active Deploy. We will show you the Active Deploy **CLI** commands, but you can also do this with the Active Deploy **Dashboard GUI**.

During the deploy, Active Deploy will:
 * Route traffic to `APPNAME2` and start instances of `APPNAME2` (the Ramp-up Phase)
 * Turn off the route to `APPNAME` after the number of instances of `APPNAME2` is the same as for `APPNAME` (the Test Phase)
 * Finally, reduce the number of instances of `APPNAME` to 1 (the Ramp-down Phase)

   Launch the Active Deploy with phase times that allow you to see progress fairly quickly. You can also see the status of the deployment.

 1. Use the **cf active-deploy-create** command to create a new deployment
	
	It requires the names of the current (routed) version of the application and the new (unrouted) version. Label and phases are optional but convenient.

    `cf active-deploy-create hello_app_1 hello_app_2 --label activedeploy_lab --rampup 5m --test 5m --rampdown 2m`
	
    Active Deploy will:
    * Route traffic to `hello_app_2` and start ramping up instances of `hello_app_2` (the Ramp-up Phase).
    * Turn off the route to `hello_app_1` once the number of instances of `hello_app_2` is the same as for `hello_app_1` (the Test Phase).
    * Finally, reduce the number of instances of `hello_app_1` to 1 (the Ramp-down Phase).


## Task 4: Watch and validate the deployment

The execution of the deployment takes the total time of your specificed phase times. The interesting part is the first part, where you get traffic from both versions of your application as the service adjusts traffic on the same URL route. Users never lose the functionality of the application as it is updated. You will see the following process:

 1. Verify that Bluemix starts routing traffic to both versions:
 
    a. Use the `cf apps` command to list all the applications in your Bluemix space. During the _Ramp-up_ phase, you should see both versions of the application have an assigned route at the **URL**
	
    b. In your browser, you can go to **URL** for your application. During the _Ramp-up_ phase, you should see the text alternate between "BROKEN" and "FIXED"
	
	c. (Optional) You can open a new terminal and `curl` the application, to watch it change as you deploy. You should see the text alternate between "BROKEN" and "FIXED" and the color changes.
		
    `curl URL/index.txt`

 2. List the deployments of the Active Deploys service using the `cf active-deploy-list` command

    a. See the Active Deploy List
	
	`cf active-deploy-list`
	
	b. See information on your deployment
	
	`cf active-deploy-show activedeploy_lab`

    When the phase is _rampup_:
      * `cf apps` should show both that `hello_app_1` and `hello_app_2` are assigned the same route
      * Reloading your browser should show both responses "Hello, here is your application - BROKEN" and "Hello, here is your application - FIXED"
      * Queries using `curl` should alternate between "BROKEN" and "FIXED" and the color changes

    When the phase is _test_:
      * `cf apps` should show that only `hello_app_2` has a route assigned to it
      * Reloading your browser should show only the response "Hello, here is your application - FIXED"
      * Queries using `curl` should return only "Hello, here is your application - FIXED"

    When the phase is _rampdown_:
      * `cf apps` should show that only `hello_app_2` has a route assigned to it
      * Reloading your browser should show only the response "Hello, here is your application - FIXED"
      * Queries using `curl` should return only "Hello, here is your application - FIXED"

    When the Active Deploy is complete:
      * `cf apps` should show that the original group `hello_app_1` has only a single instance and the new group `hello_app_2` has 4 instances

 3. Since the deploy has completed, you can now delete the first version of `hello_app_1` using the `cf delete` command:

    `cf delete -f hello_app_1`
	

##Congratulations!!!  You have successfully accomplished a zero-downtime deployment on Bluemix using Active Deploy.

####Let's recap what you've accomplished thus far:

- Made a change to your Bluemix cloud application
- Deployed the new version without taking the original version offline
- Verified that the deployment was running and how it was running

## Optional: Cleanup

To clean up your environment or to try this again, you can delete the deployment. You can also delete your applications and start again if you like.

This cleanup can be done through the user interface by clicking the `DELETE` button for each application, or you can use the CLI by running the `cf delete [APPNAME]` command.


