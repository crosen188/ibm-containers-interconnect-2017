### IBM Containers - solving problems at light speed with a hosted Docker service
##### Prerequisite information necessary to prepare for [InterConnect 2016](https://www.ibm.com/cloud-computing/us/en/interconnect/) lab
###### Session 1506 - Hands-On Lab Demonstrating the Enterprise-Grade Capabilities of IBM Containers

1.  For this lab, the pre-requisite software is already installed, but to continue leveraging IBM Containers on your systems use the following instructions.
    * Install Docker 1.8.1 or later from [Docker](https://docs.docker.com/engine/installation/).  The easiest option is to install the full [Docker Toolbox](https://www.docker.com/docker-toolbox).
    * Install the [Cloud Foundry CLI version 6.12.0 or later][cloud-foundry-cli] from the GitHub repository
    * Install the [IBM Containers plugin][ibm-containers-cli] for the Cloud Foundry CLI
2. During the lab session, you can log into the virtual machine (VM) provided on the lab workstations using these credentials: 
    * Username: containers
    * Password: containers
    * Once the VM has booted, click on the 'containers' account. 
    * ![Login1](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/login1.jpg)
    * Enter the password and click the 'Sign In' button.
    * ![Login2](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/login2.jpg)
    * To access the Terminal window, select 'Activities' and then the 'Terminal' icon.
    * ![Login3](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/login3.jpg)
    * ![Login4](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/login4.jpg)
3. Sign up for an IBM Bluemix account at [https://bluemix.net][bluemix-signup-link]
   ![Bluemix](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/1-bluemix-signup.jpg)
   ![Signup](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/4-bluemix-trial.jpg)
4.  Log into IBM Bluemix 
     ![Bluemix](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/2-bluemix-login.jpg)
     ![Bluemix](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/3-bluemix-login.jpg)
    * From the Bluemix main page, select DASHBOARD, click **Start Containers**  
     ![Start Containers](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/6-start-containers.jpg)
    * Select an image from the list and you will be prompted to **Set registry namespace**.  
     ![Set Namespace](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/5-set-namespace-new.jpg)
    * NOTE: Enter in a memorable, but usable registry name.  You can only set this value **once** and it cannot be changed afterwards.  This registry name is used across your account when using the IBM Containers service.
    * Choose wisely, make it identifiable, but something you will not mind typing while using the CLI nor something that is embarassing.
    * Rules to live by for namespace creation:
       * The name cannot be changed after it is set for an organization.
       * The name can contain only lowercase letters, numbers, and underscores.
       * The name starts with at least one letter or number.
       * The minimum number of characters is 4.
       * The maximum total number of characters is 30.


You can now close this window to cancel the container deployment process.  You are now ready to being lab 1.


 

[bluemix-signup-link]: https://bluemix.net
[cloud-foundry-cli]: https://github.com/cloudfoundry/cli/releases
[ibm-containers-cli]: https://www.ng.bluemix.net/docs/containers/container_cli_cfic.html#container_cli_cfic_install

