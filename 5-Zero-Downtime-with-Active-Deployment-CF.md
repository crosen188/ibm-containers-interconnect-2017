
# Lab 5: Zero-Downtime with the Active Deploy Service

> **Difficulty**: Intermediate

> **Time**: 20 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Prepare to deploy your updated application](#task-1-prepare-to-deploy-your-updated-application)
- [Task 2: Modify your app and push a new version](#task-2-modify-your-app-and-push-a-new-version)
- [Task 3: Deploy your application](#task-3-deploy-your-application)
- [Task 4: Watch and validate the deployment](#task-4-watch-and-validate-the-deployment)


## Overview

This lab helps show you the capability of using the Active Deploy service with Bluemix Cloud Foundry Apps.  Today Active Deploy only supports CF apps, but stay tuned for beta support of IBM Containers!

The Active Deploy service provides fully controlled and customized application update deployments, with zero downtime, with your own Bluemix cloud delivery applications. This allows users to update container or cloud foundry applications on IBM Bluemix with zero downtime, by using intelligent update deployment capabilities. It allows full control over the deployment configuration and allows mid-stream acceptance testing.

This lab will show you how to create a sample Cloud Foundry app, modify it, upload it, and then run Active Deploy with various options. At the end of this lab, you will know how to use Active Deploy with your cloud applications.

## Prerequisites
 1. Optional: For more information, reference the [Active Deploy documentation](https://www.ng.bluemix.net/docs/services/ActiveDeploy/index.html).
 
## Task 1: Prepare to deploy your updated application

This task walks you through setting up a sample application. If you already have a Cloud Foundry application, you can use that instead of using this sample.

 1. Get the application code to use for this lab and log in to Bluemix

	* `git clone https://github.com/crosen188/ibm-containers-interconnect-2016.git`
	* `cd ibm-containers-interconnect-2016/lab_assets/activedeploy/cfapps`
	* `cf login -u [EMAIL_ADDRESS] -a api.ng.bluemix.net`
	
 2. Build and upload the sample application and see it running live.
 
	a. Use the CloudFoundry command line to publish the sample application to Bluemix

    `cf push hello_app_1 -i 4`

	This pushes your application to the Bluemix space, runs 4 instances, and assigns it the name `hello_app_1`.
	Look for a line near the end such as: `urls: hello-app-1-[silly unique name].mybluemix.net`

	b. Verify the application is started and routing traffic
	
    `cf app hello_app_1` - you should see the URL route here as well
		
	b. Test the application is running
	
	Go to the **URL** `hello-app-1-[silly unique name].mybluemix.net` you noted above. You should see a "broken" application.
		
	d. (Optional) In the lab directory you can execute `loop-curl-app.sh` and `curl` the application repeatedly, to watch it change as you deploy. Right now you should see the text "Hello, here is your application - BROKEN".
		
    `./loop-curl-app.sh URL`
		
You have now deployed your initial sample application.

	
## Task 2: Modify your app and push a new version

 1. Make a visual change to the application that we can see change

	`cp index.html-v2 index.html`
	
	`cp index.txt-v2 index.txt`
	
	You can also make manual changes as you see fit in an editor.
  
 
 2. Publish the updated version of your application to Bluemix

    `cf push hello_app_2 --no-route`

    Notice the new name `hello_app_2`, and the option `--no-route`, which tells Bluemix not to assign a route to the application

	
## Task 3: Deploy your application

Now that the updated application is compiled and uploaded to Bluemix, you are ready to deploy it by using Active Deploy. We will show you the Active Deploy **CLI** commands, but you can also do this with the Active Deploy **Dashboard GUI**.

This will launch the Active Deploy with phase times that allow you to see progress fairly quickly (in real usage these would be different).

 1. Use the **cf active-deploy-create** command to create a new deployment
	
	It requires the names of the current (routed) version of the application and the new (unrouted) version. `Label` and `phases` are optional but convenient.

    `cf active-deploy-create hello_app_1 hello_app_2 --label activedeploy_lab --rampup 5m --test 5m --rampdown 2m`
	
    Active Deploy will:
    * **Ramp-up Phase** - Route traffic to `hello_app_2` and start ramping up instances of `hello_app_2`
    * **Test Phase** - Turn off the route to `hello_app_1` once the number of instances of `hello_app_2` is the same as for `hello_app_1`
    * **Ramp-down Phase** - Reduce the number of instances of `hello_app_1` to 1


## Task 4: Watch and validate the deployment

The execution of the deployment takes the total time of your specificed phase times. The interesting part is the first part, where you get traffic from both versions of your application as the service adjusts traffic on the same URL route. Users never lose the functionality of the application as it is updated. You will see the following process:

 1. Verify that Bluemix starts routing traffic to both versions
 
    In this next step you will examine 3 things:
	* Use the `cf apps` command to list all the applications in your Bluemix space
	* Use a browser to go to your **URL** for your application to see its status
	* (Optional) In the lab directory you can execute `loop-curl-app.sh` and `curl` the application values repeatedly: `./loop-curl-app.sh URL`	

 2. List the deployments of the Active Deploys service and the specific details

    a. See the Active Deploy List - you should see your new deployment "activedeploy_lab"
	
	`cf active-deploy-list`
	
	b. See information on your deployment - you should see all the details for your deployment
		
	`cf active-deploy-show activedeploy_lab`

 3. Examine the deployment phases and how your application changes
	  
	Execute the 3 examine methods mentioned above:
		
    **Ramp-up Phase**
      * `cf apps` => Show that both `hello_app_1` and `hello_app_2` are assigned the same route - `hello_app_2` instances are increasing
      * Browser & F5 => Show both responses "Hello, here is your application - BROKEN" and "Hello, here is your application - FIXED"
      * `'./loop-curl-app.sh URL` => should alternate between "BROKEN" and "FIXED" and the color changes

    **Test Phase**
      * `cf apps` => Show that only `hello_app_2` has a route assigned to it - both versions have 4 instances
      * Browser & F5 => Show only the response "Hello, here is your application - FIXED"
      * `'./loop-curl-app.sh URL` => should return only "Hello, here is your application - FIXED"

    **Ramp-down Phase**
      * `cf apps` => Show that only `hello_app_2` has a route assigned to it - `hello_app_1` instances are increasing
      * Browser & F5 => Should show only the response "Hello, here is your application - FIXED"
      * `'./loop-curl-app.sh URL` => should return only "Hello, here is your application - FIXED"

    **When the Active Deploy is complete**
      * `cf apps` => Show that the original group `hello_app_1` has only a single instance and the new group `hello_app_2` has 4 instances

 4. Since the deploy has completed, you can now delete the first version of your application

    `cf delete -f hello_app_1`
	

##Congratulations!!!  You have successfully accomplished a zero-downtime deployment on Bluemix using Active Deploy.

####Let's recap what you've accomplished thus far:

- Made a change to your Bluemix cloud application
- Deployed the new version without taking the original version offline
- Verified that the deployment was running and how it was running

## Optional: Cleanup

To clean up your environment or to try this again, you can delete the deployment. You can also delete your applications and start again if you like.

This cleanup can be done through the user interface by clicking the `DELETE` button for each application, or you can use the CLI by running the `cf delete [APPNAME]` command.


