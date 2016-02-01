# IBM Containers Hands-on Lab
[InterConnect 2016] (https://www.ibm.com/cloud-computing/us/en/interconnect/) - Labs and tutorials used for IBM Containers, a hosted Docker-based container service on IBM Bluemix.

![InterConnect 2016](https://github.com/crosen188/ibm-containers-interconnect-2016/blob/master/screenshots/interconnect2016.jpg "InterConnect 2016")

## What is IBM Containers?

Use [IBM Containers](http://www.ibm.com/cloud-computing/bluemix/solutions/open-architecture/) to run Docker containers in a hosted cloud environment on IBM Bluemix™. IBM Containers helps you build and deploy containers where you can package your applications and services. Each container is based on an image format, includes a set of standard operations, and is an execution environment in itself.

Containers are virtual software objects that include all the elements that an application needs to run. Each container includes just the app and its dependencies, running as an isolated process on the host operating system. Therefore, it has the benefits of resource isolation and allocation, but is more portable and efficient. Containers help you build high-quality apps, fast.

IBM Bluemix™ provides the IBM Containers infrastructure as a feature that is available in selected regions. Containers enable you to build your app in any language, with any programming tools. On Bluemix, you start developing with containers by using a trusted container image. With your organization’s private registry, you can automate your build pipeline and share artifacts with collaborators through public or private registries, while quickly integrating your container-based applications with over 150 Bluemix services. Containers simplify system administration by providing standardized environments for development and production teams. They help remove the complexity of managing different operating system platforms and underlying infrastructure. Containers help you deploy and run any app on any infrastructure, quickly and reliably.

For those needing an introduction on Docker, please consult [https://docs.docker.com](https://docs.docker.com).

## Available Labs

## Lab 0. [Prerequisites](0-prereqs.md)

## Lab 1. [Introduction to IBM Containers and Docker](1-Intro-to-IBM-Containers-and-Docker.md)
**Difficulty**: Easy  
**Time Required**: 20 minutes  

In this lab, you will learn how to get started using IBM Containers, a hosted offering for managing Docker containers on IBM Bluemix™.

## Lab 2. [Running Docker Images in IBM Containers](2-Running-Docker-Images-in-IBM-Containers.md)
**Difficulty**: Intermediate  
**Time Required**: 30 minutes

In this lab, you will learn how to push images to your hosted private registry on Bluemix, evaluate security vulnerabilities for your pushed images, and run an application with two linked container images.  

## Lab 3. [Containers using Bluemix Services](3-Containers-using-Bluemix-Services.md)  
**Difficulty**: Intermediate  
**Time Required**: 30 minutes

In this lab, you will learn how to bind Bluemix Services to Docker containers, deploy existing applications with one-click via the *Deploy to Bluemix Button*, and understand how the IBM Bluemix DevOps Pipeline can build & deploy your container images automatically.

## Lab 4: [Zero Downtime with the Active Deployment Service](4-Zero-Downtime-with-Active-Deployment.md)
**Difficulty**: Intermediate  
**Time Required**: TBD

In this lab, you will leverage the Active Deploy service to perform app maintenance without requiring any downtime to your production app. Active Deploy uses standard technique(s). For example, Red/Black deployment.

# Legal Disclaimer:
IBM’s statements regarding its plans, directions, and intent are subject to change or withdrawal without notice at IBM’s sole discretion.

Information regarding potential future products is intended to outline our general product direction and it should not be relied on in making a purchasing decision.

The information mentioned regarding potential future products is not a commitment, promise, or legal obligation to deliver any material, code or functionality. Information about potential future products may not be incorporated into any contract. The development, release, and timing of any future features or functionality described for our products remains at our sole discretion.

Performance is based on measurements and projections using standard IBM benchmarks in a controlled environment.  The actual throughput or performance that any user will experience will vary depending upon many factors, including considerations such as the amount of multiprogramming in the user’s job stream, the I/O configuration, the storage configuration, and the workload processed.  Therefore, no assurance can be given that an individual user will achieve results similar to those stated here.

####Acknowledgments and Disclaimers

Availability.  References in this presentation to IBM products, programs, or services do not imply that they will be available in all countries in which IBM operates.

The workshops, sessions and materials have been prepared by IBM or the session speakers and reflect their own views.  They are provided for informational purposes only, and are neither intended to, nor shall have the effect of being, legal or other guidance or advice to any participant.  While efforts were made to verify the completeness and accuracy of the information contained in this presentation, it is provided AS-IS without warranty of any kind, express or implied. IBM shall not be responsible for any damages arising out of the use of, or otherwise related to, this presentation or any other materials. Nothing contained in this presentation is intended to, nor shall have the effect of, creating any warranties or representations from IBM or its suppliers or licensors, or altering the terms and conditions of the applicable license agreement governing the use of IBM software.

All customer examples described are presented as illustrations of how those customers have used IBM products and the results they may have achieved.  Actual environmental costs and performance characteristics may vary by customer.  Nothing contained in these materials is intended to, nor shall have the effect of, stating or implying that any activities undertaken by you will result in any specific sales, revenue growth or other results.

   © Copyright IBM Corporation 2015. All rights reserved.

•	U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

IBM, the IBM logo, ibm.com, Interconnect, IBM Cloud, and IBM Bluemix are trademarks or registered trademarks of International Business Machines Corporation in the United States, other countries, or both. If these and other IBM trademarked terms are marked on their first occurrence in this information with a trademark symbol (® or ™), these symbols indicate U.S. registered or common law trademarks owned by IBM at the time this information was published. Such trademarks may also be registered or common law trademarks in other countries. A current list of IBM trademarks is available on the Web at “Copyright and trademark information” [here](www.ibm.com/legal/copytrade.shtml).
