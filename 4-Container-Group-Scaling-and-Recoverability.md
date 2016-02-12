# Lab 4: Container Group Scaling and Recoverability

> **Difficulty**: Intermediate

> **Time**: 20 minutes

> **Tasks**:
>- [Prerequisites](#prerequisites)
- [Task 1: Upload Docker Image to Bluemix](#task-1-upload-docker-image-to-bluemix)
- [Task 2: Create a Container Recovery Group](#task-2-create-a-container-recovery-group)
- [Task 3: Verify Scalability](#task-3-verify-scalability)
- [Task 4: Verify Recoverability](#task-4-verify-recoverability)

## Prerequisites

Prior to running this lab, you must have completed the pre-reqs.

## Task 1: Upload Docker Image to Bluemix

1. Use the Container namespace in subsequent tasks.

  ```
	$ export CONTAINER_NAMESPACE=$(cf ic namespace get)
  ```

<div class="page-break"></div>

2. Upload the Docker image from the Docker public registry to Bluemix as we did earlier using the following command.

  ```
	$ cf ic cpi ragsns/spring-boot registry.ng.bluemix.net/$CONTAINER_NAMESPACE/spring-boot
Sending build context to Docker daemon 2.048 kB
Step 0 : FROM ragsns/spring-boot
 ---> d8dc5ff8d27b
Successfully built d8dc5ff8d27b
The push refers to a repository [registry.ng.bluemix.net/ragsns/spring-boot] (len: 1)
d8dc5ff8d27b: Image already exists
...
ef2704e74ecc: Image already exists
Digest: sha256:8a450a05521481b3df8c052f84c1888a7bc1406b0ee2b4ab0146d4dede043c0c
  ```  

## Task 2: Create a Container Recovery Group

1. Create a Container Recovery Group with 3 (at least greater than 1) instances and port 8080 exposed with the following command.

  ```
  $ cf ic group create  -p 8080 --name spring-boot --hostname spring-boot-$CONTAINER_NAMESPACE --domain mybluemix.net --memory 512 --max 3 --desired 3 --auto registry.ng.bluemix.net/$CONTAINER_NAMESPACE/spring-boot
  Create group in progress
Created group spring-boot (id: 123dbe80-8ae8-434c-ba79-33a64aa82636)
Minimum container instances: 0
Maximum container instances: 3
Desired container instances: 3
  ```

2. Verify the group was created with the following command. Eventually the status will show `CREATE_COMPLETE`.

<div class="page-break"></div>

  ```
  $ cf ic group list
  Group Id                             Name                                Status                              Created                             Updated                             Port
123dbe80-8ae8-434c-ba79-33a64aa82636 spring-boot                         CREATE_COMPLETE                     2015-11-20T16:38:33Z                                                    8080
  ```

3. Inspect the group with the following command.

  ```
  $ cf ic group inspect spring-boot
{
    "Autorecovery": "true",
    "Cmd": [],
    "Creation_time": "2015-12-14T16:39:12Z",
    "Env": [
        "sgroup_name=spring-boot",
        "metrics_target=logmet.opvis.bluemix.net:9095",
        ...
        "metadata_hidden_hostname=instance-00122559"
    ],
    "Id": "241262d9-90a4-4764-bf0a-c48ef8e13b36",
    "Image": "6128feda-2f27-442c-a962-8859a43ee69e",
    "Memory": 512,
    "Name": "spring-boot",
    "NumberInstances": {
        "CurrentSize": 3,
        "Desired": 3,
        "Max": 3,
        "Min": 0
    },
    "Port": 8080,
    "Route_Status": {
        "in_progress": false,
        "message": "registered route successfully",
        "successful": true
    },
    "Routes": [
        "spring-boot-ragsns.mybluemix.net"
    ],
    "Status": "CREATE_COMPLETE",
    "Updated_time": null
}
  ```

## Task 3: Verify Scalability

There is a web service endpoint `/env` that we will invoke now as below.

1. List all the environment variables associated with the application using the following command.

  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env
Environment :
tenant_id = 49911e9c-cf3e-4913-9e20-ff52ed6d34e3
PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DOCKER_WAITFORNET = true
...
space_id = 49911e9c-cf3e-4913-9e20-ff52ed6d34e3
HOME = /root
  ```

2. We are primarily interested in the `HOSTNAME`. A container recovery group automatically creates a load balancer and load balances amongst these different instances. If you invoke the command repeatedly you must see as many different instances as the size of the container recovery group and no more (in this case three).

  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-000abaec
  ```
  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-00122559
  ```
  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-0010b64e
  ```
You will start to see the same instances recycle after a while depending on how the load balancer balances the load.

  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-00122559
  ```

<div class="page-break"></div>

## Task 4: Verify Recoverability

1. Verify that the instances are still running with the following command.

  ```
  $ cf ic group instances spring-boot
Container Id                         Name                                                  Group                               Image                                             Created                             Updated                             State                               Private IP                          Port
1dc25949-b438-475b-8a63-40fab21b2700 sp-hwuf-wqvsqk7ywu3v-xs6i2dvhrutr-server-nh33si6nzus7 spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-02-03 10:05:16 -0500 EST       Running                             172.30.0.222                        8080
b140192a-620c-4ba0-9d82-53822cb56f21 sp-hwuf-rbnbi734lsw7-4qukjqwpvfaf-server-34z3y46o3o6t spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-02-01 10:22:32 -0500 EST       Running                             172.30.0.173                        8080
66ad3b7c-de2d-4707-a7a8-f894302e52e7 sp-hwuf-gdh2kugrqbez-6g3x7aumtnk5-server-aj2czsn3ntak spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-01-23 00:35:17 -0500 EST       Running                             172.30.0.167                        8080
  ```

2. We will stop one of the containers either using the container Id or by issuing a command as below which will extract the container ID of the last container.

  ```
  $ cf ic rm --force $(cf ic group instances spring-boot | tail -1 | awk '{print $1}')
  66ad3b7c-de2d-4707-a7a8-f894302e52e7
  ```

<div class="page-break"></div>

3. Invoking the command immediately after deleting an instance should show that there is an instance (which is about to be recovered) that is not running or showing status as `DELETED`.

  ```
  cf ic group instances spring-boot
Container Id                         Name                                                  Group                               Image                                             Created                             Updated                             State                               Private IP                          Port
1dc25949-b438-475b-8a63-40fab21b2700 sp-hwuf-wqvsqk7ywu3v-xs6i2dvhrutr-server-nh33si6nzus7 spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-02-03 10:05:16 -0500 EST       Running                             172.30.0.222                        8080
b140192a-620c-4ba0-9d82-53822cb56f21 sp-hwuf-rbnbi734lsw7-4qukjqwpvfaf-server-34z3y46o3o6t spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-02-01 10:22:32 -0500 EST       Running                             172.30.0.173                        8080
66ad3b7c-de2d-4707-a7a8-f894302e52e7 sp-hwuf-gdh2kugrqbez-6g3x7aumtnk5-server-aj2czsn3ntak spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-01-23 00:35:17 -0500 EST       Deleted                                                                 8080
  ```
Running the command again should show that the instance has been deleted.

  ```
  cf ic group instances spring-boot  
  Container Id                         Name                                                  Group                               Image                                             Created                             Updated                             State                               Private IP                          Port
1dc25949-b438-475b-8a63-40fab21b2700 sp-hwuf-wqvsqk7ywu3v-xs6i2dvhrutr-server-nh33si6nzus7 spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-02-03 10:05:16 -0500 EST       Running                             172.30.0.222                        8080
b140192a-620c-4ba0-9d82-53822cb56f21 sp-hwuf-rbnbi734lsw7-4qukjqwpvfaf-server-34z3y46o3o6t spring-boot                         registry.ng.bluemix.net/ragsns/spring-boot:latest 2016-02-01 10:22:32 -0500 EST       Running                             172.30.0.173                        8080
  ```

<div class="page-break"></div>

4. After a while, you will notice that a container was just restarted (as in 13 minutes ago) compared with the other containers (that were started a day or more ago).

  ```
  $ cf ic ps -a
  CONTAINER ID        IMAGE                                                           COMMAND             CREATED             STATUS                   PORTS                                                      NAMES

  1dc25949-b43        registry.ng.bluemix.net/ragsns/spring-boot:latest               ""                  13 minutes ago      Running 13 minutes ago   8080/tcp                                                   sp-hwuf-wqvsqk7ywu3v-xs6i2dvhrutr-server-nh33si6nzus7
b140192a-620        registry.ng.bluemix.net/ragsns/spring-boot:latest               ""                  47 hours ago        Running a day ago        8080/tcp                                                   sp-hwuf-rbnbi734lsw7-4qukjqwpvfaf-server-34z3y46o3o6t
b5676e3f-c42        registry.ng.bluemix.net/ragsns/spring-boot:latest               ""                  11 days ago         Running 11 days ago      8080/tcp                                                   sp-hwuf-gdh2kugrqbez-6g3x7aumtnk5-server-aj2czsn3ntak
  ```

5. If you re-run the command to get the `HOSTNAME` of the container, it now cycles between three container IDs but with a new instance ID (`instance-0012673b`) as below.

  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-0012673b
  ```

  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-00122559
  ```
  ```
  $ curl -L spring-boot-$CONTAINER_NAMESPACE.mybluemix.net/env | grep HOSTNAME
  HOSTNAME = instance-0010b64e
  ```

<div class="page-break"></div>

## Cleanup

To continue with another lab, you need to clean up your container group.  This can be done through the UI and the **DELETE** button on each container, or you can do this through the CLI with the following command

  ```
$ cf ic group rm -f spring-boot
  ```

## Congratulations!!!  You have successfully accomplished Lab 4.

#### Let's recap what you've accomplished thus far in this lab:

- Created a Container Group
- Verified scalability and load balancing of the container instances in the group
- Verified recoverability by forcibly deleting an instance and noticing that another instance gets recreated.

## If you are still feeling ambitious, you can test **[Lab 5 - zero downtime upgrades to a Cloud Foundry app.]()**
