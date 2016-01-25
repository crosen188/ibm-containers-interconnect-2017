
# Lab 4: Zero-Downtime with the Active Deploy Service

> **Difficulty**: Intermediate

> **Time**: 25 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Prepare to deploy your updated application](#task-1-prepare-to-deploy-your-updated-application)
- [Task 2: Deploy your application](#task-2-deploy-your-Application)
- [Task 3: Watch and validate the deployment](#task-3-watch-and-validate-the-deployment)


## Prerequisites

 1. Prior to running this lab, you must have completed the pre-reqs, lab 1, lab 2, lab 3, and cleaned up your previous deployments.
 2. Add the Active Deploy service to your dashboard space - link => https://console.ng.bluemix.net/catalog/active-deploy/ then select `create`
 3. Ensure that the Container you will update is running - **HOW DO WE DO THIS**
 4. Optional: Reference the full documentation reference [here](https://www.ng.bluemix.net/docs/services/ActiveDeploy/index.html) for some good additional information.

**CARL: Insert screen shots and snippets directly**

## Task 1: Prepare to deploy your updated application

If you want to deploy a new version of your application, and prevent it from being taken offline while that happens, you need to update your code and get that staged to the Bluemix server.

 0. Set the "name" of your application
 
	If your app is "Lisa-bridge-app" set this
	
	`export APPNAME="Lisa-bridge-app"`

 1. Make a change to your application

  * Load a file from your Container - **CHRIS: What file in what location on that machine do you recommend?)**
  * Make a change - something visual you can see change when you hit F5 in your browser - for example: **CHRIS EXAMPLE**
  * Save it 

 2. Upload your change to the Bluemix server
 	
	`cf ic build -t ${APPNAME}:v2 ${APPNAME}_container`
	- the last arg is wherever your local directory

	`NAMESPACE=$(cf ic namespace get)`
	
	`cf ic group create --name ${APPNAME}2 registry.ng.bluemix.net/$NAMESPACE/${APPNAME}:v2`
	
	
 3. Verify that the application was uploaded properly
 
 	`cf ic group list`
 
  Now you are ready to deploy the application using Active Deploy
 

## Task 2: Deploy your Application

Now that the updated application is compiled and uploaded to Bluemix, you are ready to deploy it using Active Deploy. You can do this using the Active Deploy **CLI** commands, or you can do this using the Active Deploy **Dashboard GUI** (same exact operation).

During the deploy, Active Deploy will:
 * Route traffic to `APPNAME2` and start ramping up instances of `APPNAME2` (the Ramp-up Phase).
 * Turn off the route to `APPNAME` once the number of instances of `APPNAME2` is the same as for `APPNAME` (the Test Phase).
 * Finally, reduce the number of instances of `APPNAME` to 1 (the Ramp-down Phase).

Note: Before continuing, in preperation for **Task 3**, prepare the browser page with your application URL so you can refresh and watch it change during deployment
 
**CLI**

1. Use the create command to create a new deployment.

	`cf active-deploy-create ${APPNAME} ${APPNAME}2 --label "Appname Update" --rampup 10m --test 10m --rampdown 2m`
	
**Dashboard**

 1. Go to the Bluemix Dashboard and click on the `Active Deploy` service tile
 
 2. Create a new deployment
  * Click on the `Create New Deployment` button.
  * Under the `Select Current Version` section, select `APPNAME`
  * Under the `Select New Version` section, select `APPNAME2`.
  * Fill in a label - "Appname Update" would work
  * Fill in description if you like
  * Keep `Transition type` as the default "Automatic"
  * Fill in for the phase times - Use Ramp up: 10 min, Test 10 min, Rampe Down: 2 min (these cause the deployment to happen in a reasonable lab time-frame)
 
 3. Execute the Deployment
  * Click the `Create` button to create the new deployment. Upon successful creation, the page will display the details of the new deployment.

## Task 3: Watch and calidate the deployment

Now that the deployment is created, it will take the total time of your specificed phase times to execute. The really interesting part is the first part, where you get traffic from both versions of your application as the service adjusts instances on the same URL route - this allows users to never lose functionality of the application as it is updated. Here is what you will see:

When the phase is _rampup_:  
  * `cf apps` should show both that `APPNAME` and `APPNAME2` are assigned the same route.
  * Reloading your browser should show both versions if your application

When the phase is _test_ or _rampdown_  
  * `cf apps` should show that only `APPNAME2` has a route assigned to it.
  * Reloading your browser should show only the new version of your application

When the Active Deploy is complete:  
  * `cf apps` should show that `APPNAME` has only a single instance and is ready to be deleted

 Note: You specified 10 minutes for each phase - if you are done looking at that phase, you can issue the command `cf active-deploy-advance "Appname Update"` or click the `Force Advance` Button and it will move to the next phase
 
**CLI**

 1. Verify that Bluemix starts routing traffic to both versions:
 
	* Use the `cf apps` command to list all the applications in your Bluemix space
	* During the _Ramp-up_ phase, you should see both versions of the application have an assigned route
	* In your browser, you can go to URL of your application to see the change that you made
	* Continue to hit F5 every few seconds, and you should see the change appear and disappear as you reload the browser (During the _Ramp-up_ phase).

 2. List the deployments using the list command

    `cf active-deploy-list`
	
	You will see your new deployment. Now view information about that deployment
	
	`cf active-deploy-info "Appname Update"`

	Execute the last command repeatedly every 15-30 seconds or so over time to watch the change in values.
    
**Dashboard**

 1. List all deployments and look at details
 
 After you hit `Create Deployment` button you are taken to a screen with all the information about your deployment, such as the phase completion times and estimated traffic to each version of the application. You can also get here from the main dashboard screen to look at information if you exit this screen. It also provides the ability to take actions on the deployment, such as pause, rollback, and advance. You can click the `Refresh` icon in the top right of the deployment details page to refresh the contents of the page.
 
 2. Verify that Bluemix starts routing traffic to both versions
 
 The traffic balance in the bottom right part of the deployment info screen shows the routed traffic balance between versions.
	* During the _Ramp-up_ phase, you should see both versions of the application have an assigned route
	* In your browser, you can go to URL of your application to see the change that you made
	* Continue to hit F5 every few seconds, and you should see the change appear and disappear as you reload the browser (During the _Ramp-up_ phase).
 
 You can also hit `Back to Dashboard` => `Containers` to see your applications and see the status and routing of the containers.
 

## Cleanup

To clean up your environment or to try his again, you can delete the deployment (or leave it, it will just sit there in history). You can also delete your applications and start again if you like.

This can be done through the UI and the `DELETE` button on each container, or you can do this through the CLI with the `cf ic rm -f [CONTAINER_NAME]` command.

##Congratulations!!!  You have successfully accomplished lab 4.

####Let's recap what you've accomplished thus far:

- Made a change to your Bluemix container application
- Deployed the new version without taking the original version offline
- Verified that the deployment was running and how it was running

