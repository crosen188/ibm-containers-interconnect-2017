#!/bin/bash
# ------------------------------------------------------------------
# Container Lab4 helper script
# ------------------------------------------------------------------

export CF_ACTIVE_DEPLOY_ENDPOINT=https://activedeployapi-preprod.mybluemix.net

# define usage function
usage(){
    echo ""
    echo "One or more convenience variables isn't set. In order to make this lab easier, please set these variables (or adjust the commands as you see fit in the lab)"
    echo "  Variable NAMESPACE current value [$NAMESPACE]  - this is your Bluemix Namespace value you are currently logged into"
    echo "  Variable APPNAME current value [$APPNAME]  - A name for your application in bluemix - preset to [lab4] - please change it as you like"
    echo "  Variable UNIQVALUE current value [$UNIQVALUE]  - A value that will not conflict with any other bluemix application"
    echo ""
    exit 1
}

export NAMESPACE=`cf ic namespace get`
echo ""

if [ -z $NAMESPACE ]
then
    echo "NAMESPACE is unset - this probably means you aren't logged into Bluemix properly"
    exit 1
fi

if [ -z $APPNAME ]
then
    export APPNAME=lab4
    echo "APPNAME is unset - I will generate one for you [$APPNAME]. You can export your own variable as you like."
else
    echo "APPNAME is previously set [$APPNAME]"
fi

if [ -z $UNIQVALUE ]
then
    UNIQVALUE=$RANDOM
    echo "UNIQVALUE is unset - I will generate one for you [$UNIQVALUE]. You can export your own variable as you like - perhaps your name with some random numbers."
else
    echo "UNIQVALUE is previously set [$UNIQNAME]"
fi


echo ""
echo "You are now all set to run the lab. These are the values you can now use if you like with the lab commands"
echo "  NAMESPACE current value [$NAMESPACE]"
echo "  APPNAME current value [$APPNAME]"
echo "  UNIQVALUE current value [$UNIQVALUE]"
echo ""
