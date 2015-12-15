### IBM Containers - solving problems at light speed with a hosted Docker service
##### Prerequisite information necessary to prepare for [InterConnect 2016](https://www.ibm.com/cloud-computing/us/en/interconnect/) lab
###### Session 1506 - Hands-On Lab Demonstrating the Enterprise-Grade Capabilities of IBM Containers

1.  For this lab, the pre-requisite software is already installed, but to continue leveraging IBM Containers on your systems use the following instructions.
    * Install Docker 1.8.1 or later.
    * Install the [Cloud Foundry CLI version 6.12.0 or later][cloud-foundry-cli] from the GitHub repository
    * Install the [IBM Containers plugin][ibm-containers-cli] for the Cloud Foundry CLI
2.  Sign up for an IBM Bluemix account at [https://bluemix.net][bluemix-signup-link]
   ![Bluemix](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/1-bluemix-signup.jpg)
3.  Log into IBM Bluemix 
    * ![Bluemix](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/2-bluemix-login.jpg)
    * ![Bluemix](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/3-bluemix-login.jpg)
    * From the Bluemix dashboard, click **Start Containers**  
    * You will be prompted to **Set registry namespace**.  
    * NOTE: Enter in a memorable, but usable registry name.  You can only set this value **once** and it cannot be changed afterwards.  This registry name is used across your account when using the IBM Containers service.
    * Choose wisely, make it identifiable, but something you will not mind typing while using the CLI nor something that is embarassing.

For any additional questions or comments prior to the lab at InterConnect 2016, please contact us directly: 

   * Chris Rosen - Twitter at [@ChrisRosen188](https://twitter.com/ChrisRosen188) or email crosen@us.ibm.com
   * Rick Osowski - Twitter at [@rosowski](https://twitter.com/rosowski) or email osowski@us.ibm.com
   
 

[bluemix-signup-link]: https://bluemix.net
[cloud-foundry-cli]: https://github.com/cloudfoundry/cli/releases
[ibm-containers-cli]: https://www.ng.bluemix.net/docs/containers/container_cli_cfic.html#container_cli_cfic_install

